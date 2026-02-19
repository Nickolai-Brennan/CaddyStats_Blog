🏗️ Caddy Stats — Technical Architecture Document

1) Architecture Goals

Fast publishing + rich data embeds (tables, charts, odds, model outputs) inside articles.

Two data domains kept clean:

Content domain (CMS-like): posts, authors, tags, SEO, comments.

Stats domain (analytics): players, tournaments, courses, projections, betting lines.


GraphQL-first experience for frontend consumption (typed, composable queries).

Scalable ingestion for external golf data sources and periodic model refresh.



---

2) High-Level System Diagram

flowchart LR
  U[User Browser] --> FE[Frontend: React + Vite + TanStack]
  FE -->|GraphQL| GQL[API Gateway: FastAPI + Strawberry GraphQL]
  GQL --> AUTH[Auth/RBAC Module]
  GQL --> CMS[(Postgres: Content Schema)]
  GQL --> STATS[(Postgres: Stats Schema)]
  GQL --> CACHE[(Redis Cache - optional)]

  ING[Ingestion Workers] --> STATS
  ING --> OBJ[(Object Storage: Images/Exports)]
  ADM[Admin/Editor UI] --> FE

  GQL --> OBS[Observability: Logs/Metrics/Tracing]


---

3) Core Components

A) Frontend (React + Vite)

Responsibilities

Multi-view UI (Magazine / Article / Archive)

Post rendering with embedded widgets (tables, charts, odds board)

Editor UI for authoring posts with structured blocks


Key Libraries

TanStack Query: caching + request lifecycle

TanStack Table: sortable/filterable archive and stat tables

Editor: block-based editor (WSYW + “data blocks”)


Front-end routes

/ Magazine view

/posts/:slug Article view

/archive Archive table view

/players/:id Player profile view (projection + trends)

/tournaments/:id Tournament hub (course fit + picks)

/admin/* Admin/editor dashboard



---

B) API Layer (FastAPI + Strawberry GraphQL)

Responsibilities

Single typed API surface for the frontend

Resolver orchestration across content + stats

Permission enforcement (RBAC)

Query cost controls + caching


GraphQL Domains (logical modules)

content module: posts, authors, categories, tags, SEO, comments

stats module: players, tournaments, rounds, course stats, strokes gained, projections

betting module: odds, lines, markets, implied probability, movement

media module: image upload metadata, exports



---

C) Database (PostgreSQL — split by schema)

Use one Postgres instance with two schemas for clean separation:

content.* (CMS domain)

stats.* (analytics domain)


This keeps deployment simple while preserving boundaries.


---

D) Ingestion + Modeling (Workers)

Responsibilities

Pull data from sources (DataGolf / scraped feeds / manual uploads)

Normalize into stats.*

Run projection models and store outputs

Maintain derived tables/materialized views for fast reads


Execution

Scheduled jobs (cron / task runner)

Optional async queue (Celery/RQ/Arq) later



---

E) Storage (Object Storage)

For:

Post images

Embedded assets

Exported PDFs/CSVs

Cached chart images (optional)


Could be S3-compatible.


---

4) Key Data Flows

Flow 1: Reader loads article

1. Frontend requests PostBySlug(slug) via GraphQL


2. API returns:

Post content blocks

SEO metadata

Referenced data-block IDs



3. Frontend triggers additional GraphQL queries per block:

PlayerStats(playerId, range)

TournamentPreview(tournamentId)

OddsBoard(eventId)



4. Tables render via TanStack Table; charts from stats series.




---

Flow 2: Author creates/edits post

1. Admin UI uses editor to create blocks:

Text, headings, images

Data blocks (table definition + query reference)



2. Save draft → content.posts + content.post_blocks


3. Publish → version snapshot + SEO generation


4. Optional: create “static caches” for expensive blocks.




---

Flow 3: Data ingestion & projection refresh

1. Worker pulls raw feeds


2. Normalizes entities (players, tournaments, courses)


3. Writes to stats.* tables


4. Runs projections; writes to stats.projections_*


5. Updates materialized views


6. API cache warmed (optional)




---

5) Suggested Table/Entity Map (High-Level)

Content schema (CMS)

content.users

content.authors (or same as users w/ roles)

content.posts

content.post_versions

content.post_blocks (block-based editor output)

content.categories

content.tags

content.post_tags

content.seo_meta

content.comments (optional)


Stats schema (Analytics)

stats.players

stats.tournaments

stats.courses

stats.course_holes (optional)

stats.rounds

stats.player_round_stats

stats.strokes_gained_splits

stats.betting_markets

stats.odds_snapshots

stats.projections_event

stats.projections_player

stats.model_runs (tracking, reproducibility)



---

6) Auth, Roles, Permissions (RBAC)

Roles

admin (full access)

editor (create/publish posts)

writer (draft only)

subscriber (premium content)

public (read-only)


Enforcement

GraphQL directives / resolver guards:

@requiresRole(role: "editor")

@requiresSubscription(tier: "pro")




---

7) Performance & Caching Strategy

TanStack Query client caching (primary)

API server caching:

request-level caching for common queries (home, top stories)

optional Redis for:

“odds board”

“tournament preview”



DB performance:

indexes on slugs, IDs, timestamps

materialized views for leaderboard-like aggregations

partition large stats tables by season/event if needed later




---

8) Observability & Reliability

Structured logs (request id + user id)

Metrics:

resolver timings

DB query time

cache hit rate


Tracing (OpenTelemetry-ready)

Error reporting (Sentry-style)



---

9) Deployment Topology (Pragmatic MVP → Scale)

MVP (simple)

Frontend on Vercel/Netlify

FastAPI GraphQL on Railway/Render/Fly

Postgres on Neon/Supabase

Object storage (S3-compatible)


Scale-ready

API behind reverse proxy

Redis cache

Worker pool for ingestion + models

Read replicas for Postgres if needed



---

10) Security Baselines

JWT or session tokens (httpOnly cookies recommended)

Rate limiting on GraphQL

Query depth/cost limiting

Input validation (Pydantic + strict GraphQL types)

Signed URLs for uploads

Separate admin routes + stricter RBAC



---

11) What to Build First (Architecture Order)

1. DB schemas (content + stats)


2. GraphQL API: Posts, Tags, PostBlocks, Player, Tournament


3. Frontend views: Magazine + Article + Archive


4. Editor MVP: basic blocks + data-block references


5. Ingestion worker: one source → normalize → projections table


6. Odds board module (optional early win)




---

