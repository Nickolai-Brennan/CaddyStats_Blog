-- =========================
-- Caddy Stats Publishing DB
-- PostgreSQL 14+
-- =========================

-- Extensions (optional but recommended)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ---------- ENUMS ----------
DO $$ BEGIN
  CREATE TYPE post_status AS ENUM ('draft','scheduled','published','archived');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE page_type AS ENUM ('post','page');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ---------- AUTHORS ----------
CREATE TABLE IF NOT EXISTS authors (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  display_name    TEXT NOT NULL,
  slug            TEXT NOT NULL UNIQUE,
  bio             TEXT,
  avatar_url      TEXT,
  social_json     JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- CATEGORIES ----------
CREATE TABLE IF NOT EXISTS categories (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,
  slug         TEXT NOT NULL UNIQUE,
  description  TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- TAGS ----------
CREATE TABLE IF NOT EXISTS tags (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,
  slug         TEXT NOT NULL UNIQUE,
  description  TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- POSTS / PAGES ----------
CREATE TABLE IF NOT EXISTS content_items (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type               page_type NOT NULL DEFAULT 'post',
  status             post_status NOT NULL DEFAULT 'draft',

  title              TEXT NOT NULL,
  subtitle           TEXT,
  slug               TEXT NOT NULL UNIQUE,
  excerpt            TEXT,

  author_id           UUID REFERENCES authors(id) ON DELETE SET NULL,

  -- Event metadata (for golf posts; nullable for generic pages)
  event_name          TEXT,
  course_name         TEXT,
  event_start_date    DATE,
  event_end_date      DATE,

  -- SEO fields (WordPress-equivalent and better)
  meta_title          TEXT,
  meta_description    TEXT,
  canonical_url       TEXT,
  og_title            TEXT,
  og_description      TEXT,
  og_image_url        TEXT,
  twitter_title       TEXT,
  twitter_description TEXT,
  twitter_image_url   TEXT,
  featured_image_url  TEXT,
  featured_image_alt  TEXT,
  noindex             BOOLEAN NOT NULL DEFAULT FALSE,

  -- Publishing timestamps
  published_at        TIMESTAMPTZ,
  scheduled_for       TIMESTAMPTZ,

  -- Body storage: block JSON (authoring), and compiled HTML (frontend rendering)
  blocks_json         JSONB NOT NULL DEFAULT '[]'::jsonb,
  body_html           TEXT NOT NULL DEFAULT '',

  -- Internal “SEO footer” / editorial notes (not displayed)
  focus_keyword       TEXT,
  secondary_keywords  TEXT[] NOT NULL DEFAULT ARRAY[]::text[],
  internal_notes      TEXT,

  -- Full-text search (auto-updated by app or trigger)
  search_tsv          TSVECTOR,

  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_content_status_published
  ON content_items(status, published_at DESC);

CREATE INDEX IF NOT EXISTS idx_content_type
  ON content_items(type);

CREATE INDEX IF NOT EXISTS idx_content_author
  ON content_items(author_id);

-- Full-text + trigram for quick search
CREATE INDEX IF NOT EXISTS idx_content_search_tsv
  ON content_items USING GIN(search_tsv);

CREATE INDEX IF NOT EXISTS idx_content_title_trgm
  ON content_items USING GIN(title gin_trgm_ops);

-- ---------- POST <-> CATEGORIES (1–2 recommended, but DB allows many; enforce in app) ----------
CREATE TABLE IF NOT EXISTS content_categories (
  content_id   UUID NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  category_id  UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  PRIMARY KEY (content_id, category_id)
);

CREATE INDEX IF NOT EXISTS idx_content_categories_category
  ON content_categories(category_id);

-- ---------- POST <-> TAGS (5–10 recommended; enforce in app) ----------
CREATE TABLE IF NOT EXISTS content_tags (
  content_id  UUID NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  tag_id      UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (content_id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_content_tags_tag
  ON content_tags(tag_id);

-- ---------- MEDIA (optional; for an internal library) ----------
CREATE TABLE IF NOT EXISTS media_assets (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  url           TEXT NOT NULL,
  mime_type     TEXT,
  file_name     TEXT,
  width         INT,
  height        INT,
  alt_text      TEXT,
  caption       TEXT,
  credits       TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- REDIRECTS ----------
CREATE TABLE IF NOT EXISTS redirects (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_path     TEXT NOT NULL UNIQUE,
  to_path       TEXT NOT NULL,
  status_code   INT NOT NULL DEFAULT 301,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------- SIMPLE REVISION HISTORY ----------
CREATE TABLE IF NOT EXISTS content_revisions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_id    UUID NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  editor_label  TEXT,
  blocks_json   JSONB NOT NULL,
  body_html     TEXT NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_revisions_content
  ON content_revisions(content_id, created_at DESC);
