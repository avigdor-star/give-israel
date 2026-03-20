# CLAUDE.md — Give Israel Project Context

## What Is This Project

Give Israel (giveisrael.charity) is the most comprehensive online directory of Israeli charities. Visitors browse, search, filter by category, and click through to donate directly on each charity's own website. Think of it like an Amazon for Israeli giving — but instead of buying products, you're finding causes to support.

The owner (Avigdor) is not a developer. All explanations and changes should be simple, clear, and jargon-free. Never change anything unless Avigdor has explicitly said to.

---

## Live URLs

- **Main site**: https://giveisrael.charity
- **Admin dashboard**: https://giveisrael.charity/admin
- **GitHub repo**: https://github.com/avigdor-star/give-israel

---

## Project Structure

```
Desktop/give-israel/
├── public/                     ← DEPLOYED FOLDER (Vercel serves this)
│   ├── index.html              ← The entire main site (single file — HTML, CSS, JS all in one)
│   ├── admin.html              ← Admin dashboard for reviewing & publishing suggestions
│   ├── og-image.jpg            ← Feature image for social sharing (WhatsApp, Facebook, Twitter)
│   └── og-image.png            ← Backup/generated OG image (map style, not currently in use)
├── vercel.json                 ← Vercel hosting config (headers, security, routing)
├── package.json                ← Project metadata (no build step — static site)
├── .gitignore                  ← Ignores node_modules, .vercel, .DS_Store
├── README.md                   ← Short GitHub readme
├── GIVE-ISRAEL-DOCS.md         ← Full project documentation (tables, categories, how-tos)
├── LIGHT-UP-ISRAEL-FEATURE-SPEC.md ← Feature spec for the "Light Up Israel" interactive map (not yet built)
├── GiveIsrael-Language-Toggle-Research.md ← Mikoshi Protocol research for Hebrew/English i18n
├── GiveIsrael-Security-Stress-Test.docx ← Security audit document
├── Give Isreal.jpg             ← Original feature image source file
├── find-your-cause-demo.html   ← Demo/prototype file
├── light-up-israel-demo.html   ← Demo/prototype of the Light Up Israel feature
├── logo-concepts.html          ← Logo design explorations
└── preview-hero.html           ← Hero section preview/prototype
```

---

## Tech Stack

| Piece | What It Is | Details |
|-------|-----------|---------|
| **Frontend** | Single HTML files | No frameworks, no build tools. All CSS and JS are inline in each HTML file |
| **Database** | Supabase (free tier) | Stores all charity data, categories, and community suggestions |
| **Hosting** | Vercel (free tier) | Auto-deploys from GitHub on every push |
| **Domain** | giveisrael.charity | Registered on Namecheap, DNS pointed to Vercel |
| **Code repo** | GitHub | github.com/avigdor-star/give-israel |
| **Fonts** | Google Fonts | English: Cormorant Garamond + Figtree · Hebrew: Frank Ruhl Libre + Heebo |
| **i18n** | Built-in toggle | Hebrew/English with RTL support, geolocation default, localStorage persistence |
| **Geolocation** | ipapi.co (free) | Detects Israel visitors → defaults to Hebrew; everyone else → English |
| **Logos** | Google Favicon API | Auto-pulled from each charity's website |

---

## Supabase Database

- **Project name**: Give Israel
- **Project ID**: psrtcjaxfeutecirypwd
- **Region**: us-east-1
- **Dashboard**: https://supabase.com/dashboard/project/psrtcjaxfeutecirypwd
- **API URL**: https://psrtcjaxfeutecirypwd.supabase.co
- **Anon Key** (public, read-only): eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzcnRjamF4ZmV1dGVjaXJ5cHdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5NTcxMDIsImV4cCI6MjA4OTUzMzEwMn0.4aJK0277vZudaRtvmCpEhfWhHkbrXyHIc_2f8DgqZkQ

### Row Level Security (RLS)
- Anyone can **read** charities and categories
- Anyone can **submit** suggestions (via edge function)
- Only Avigdor can edit/delete via the Supabase dashboard
- Admin auth uses Supabase Auth (email/password login on admin.html)

### Tables

