# Give Israel — Complete Project Documentation

## What This Is

A premium online directory of Israeli charities. People can browse, search, filter by category, and click through to donate directly on each charity's own website. Think of it like an Amazon for Israeli giving — but instead of buying products, you're finding causes to support.

There is no database. Everything the site shows comes from one plain file: `public/data.js`.

---

## Live URLs

- **Main site**: giveisrael.charity
- **GitHub repo**: github.com/avigdor-star/give-israel

---

## What's In The Project

```
~/dev/give-israel/
├── public/                  ← The folder Vercel serves
│   ├── index.html           ← The main charity directory app (one self-contained file)
│   ├── data.js              ← ALL charity + category data — the single source of truth
│   ├── logos/               ← Charity logo image files (not created yet)
│   ├── give-israel-logo.png ← Header shield logo
│   └── og-image.jpg         ← Social sharing image
├── retired/                 ← Old admin dashboard, not deployed, reference only
├── backup-supabase/         ← Raw JSON backup of the old database (historical only)
├── download-logos.sh        ← One-time script that pulls the logo files out of the old storage
├── vercel.json              ← Tells Vercel how to serve the site (headers, security)
├── package.json             ← Project metadata
├── README.md                ← Short readme for GitHub
├── LOGO-HANDOFF.md          ← Brief for the future session that will sort out the charity logos
├── LOGO-TASK-LIST.md        ← The list of charities whose logos still need sorting
└── .gitignore               ← Tells git what to ignore
```

---

## Tech Stack (Plain English)

| Piece | What It Is | Where |
|-------|-----------|-------|
| **Data** | A plain JavaScript file — no database at all | public/data.js |
| **Frontend** | One HTML file — no frameworks, no build tools | public/index.html |
| **Suggestions** | A plain email link — no form, no backend | Button in public/index.html emails avigdor@crunchybuzz.com |
| **Hosting** | Vercel (free) — serves the website | vercel.com → "give-israel" project |
| **Domain** | giveisrael.charity via Namecheap | namecheap.com |
| **Code repo** | GitHub | github.com/avigdor-star/give-israel |

---

## The Data File: public/data.js

The file has two lists in it:

```js
const GI_CATEGORIES = [ ... ]   // 15 categories, in display_order
const GI_CHARITIES  = [ ... ]   // 60 charities, featured ones first, then alphabetical
```

`index.html` loads it with one line, just before its own script:

```html
<script src="/data.js"></script>
```

Current counts: **15 categories · 60 charities · 18 featured · 1 partner**. All 60 have Hebrew names.

### What each category holds

| Field | What It Stores |
|-------|---------------|
| id | Unique number |
| name | Category name in English (e.g. "Soldiers & Veterans") |
| name_he | Category name in Hebrew |
| slug | URL-friendly version (e.g. "soldiers-veterans") |
| description | Short explanation of the category (English) |
| description_he | Short explanation of the category (Hebrew) |
| icon | Emoji icon for the category |
| display_order | What order to show them in |

### What each charity holds

| Field | What It Stores |
|-------|---------------|
| id | Unique ID |
| name | Charity name (English) |
| name_he | Charity name (Hebrew) |
| slug | URL-friendly name |
| description | Full description (English) |
| description_he | Full description (Hebrew) |
| short_description | One-liner shown on cards (English) |
| short_description_he | One-liner shown on cards (Hebrew) |
| category_id | Which category it belongs to (matches an id in GI_CATEGORIES) |
| logo_url | `/logos/name.png`, a Google favicon URL, or `null` |
| website_url | Their main website |
| donation_url | Direct link to their donate page |
| location | Where in Israel they operate (English) |
| location_he | Where in Israel they operate (Hebrew) |
| amuta_number | Official Israeli registration number |
| is_verified | true/false — whether we've confirmed they're legit |
| is_featured | true/false — shows them in the "Featured" section |
| is_tax_deductible_us | true/false — tax deductible for US donors |
| is_partner | true/false — official Give Israel partner |
| tags | List of keywords for search, e.g. `["children","education"]` |
| search_text | Combined text used for search matching |

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

---

## Suggesting a Charity

There is no form. The "Suggest a Charity" button in the header is a plain email link.

1. Someone clicks the button on the site
2. Their own email app opens, already addressed to **avigdor@crunchybuzz.com**
3. They write the suggestion and send it
4. Nothing is saved anywhere — the email is the record
5. To list the charity, Avigdor adds it to `public/data.js` by hand

