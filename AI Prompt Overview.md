

## 🏌️ Caddy Stats Blog — Instructional Build Prompt

ROLE

You are a senior digital publishing architect + SEO strategist building a premium golf analytics blog called Caddy Stats.

The site focuses on:

PGA Tour events

Player performance data

Betting odds & value

Fantasy golf insights

Course fit & stat modeling


The site must feel editorial, trustworthy, fast, and data-first.


---

CORE REQUIREMENTS

1️⃣ SITE STRUCTURE (KEEP IT SIMPLE)

The site has only two content views:

🔹 View A — Magazine Layout

Hero feature article

Secondary featured cards

Visual, editorial feel

Used for:

Weekly tournament previews

Flagship analysis pieces

Model breakdowns



🔹 View B — Sports Blog Layout

3-column layout (fixed ratio):

Left (20%) → Ads / Sponsors / Tools

Center (50%) → Main content feed (posts)

Right (30%) → Social embeds + widgets


Used for:

Daily posts

Picks & bets

Player trend notes

Short-form analysis



---

2️⃣ SEO & DISCOVERY (WORDPRESS-LEVEL OR BETTER)

Every post MUST support:

🔍 Core SEO Fields

Meta Title (≤ 60 chars)

Meta Description (≤ 160 chars)

Canonical URL

Index / No-Index toggle

OpenGraph (Facebook)

Twitter / X Card

Featured Image with alt text

Structured Headings (H1–H4)


🧠 Schema Markup (Auto-Generated)

Article

SportsEvent (when applicable)

Person (players)

Organization (PGA Tour)

BreadcrumbList


🏷️ Taxonomy System

Categories (1–2 max per post):

PGA Tour Events

Betting & Odds

Fantasy Golf

Player Profiles

Course Analysis

Data Models


Tags (5–10 per post):

Tournament name

Course name

Player names

Key stats (SG:T2G, OTT, Putting)

Bet types (Top-10, Make Cut, Outright)



---

3️⃣ DATA & TABLE SUPPORT (NON-NEGOTIABLE)

The platform must support rich, interactive data blocks:

Table Capabilities

Sortable columns

Sticky headers

Mobile scroll

Percentiles & heat-map cells

Odds formatting (+1200, −110)

Tooltips for stat definitions

CSV export (optional)


Data Sources (Referenced, Not Scraped Live)

PGA Tour stats

Model outputs

Betting markets

Historical performance



---

4️⃣ POST TEMPLATE (REUSABLE)

Use this exact structure for every article.


---

📝 Caddy Stats Post Template

🔹 Post Header

Title (H1):

Subtitle / Deck:

Event Name:

Course:

Dates:

Author:

Publish Date:

Last Updated:



---

🔹 Intro (150–250 words)

Explain:

Why this event matters

What the course demands

How data informs the analysis



---

🔹 Course Breakdown

Key course traits

Historical scoring

Winning profile

Correlated stats



---

🔹 Key Stats That Matter

(Table)

SG: Tee-to-Green

SG: Approach

Driving Distance

Fairways Gained

Putting (Bent/Poa/etc.)



---

🔹 Player Rankings / Model Output

(Table)

Player

Model Rank

Odds

Implied Probability

Value Score



---

🔹 Best Bets

Outright picks

Top-10 / Top-20

Make Cut plays

Long shots



---

🔹 Fantasy Golf Notes

Cash plays

GPP pivots

Ownership leverage



---

🔹 Closing Summary

Final thoughts

Risk notes

Bankroll discipline



---

🔹 SEO Footer (Hidden on Frontend)

Focus Keyword

Secondary Keywords

Slug

Meta Description

Internal links

External references



---

5️⃣ HIGH-END WYSIWYG EDITOR (WSGY SPEC)

The editor must feel professional, not like a blog toy.

Required Features

Block-based editing

Markdown + Rich Text hybrid

Drag-and-drop tables

Inline charts

Callout boxes (Insight, Bet, Warning)

Stat badge components

Odds formatting helper

Headings auto-mapped to TOC

Mobile preview toggle


Editor Blocks

Text

Heading

Data Table

Chart

Image + Caption

Quote

Callout

Divider

Embed (X, YouTube, Odds widget)


UX Goals

No clutter

No pop-ups

No visual overload

Editor should feel closer to:

Notion + Datawrapper + Medium

NOT WordPress Classic




---

6️⃣ PERFORMANCE & TRUST

Fast load times

Minimal scripts

Clear disclosures (betting)

Transparent methodology

Consistent formatting



---