**categories** — 15 charity categories
| Column | Type | What It Stores |
|--------|------|---------------|
| id | serial | Auto-generated number |
| name | text | Category name in English (e.g. "Soldiers & Veterans") |
| name_he | text | Category name in Hebrew (e.g. "חיילים וותיקים") |
| slug | text | URL-friendly version (e.g. "soldiers-veterans") |
| description | text | Short explanation of the category (English) |
| description_he | text | Short explanation of the category (Hebrew) |
| icon | text | Emoji icon for the category |
| display_order | int | What order to show them in |

**charities** — 45+ charity listings
| Column | Type | What It Stores |
|--------|------|---------------|
| id | UUID | Unique ID |
| name | text | Charity name (English) |
| name_he | text | Charity name (Hebrew) |
| slug | text | URL-friendly name |
| description | text | Full description (English) |
| description_he | text | Full description (Hebrew) |
| short_description | text | One-liner shown on cards (English) |
| short_description_he | text | One-liner shown on cards (Hebrew) |
| category_id | int | Links to categories table |
| logo_url | text | Auto-pulled logo from their website |
| website_url | text | Their main website |
| donation_url | text | Direct link to their donate page |
| location | text | Where in Israel they operate (English) |
| location_he | text | Where in Israel they operate (Hebrew) |
| amuta_number | text | Official registration number |
| is_verified | boolean | Whether we've confirmed they're legit |
| is_featured | boolean | Shows them in the "Featured" section |
| is_tax_deductible_us | boolean | Tax deductible for US donors |
| tags | text | Keywords for search |
| search_text | text | Combined text for search matching |

**charity_suggestions** — Community-submitted charities
| Column | Type | What It Stores |
|--------|------|---------------|
| id | UUID | Unique ID |
| charity_name | text | Name of suggested charity |
| website_url | text | Their website |
| donation_url | text | Their donate page |
| category | text | Which category they fit |
| description | text | Why they should be listed |
| submitter_name | text | Who suggested it (optional) |
| submitter_email | text | Their email (optional) |
| status | text | "pending", "approved", or "rejected" |
| created_at | timestamp | When it was submitted |

### The 15 Categories

1. Soldiers & Veterans
2. Medical & Emergency
3. Poverty & Hunger
4. Education
5. Children & Youth
6. Holocaust Survivors
7. Special Needs
8. Terror Victims
9. Community Development
10. Environment & Land
11. Women Empowerment
12. Arts & Culture
13. Technology & Innovation
14. Animals
15. Religious & Spiritual

### Supabase Edge Function
- **submit-suggestion** — Handles community charity submissions from the suggest form on the main site

---

## SEO & Social Sharing (Current)

- **Title**: Give Israel — Explore & Support Israeli Charities
- **Meta Description**: Supporting Israel starts with finding the right cause. Browse verified charities, filter by category, and donate directly — all in one place.
- **OG Image**: /og-image.jpg (custom image showing the app interface with Jerusalem background)
- **Twitter Card**: summary_large_image
- **Favicon**: Inline SVG — blue square with Star of David and heart

