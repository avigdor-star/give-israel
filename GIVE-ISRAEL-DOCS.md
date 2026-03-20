# Give Israel — Complete Project Documentation

## What This Is

A premium online directory of Israeli charities. People can browse, search, filter by category, and click through to donate directly on each charity's own website. Think of it like an Amazon for Israeli giving — but instead of buying products, you're finding causes to support.

---

## Live URLs

- **Main site**: giveisrael.charity
- **Admin dashboard**: giveisrael.charity/admin
- **GitHub repo**: github.com/avigdor-star/give-israel

---

## What's In The Project

```
Desktop/give-israel/
├── public/
│   ├── index.html      ← The main charity directory app
│   └── admin.html       ← Admin dashboard to review & publish suggestions
├── vercel.json           ← Tells Vercel how to serve the site
├── package.json          ← Project metadata
├── README.md             ← Short readme for GitHub
└── .gitignore            ← Tells git what to ignore
```

---

## Tech Stack (Plain English)

| Piece | What It Is | Where |
|-------|-----------|-------|
| **Database** | Supabase (free) — stores all charity data | supabase.com → "Give Israel" project |
| **Frontend** | Single HTML files — no frameworks, no build tools | public/index.html and public/admin.html |
| **Hosting** | Vercel (free) — serves the website | vercel.com → "give-israel" project |
| **Domain** | giveisrael.charity via Namecheap | namecheap.com |
| **Code repo** | GitHub | github.com/avigdor-star/give-israel |

---

## Supabase Database

**Project name**: Give Israel
**Project ID**: psrtcjaxfeutecirypwd
**Region**: us-east-1
**Dashboard**: supabase.com/dashboard/project/psrtcjaxfeutecirypwd

### Tables

**categories** — 15 charity categories
| Column | What It Stores |
|--------|---------------|
| id | Auto-generated number |
| name | Category name (e.g. "Soldiers & Veterans") |
| slug | URL-friendly version (e.g. "soldiers-veterans") |
| description | Short explanation of the category |
| icon | Emoji icon for the category |
| display_order | What order to show them in |

**charities** — 45+ charity listings
| Column | What It Stores |
|--------|---------------|
| id | Unique ID (UUID) |
| name | Charity name |
| slug | URL-friendly name |
| description | Full description |
| short_description | One-liner shown on cards |
| category_id | Links to categories table |
| logo_url | Auto-pulled logo from their website |
| website_url | Their main website |
| donation_url | Direct link to their donate page |
| location | Where in Israel they operate |
| amuta_number | Official registration number |
| is_verified | Whether we've confirmed they're legit |
| is_featured | Shows them in the "Featured" section |
| is_tax_deductible_us | Tax deductible for US donors |
| tags | Keywords for search |
| search_text | Combined text for search matching |

**charity_suggestions** — Community-submitted charities
| Column | What It Stores |
|--------|---------------|
| id | Unique ID |
| charity_name | Name of suggested charity |
| website_url | Their website |
| donation_url | Their donate page |
| category | Which category they fit |
| description | Why they should be listed |
| submitter_name | Who suggested it (optional) |
| submitter_email | Their email (optional) |
| status | "pending", "approved", or "rejected" |
| created_at | When it was submitted |

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

### Supabase API Connection

The frontend connects to Supabase using these credentials (safe to be public — they're read-only):

- **URL**: https://psrtcjaxfeutecirypwd.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzcnRjamF4ZmV1dGVjaXJ5cHdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5NTcxMDIsImV4cCI6MjA4OTUzMzEwMn0.4aJK0277vZudaRtvmCpEhfWhHkbrXyHIc_2f8DgqZkQ

Row Level Security (RLS) is enabled:
- Anyone can **read** charities and categories
- Anyone can **submit** suggestions
- Only you can edit/delete via the Supabase dashboard

---

## Features

### Main Site (index.html)
- **Search bar** in the header — searches names, descriptions, and tags
- **Category filter pills** — click to filter by category, shows count per category
- **Featured section** — hand-picked charities appear at the top
- **Charity cards** with logo, name, location, badges (Verified, Featured, US Tax Deductible), description, category label
- **Donate button** — links directly to the charity's own donation page
- **Website button** — links to their homepage
- **Suggest a Charity button** — opens a modal form for community submissions
- **Mobile responsive** — works on phones and tablets
- **Israeli flag design** — blue (#0038B8) and white color scheme with flag stripe accents

### Admin Dashboard (admin.html)
- **Stats overview** — total charities, pending suggestions, categories, featured count
- **Suggestions tab** — see all submitted charities with status (pending/approved/rejected)
- **Publish flow** — click "Publish" to review, edit details, pick a category, and add the charity to the live directory
- **Reject flow** — click "Reject" to dismiss a suggestion
- **All Charities tab** — see everything currently in the directory

### Logos
- Pulled automatically from each charity's website using Google's favicon API
- URL format: `https://www.google.com/s2/favicons?domain=DOMAIN&sz=128`
- Falls back to initials if the logo doesn't load

---

## How To Do Common Tasks

### Add a charity manually
1. Go to supabase.com → Give Israel project → Table Editor → charities
2. Click "Insert row"
3. Fill in name, description, category_id, donation_url at minimum
4. For logo, use: `https://www.google.com/s2/favicons?domain=THEIR_DOMAIN&sz=128`

### Review a community suggestion
1. Go to giveisrael.charity/admin
2. See pending suggestions
3. Click "Publish" to add it to the directory, or "Reject" to dismiss

### Feature/unfeature a charity
1. Go to Supabase dashboard → Table Editor → charities
2. Find the charity → toggle `is_featured` to true/false

### Add a new category
1. Go to Supabase dashboard → Table Editor → categories
2. Click "Insert row"
3. Add name, slug, description, icon (emoji), display_order

### Update the site design or code
1. Edit files in `~/Desktop/give-israel/public/`
2. Push to GitHub with:
```
cd ~/Desktop/give-israel && git add -A && git commit -m "describe your change" && git push
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

Your project lives at `~/Desktop/give-israel/`. To push changes:

```bash
cd ~/Desktop/give-israel
git add -A
git commit -m "describe what you changed"
git push
```

Vercel watches GitHub and auto-deploys every push.

---

## Design Details

- **Fonts**: Cormorant Garamond (serif headings) + Figtree (body text)
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