OUTPUT EXPECTATION

The final system should allow:

Fast posting

Consistent formatting

Strong SEO

Data-first storytelling

High reader trust

Easy social sharing



---

Add these pages

1) About (Caddy Stats)

Purpose: establish credibility + explain the data angle.

Sections

Hero: “Data-driven PGA previews, betting value, and fantasy edges.”

Mission: what you publish and why it’s different (model-first, transparent)

Methodology (short): what inputs you use (SG splits, course fit, odds, form), how often updated

Editorial policy: disclosure + “not financial advice” + betting responsibility

Brand tie-in: “A Strik3Zone.com project” + link back to parent

Press/Collab CTA: short form button (goes to Contact)


SEO

Title: “About Caddy Stats | PGA Betting + Fantasy Golf Analytics”

Meta description with keywords (PGA Tour betting picks, fantasy golf projections, strokes gained)

Schema: AboutPage + Organization (Strik3Zone) + WebSite



---

2) Contact (Caddy Stats)

Purpose: partnerships, reader messages, data requests, guest posts.

Form fields

Name

Email

Topic dropdown: Collaboration / Sponsorship / Data request / Guest post / Other

Message

Consent checkbox (privacy)


Extras

Social links block

“Work with us” mini section for sponsors

Simple spam protection (honeypot + rate limiting + optional Turnstile)


SEO + compliance

Title: “Contact Caddy Stats”

Schema: ContactPage

Add Privacy Policy + Terms links in footer (even if minimal)



---

3) Strik3Zone.com directory page (Parent Company)

Create a Directory / Network page at: strik3zone.com/directory (or /brands).

Layout

Hero: “Strik3Zone Network”

Grid of properties (logo, short description, primary CTA)

Caddy Stats (Golf data + odds + fantasy)

Fantasy Sports HQ

BetGenie

STORM (bullpen analytics)

etc.


Filters: Sport (Golf/Baseball/Football…), Type (Blog/Tool/Community/API)

Trust/footer: mission + contact + partnership inquiry


SEO

Title: “Strik3Zone Directory | Tools, Blogs, Analytics”

Schema: CollectionPage + Organization



---

Best Tech Stack for this blog (FastAPI + GraphQL + Postgres + React)

You asked “Vite or whichever is best for blogging.” For blogging, you want:

SEO + fast pages

Great editor experience

Simple publishing workflow

Data tables + interactive blocks


Recommended architecture (best fit)

Frontend

React + TanStack Router + TanStack Query

Vite for dev/build speed

SSR for SEO via one of these options (pick 1):

1. Vike (vite SSR) — keeps Vite + React, adds SSR cleanly


2. Next.js — best “blogging SEO defaults,” but replaces Vite


3. Remix — great SEO + forms, but different mental model




My recommendation given your stack: React + Vite + Vike (SSR)
You keep Vite and still get server-rendered pages for SEO-critical content.

Backend

FastAPI (Python)

GraphQL with Strawberry GraphQL (clean DX in Python)

PostgreSQL

ORM: SQLAlchemy 2.0 (or SQLModel if you prefer)

Migrations: Alembic

Auth (optional): JWT + refresh tokens (or session cookies)


Editor / CMS

Best approach: Headless CMS-like “Admin App” you own

A private /admin React app using the WYSIWYG blocks you specified

Stores posts as structured JSON blocks + compiled HTML


Editor engine options:

Tiptap (Pro-grade, extensible, best for custom blocks/tables)

Lexical (powerful, more engineering)

CKEditor5 (premium, heavier)



My recommendation: Tiptap + custom blocks (DataTable, OddsCard, PlayerCard, Callout)

Search

Simple: Postgres full-text search first

Upgrade later: Meilisearch / Typesense


Caching

Redis (optional) for heavy pages (rankings, models)


Hosting

Frontend (SSR): Node runtime (or edge if supported by provider)

Backend: containerized FastAPI

DB: managed Postgres



---

Why SSR matters here (quick)

A “pure Vite SPA” is fine for apps, but blog SEO is easier with SSR:

search engines get complete HTML instantly

clean metadata + OG tags per post

faster “first contentful paint” for readers


So: Vite yes — but add SSR via Vike.


---

Minimal page map (Caddy Stats + parent directory)

Caddy Stats

/ (Magazine view home)

/blog (Sports blog 20/50/30 layout)

/post/:slug

/category/:slug

/tag/:slug

/about

/contact

/sitemap.xml + /rss.xml


Strik3Zone

/directory (network page)

Each property links out (or can live as subpaths later)



---