NOTE: The og:image URLs currently use relative paths (/og-image.jpg). For full social media compatibility, these should be updated to absolute URLs (https://giveisrael.charity/og-image.jpg) once confirmed.

---

## Design System

### Colors
| Token | Hex | Usage |
|-------|-----|-------|
| --il-blue | #0038B8 | Primary — Israeli flag blue |
| --il-blue-deep | #002A8C | Hover states, dark accents |
| --il-blue-dark | #001B5E | Logo text, deep accents |
| --il-blue-vivid | #1456D6 | Bright interactive elements |
| --il-blue-soft | #5B94F0 | Light interactive elements |
| --il-blue-mist | #D6E4FA | Card borders on hover |
| --il-blue-ghost | #EDF2FD | Category pill hover backgrounds |
| --il-blue-tint | #F6F9FF | Lightest blue tint |
| --white | #FFFFFF | Backgrounds |
| --ivory | #FAFBFD | Page background |
| --ink | #0C1324 | Primary text |
| --ink-80 | #2A3550 | Secondary text |
| --ink-60 | #4A5578 | Descriptions |
| --ink-40 | #7B849E | Muted text, labels |
| --ink-25 | #A8B0C4 | Placeholders |
| --success | #0D9F5F | Verified badge green |
| --amber | #B8860B | Tax deductible badge / featured highlights |
| --gold | #D4A843 | "Light Up Israel" glow color |

### Fonts
- **Display/Headings (English)**: Cormorant Garamond (serif) — weights 400, 600, 700
- **Display/Headings (Hebrew)**: Frank Ruhl Libre (serif) — weights 400, 600, 700
- **Body/UI (English)**: Figtree (sans-serif) — weights 300, 400, 500, 600, 700, 800
- **Body/UI (Hebrew)**: Heebo (sans-serif) — weights 300, 400, 500, 600, 700, 800
- CSS variables: `--font-display-he` and `--font-body-he` switch fonts when `html[dir="rtl"]` is active

### Design Aesthetic
- Editorial luxury meets Israeli flag blue & white
- Subtle grain texture overlay on body (opacity 0.018) for premium feel
- Blue flag stripe accent at top of page
- Cards reveal a blue top-line on hover
- Blue-tinted shadows throughout
- Smooth transitions using cubic-bezier easing
- Mobile responsive

---

## Hebrew/English Language Toggle (i18n)

The site is fully bilingual. Here's how it works:

### How Language Switching Works
- A **toggle button** (עב / EN) in the header switches between Hebrew and English instantly — no page reload
- **Geolocation detection**: visitors from Israel automatically get Hebrew; everyone else gets English
- **localStorage** saves the visitor's preference for future visits
- When Hebrew is active, `html dir="rtl"` flips the entire layout right-to-left

### Translation Architecture
- **UI text** (labels, buttons, quiz, form, footer, badges) lives in a `LANG` dictionary inside index.html's JavaScript, with keys for `en` and `he`
- **Charity data** (names, descriptions, locations) comes from Supabase `_he` columns (e.g. `name_he`, `short_description_he`)
- **Category names** also come from Supabase `name_he` column
- **Fallback**: if any Hebrew field is empty, the English version is shown instead

### Key Functions
- `t('key')` — returns the translated UI string for the current language
- `cf(charity, 'field')` — returns the charity's field in the current language (with English fallback)
- `catf(category, 'field')` — returns the category's field in the current language
- `setLanguage(lang, save)` — switches language and updates all text
- `detectLanguage()` — runs on page load (checks localStorage → geolocation → defaults to English)
- `toggleLanguage()` — flips between Hebrew and English

### Adding New Translatable Text
When adding any new visible text to the site:
1. Add the English string to `LANG.en` with a descriptive key
2. Add the Hebrew string to `LANG.he` with the same key
3. Use `t('yourKey')` in the code instead of hardcoding the string

### Research & Stress Testing
- Language toggle was researched using the Mikoshi Protocol (see GiveIsrael-Language-Toggle-Research.md)
- All translations were stress-tested by a separate AI model and scored on the CIQ rubric
- The quiz personas, footer tagline, and meta descriptions scored 10/10 for Hebrew quality
- Two fixes were applied based on the stress test: "מגן נחוש" → "מגן אמיץ" and improved phrasing for several items

---

## Main Site Features (index.html)

- **Sticky header** with logo, search bar, suggest button, language toggle, and charity/category counters
- **Hebrew/English toggle** — instant language switch with RTL support
- **Real-time search** — searches names, descriptions, and tags instantly as you type
- **Category filter pills** — sticky row below header, click to filter, shows count per category
- **Featured section** — hand-picked charities appear at the top with special styling
- **Charity cards** with: auto-pulled logo, name, location, badges (Verified, Featured, US Tax Deductible), description, category label, Donate button, Website button
- **"Suggest a Charity" modal** — community submission form (name, website, donation URL, category, description, submitter info)
- **Donation tracking** — links directly to each charity's own donation page (external)
- **Logo fallback** — shows initials if Google favicon API doesn't return an image
- **Animations** — cards rise in on load, hover effects on everything

---

## Admin Dashboard Features (admin.html)

- **Supabase Auth** — email/password login required
- **Stats overview** — total charities, pending suggestions, categories, featured count
- **Suggestions tab** — see all submitted charities with status (pending/approved/rejected)
- **Publish flow** — review suggestion, edit details, pick category, add Hebrew translations, add to live directory
- **Reject flow** — dismiss a suggestion
- **All Charities tab** — see everything currently in the directory, edit Hebrew translations
- **Hebrew translation fields** — both the Publish form and Edit Charity form include Hebrew name, short description, location, and full description fields (marked with 🇮🇱, RTL input direction)
- **Uses Supabase JS SDK** (loaded via CDN)
- Admin dashboard stays in English only (it's only used by Avigdor)

---

## Planned Feature: "Light Up Israel" (Not Yet Built)

An interactive SVG map of Israel that lights up as users explore charities. Full spec in LIGHT-UP-ISRAEL-FEATURE-SPEC.md. Key points:

- Map with 6 clickable regions that glow warm gold (#D4A843) as users explore
- Personal giving journey panel with milestones and stats
- No accounts required — all progress stored in localStorage
- Weekly spotlight charity with pulse animation
- Shareable impact card generator
- Community aggregate map (Phase 2)
- CIQ Score: 95/100

---

## Security

- **Vercel headers**: X-Frame-Options DENY, HSTS, CSP, XSS Protection, nosniff, strict referrer policy
- **Permissions-Policy**: camera, microphone, geolocation all disabled
- **CSP**: restricts scripts to self, Google Analytics, jsdelivr CDN; restricts connections to self and Supabase
- **RLS**: Supabase Row Level Security enforces read-only public access
- **Security stress test**: documented in GiveIsrael-Security-Stress-Test.docx

---

## Git & Deployment Workflow

```bash
cd ~/Desktop/give-israel
git add -A
git commit -m "describe what you changed"
git push
```

Vercel watches GitHub and auto-deploys every push within ~30 seconds. No build step needed.

---

## Common Tasks

### Add a charity manually
1. Go to Supabase dashboard → Table Editor → charities
2. Click "Insert row"
3. Fill in name, description, category_id, donation_url at minimum
4. Also fill in name_he, short_description_he, location_he for Hebrew support
5. For logo, use: `https://www.google.com/s2/favicons?domain=THEIR_DOMAIN&sz=128`

### Review a community suggestion
1. Go to giveisrael.charity/admin
2. Log in
3. See pending suggestions
4. Click "Publish" to add to directory, or "Reject" to dismiss

### Feature/unfeature a charity
1. Supabase dashboard → Table Editor → charities
2. Find the charity → toggle `is_featured` to true/false

### Add a new category
1. Supabase dashboard → Table Editor → categories
2. Click "Insert row"
3. Add name, slug, description, icon (emoji), display_order
4. Also add name_he and description_he for Hebrew support

---

## Important Rules for Claude

1. **Never change anything unless Avigdor explicitly says to** — this is the #1 rule
2. **Keep explanations simple** — Avigdor is not a developer, avoid jargon
3. **Single-file architecture** — index.html and admin.html are self-contained (HTML + CSS + JS all inline). Do NOT split them into separate files
4. **No frameworks** — no React, no Vue, no build tools. Plain HTML/CSS/JS only
5. **Supabase anon key is public** — it's safe to be in the HTML, RLS protects the data
6. **Test changes carefully** — this is a live charity site with real users
7. **Preserve the design** — editorial luxury aesthetic, Israeli flag blue (#0038B8) and white, Cormorant Garamond + Figtree (English) / Frank Ruhl Libre + Heebo (Hebrew), grain texture, flag stripe accents
7b. **Bilingual consistency** — when adding new text, always add both English and Hebrew versions to the LANG dictionary. Use `t('key')` for UI text, `cf(charity,'field')` for charity data, `catf(category,'field')` for category data
8. **Git workflow** — Avigdor pushes with `git add -A && git commit -m "..." && git push`. Vercel auto-deploys. Do not suggest Vercel CLI unless specifically asked
9. **OG image paths** — currently relative (/og-image.jpg). Should be updated to absolute URLs when ready

---

## Created

March 2026 — Built with Claude using the Mikoshi Protocol for research and planning.

## Changelog

- **March 19, 2026** — Added full Hebrew/English language toggle: translation dictionary (100+ entries), RTL CSS support, Hebrew Google Fonts, geolocation-based language detection, Hebrew columns in Supabase (all 45 charities + 15 categories translated), admin dashboard Hebrew input fields, and "Find Your Cause" quiz fully translated. Translations stress-tested by a separate AI model and scored on CIQ rubric.