Nothing needs setting up: no email service, no API keys, no settings in Vercel. The site is pure static files.

---

## Features

### Main Site (index.html)
- **Search bar** in the header — searches names, descriptions, and tags
- **Hebrew / English toggle** — instant switch with full right-to-left layout
- **Category filter pills** — click to filter by category, shows count per category
- **Featured section** — hand-picked charities appear at the top
- **Charity cards** with logo, name, location, badges (Verified, Featured, US Tax Deductible), description, category label
- **Donate button** — links directly to the charity's own donation page
- **Website button** — links to their homepage
- **Suggest a Charity button** — a plain email link; opens the visitor's email app addressed to avigdor@crunchybuzz.com
- **Mobile responsive** — works on phones and tablets
- **Israeli flag design** — blue (#0038B8) and white color scheme with flag stripe accents

### Logos
- Most logos are real image files in `public/logos/`, referenced as `/logos/name.png`
- A few still use a Google favicon URL
- If a charity has no logo, the card shows their initials instead

---

## How To Do Common Tasks

### Add a charity
1. Open `public/data.js`
2. In `GI_CHARITIES`, copy an existing entry and paste it
3. Edit the fields — at minimum name, name_he, short_description, category_id, website_url, donation_url
4. If it's featured, keep it with the other featured entries at the top of the list
5. Save, then push (see Git Workflow below). Live in about 30 seconds

**Verification rule**: a charity is only "verified" if it has all three — a working website, an Israeli Amuta (registration) number, and a direct donation link. Set `is_verified` to true only when all three are confirmed. Check the Amuta number at `israelgives.org/amuta/AMUTA_NUMBER`.

### Edit a charity
1. Open `public/data.js`, find it by name
2. Change the field
3. Save and push

### Feature or unfeature a charity
1. Set `is_featured` to `true` or `false` in `public/data.js`
2. Also move the entry so all featured ones stay together at the top of the list
3. Save and push

### Add a new category
1. Add an entry to `GI_CATEGORIES` in `public/data.js`
2. Give it a new unique `id`, plus `name`, `name_he`, `slug`, `description`, `description_he`, `icon` (emoji), `display_order`
3. Save and push

### Add or change a logo
1. Put the image file in `public/logos/`
2. Set that charity's `logo_url` to `/logos/yourfilename.png`
3. Save and push

### Review a community suggestion
1. Check your email at avigdor@crunchybuzz.com — people email their suggestions straight to you
2. If you want to list it, add it to `public/data.js` by hand

### Update the site design or code
1. Edit `~/dev/give-israel/public/index.html`
2. Push to GitHub:
```
cd ~/dev/give-israel && git add -A && git commit -m "describe your change" && git push
```
3. Vercel auto-deploys within ~30 seconds

---

## Domain Setup (Namecheap → Vercel)

### In Vercel
1. Project Settings → Domains → Add `giveisrael.charity`
2. Note the DNS records Vercel shows you

### In Namecheap
1. Domain List → Manage → Advanced DNS
2. Add CNAME record: Host = `@`, Value = `cname.vercel-dns.com`
3. Or A record: Host = `@`, Value = `76.76.21.21`

---

## Git Workflow

Your project lives at `~/dev/give-israel/`. To push changes:

```bash
cd ~/dev/give-israel
git add -A
git commit -m "describe what you changed"
git push
```

Vercel watches GitHub and auto-deploys every push.

---

## Design Details

- **Fonts**: Cormorant Garamond (serif headings) + Figtree (body text) for English; Frank Ruhl Libre + Heebo for Hebrew
- **Primary color**: Israeli flag blue #0038B8
- **Background**: White/ivory #FAFBFD
- **Text**: Dark ink #0C1324
- **Subtle grain texture** overlay for premium editorial feel
- **Flag stripe** accents at top and bottom
- **Cards** reveal a blue top-line on hover
- **Blue-tinted shadows** throughout

---

## Created

March 19, 2026 — Built with Claude in one session using the Mikoshi Protocol for research and planning.

Updated August 16, 2026 — moved off the database entirely; all data now lives in `public/data.js`. The same day, the "Suggest a Charity" form was removed in favour of a plain email link, which also removed the `api/` folder, the email service, and all environment variables. The site is 100% static files.
