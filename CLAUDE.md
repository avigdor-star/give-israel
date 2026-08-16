# CLAUDE.md — Give Israel Project Context

## What Is This Project

Give Israel (giveisrael.charity) is the most comprehensive online directory of Israeli charities. Visitors browse, search, filter by category, and click through to donate directly on each charity's own website. Think of it like an Amazon for Israeli giving — but instead of buying products, you're finding causes to support.

The owner (Avigdor) is not a developer. All explanations and changes should be simple, clear, and jargon-free. Never change anything unless Avigdor has explicitly said to.

**There is no database.** All charity and category data lives in one plain file: `public/data.js`. Supabase was removed on 16 August 2026.

---

## ⚠️ Open Item — Charity Logos

> **⚠️ Open item — charity logos.** `public/data.js` points 50 charities at `/logos/*.png`, but `public/logos/` does not exist yet, so those cards currently show the charity's initials instead. The original images are still in the old Supabase Storage bucket — `download-logos.sh` will fetch them all, and `backup-supabase/logo-urls.txt` lists them. **Do not delete the Supabase project until this is resolved.** Avigdor has decided he'd rather link logos directly from each charity's own website instead of hosting them; see `LOGO-HANDOFF.md` for the full brief.

---

## Live URLs

- **Main site**: https://giveisrael.charity
- **GitHub repo**: https://github.com/avigdor-star/give-israel

(There is no admin dashboard any more. It was retired on 16 August 2026.)

---

## Project Structure

```
~/dev/give-israel/
├── public/                     ← DEPLOYED FOLDER (Vercel serves this)
│   ├── index.html              ← The entire main site (single file — HTML, CSS, JS all in one)
│   ├── data.js                 ← ALL charity + category data. THE SINGLE SOURCE OF TRUTH
│   ├── logos/                  ← Charity logo images (NOT created yet — see the open item above)
│   ├── give-israel-logo.png    ← Shield logo icon (128×128, used in header)
│   ├── og-image.jpg            ← Feature image for social sharing (WhatsApp, Facebook, Twitter)
│   └── og-image.png            ← Backup/generated OG image (map style, not currently in use)
├── retired/                    ← Old admin dashboard, kept for reference only (NOT deployed)
│   ├── admin.html
│   └── README.md               ← Explains why it was retired
├── backup-supabase/            ← One-time raw JSON backup of the old database (historical only)
│   ├── categories.json
│   ├── charities.json
│   ├── charity_suggestions.json
│   └── logo-urls.txt
├── download-logos.sh           ← One-time helper that pulled the logos out of the old storage (already run)
├── vercel.json                 ← Vercel hosting config (headers, security, routing)
├── package.json                ← Project metadata (no build step)
├── .gitignore                  ← Ignores node_modules, .vercel, .DS_Store
├── README.md                   ← Short GitHub readme
├── GIVE-ISRAEL-DOCS.md         ← Full project documentation (data structure, categories, how-tos)
├── NEXT-TASK-PROMPTS.md        ← Ready-to-paste prompts for upcoming jobs
├── LOGO-HANDOFF.md             ← Brief for the future session that will sort out the charity logos
├── LOGO-TASK-LIST.md           ← The list of charities whose logos still need sorting
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
| **Frontend** | Single HTML file | No frameworks, no build tools. All CSS and JS are inline in `public/index.html` |
| **Data** | Plain JS file — no database | `public/data.js` holds every charity and category. Edit the file, push, done |
| **Suggestions** | Plain email link — no form, no backend | The "Suggest a Charity" button is a `mailto:` link to avigdor@crunchybuzz.com |
| **Hosting** | Vercel (free tier) | Auto-deploys from GitHub on every push |
| **Domain** | giveisrael.charity | Registered on Namecheap, DNS pointed to Vercel |
| **Code repo** | GitHub | github.com/avigdor-star/give-israel |
| **Fonts** | Google Fonts | English: Cormorant Garamond + Figtree · Hebrew: Frank Ruhl Libre + Heebo |
| **i18n** | Built-in toggle | Hebrew/English with RTL support, geolocation default, localStorage persistence |
| **Geolocation** | ipapi.co (free) | Detects Israel visitors → defaults to Hebrew; everyone else → English |
| **Logos** | Local image files | Most logos are real files in `public/logos/`, referenced as `/logos/name.png` |

---

## Where The Data Lives: public/data.js

`public/data.js` is a plain JavaScript file with two lists in it:

```js
const GI_CATEGORIES = [ ... ]   // 15 categories, in display_order
const GI_CHARITIES  = [ ... ]   // 60 charities, featured ones first, then alphabetical
```

`index.html` loads it just before its own script:

```html
<script src="/data.js"></script>
```

**This file is the single source of truth for all charity data.** To change what the site shows, edit this file and push.

Current counts: **15 categories · 60 charities · 18 featured · 1 partner**. All 60 charities have Hebrew names.

### Fields on each charity

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
| logo_url | `/logos/name.png` (local file), a Google favicon URL, or `null` |
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

### Fields on each category

| Field | What It Stores |
|-------|---------------|
| id | Unique number |
| name | Category name in English (e.g. "Soldiers & Veterans") |
| name_he | Category name in Hebrew (e.g. "חיילים וותיקים") |
| slug | URL-friendly version (e.g. "soldiers-veterans") |
| description | Short explanation of the category (English) |
| description_he | Short explanation of the category (Hebrew) |
| icon | Emoji icon for the category |
| display_order | What order to show them in |

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

### Logos

- Most logos (50) are real image files in `public/logos/`, referenced like `/logos/aleh.png`
- A few (3) still use a Google favicon URL
- Some (7) are `null` — the site shows the charity's initials instead

---

## Suggesting a Charity — Just an Email Link

There is no form. The "Suggest a Charity" button in the header is a plain email link:

```html
<a class="btn-suggest" href="mailto:avigdor@crunchybuzz.com?subject=...">
```

- Clicking it opens the visitor's own email app, already addressed to **avigdor@crunchybuzz.com**
- The button reads "+ Suggest a Charity" in English and "+ הציעו עמותה" in Hebrew
- Nothing is sent through the site, nothing is stored — the email IS the record
- To list a suggested charity, Avigdor adds it to `public/data.js` by hand

**Nothing to set up.** No email service, no API keys, no environment variables. The site is pure static files.

---

## SEO & Social Sharing (Current)

- **Title**: Give Israel — Explore & Support Israeli Charities
- **Meta Description**: Supporting Israel starts with finding the right cause. Browse verified charities, filter by category, and donate directly — all in one place.
- **OG Image**: /og-image.jpg (custom image showing the app interface with Jerusalem background)
- **Twitter Card**: summary_large_image
- **Favicon**: Inline SVG — blue square with Star of David and heart
- **Header Logo**: Blue shield icon with Star of David cutout (`/give-israel-logo.png`, 70×70px) alongside "GiveIsrael" wordmark text

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
- **Charity data** (names, descriptions, locations) comes from the `_he` fields in `public/data.js` (e.g. `name_he`, `short_description_he`)
- **Category names** also come from the `name_he` field in `public/data.js`
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
- **Charity cards** with: logo, name, location, badges (Verified, Featured, US Tax Deductible), description, category label, Donate button, Website button
- **"Suggest a Charity" button** — a plain email link. Clicking it opens the visitor's email app addressed to avigdor@crunchybuzz.com. No form, no backend
- **Donation tracking** — links directly to each charity's own donation page (external)
- **Logo fallback** — shows the charity's initials when there is no logo image
- **Animations** — cards rise in on load, hover effects on everything

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
- **CSP connect-src**: `'self' https://ipapi.co https://www.google-analytics.com https://www.googletagmanager.com` (ipapi.co is needed for the Hebrew geolocation check)
- **No database, no login, no user accounts** — nothing to break into. The site is read-only files
- **No secrets and no environment variables at all** — there is nothing to leak. The site is pure static files with no backend code
- **Security stress test**: documented in GiveIsrael-Security-Stress-Test.docx

---

## Git & Deployment Workflow

```bash
cd ~/dev/give-israel
git add -A
git commit -m "describe what you changed"
git push
```

Vercel watches GitHub and auto-deploys every push within ~30 seconds. No build step needed.

---

## Common Tasks

### Add a charity
1. Open `public/data.js`
2. Find `GI_CHARITIES` and copy an existing entry
3. Paste it and edit the fields (name, name_he, description, category_id, donation_url, etc.)
4. If it's featured, put it with the other featured entries at the top of the list
5. Save, then `git add -A && git commit -m "Added [charity]" && git push`
6. Live in about 30 seconds

**Verification rule**: a charity is only "verified" if it has ALL THREE — a working website, an Israeli Amuta (registration) number, and a direct donation link. Set `is_verified` to true only when all three are confirmed. Look up the Amuta number at `israelgives.org/amuta/AMUTA_NUMBER` to confirm it's real.

### Edit a charity
1. Open `public/data.js`, find the charity by name
2. Change the field you want
3. Save and push

### Feature or unfeature a charity
1. In `public/data.js`, set `is_featured` to `true` or `false`
2. **Also move the entry** so all the featured ones stay together at the top of the list
3. Save and push

### Add a new category
1. In `public/data.js`, add an entry to `GI_CATEGORIES`
2. Give it a new unique `id`, plus `name`, `name_he`, `slug`, `description`, `description_he`, `icon` (an emoji), and `display_order`
3. Save and push

### Add or change a logo
1. Save the image file into `public/logos/`
2. Set that charity's `logo_url` to `/logos/yourfilename.png`
3. Save and push

### Review a community suggestion
1. Check your email at **avigdor@crunchybuzz.com** — people email their suggestions straight to you
2. If you want to list it, add it to `public/data.js` by hand (see "Add a charity" above)

---

## Important Rules for Claude

1. **Never change anything unless Avigdor explicitly says to** — this is the #1 rule
2. **Keep explanations simple** — Avigdor is not a developer, avoid jargon
3. **There is NO database** — all charity data lives in `public/data.js`. Never suggest Supabase, an admin dashboard, or any database. They were removed on 16 August 2026
4. **Single-file architecture** — index.html is self-contained (HTML + CSS + JS all inline). Do NOT split it into separate files. `data.js` is the one deliberate exception, and it holds data only
5. **No frameworks** — no React, no Vue, no build tools. Plain HTML/CSS/JS only
6. **Test changes carefully** — this is a live charity site with real users
7. **Preserve the design** — editorial luxury aesthetic, Israeli flag blue (#0038B8) and white, Cormorant Garamond + Figtree (English) / Frank Ruhl Libre + Heebo (Hebrew), grain texture, flag stripe accents
7b. **Bilingual consistency** — when adding new text, always add both English and Hebrew versions to the LANG dictionary. Use `t('key')` for UI text, `cf(charity,'field')` for charity data, `catf(category,'field')` for category data
8. **Git workflow** — Avigdor pushes with `git add -A && git commit -m "..." && git push`. Vercel auto-deploys. Do not suggest Vercel CLI unless specifically asked
9. **OG image paths** — currently relative (/og-image.jpg). Should be updated to absolute URLs when ready

---

## Created

March 2026 — Built with Claude using the Mikoshi Protocol for research and planning.

## Changelog

- **March 19, 2026** — Added full Hebrew/English language toggle: translation dictionary (100+ entries), RTL CSS support, Hebrew Google Fonts, geolocation-based language detection, Hebrew text for all 45 charities + 15 categories, and "Find Your Cause" quiz fully translated. Translations stress-tested by a separate AI model and scored on CIQ rubric.
- **March 20, 2026** — Full charity audit and expansion:
  - **Removed 3 charities**: Claims Conference (international, not Israeli), October 7 Relief Fund (unverifiable), AWIS (wrong URL pointing to unrelated site)
  - **Fixed 2 URLs**: Beit Issie Shapiro (→ beitissie.org.il), ORT Israel (→ en.ort.org.il)
  - **Re-added AWIS** with correct URL (ufis.org.il) and Amuta number (580004307)
  - **Added 14 new verified charities**: Hasoub, Freedom Farm Sanctuary, SPCA Israel, Tzohar, Bnei Akiva, Rabinovich Foundation, Centre of Holocaust Survivors, NATAL, NA'AMAT, Kayan Feminist Organization, Zalul, Heschel Center, SHEKEL, AKIM Israel
  - **All new charities verified** with working website + Israeli Amuta number + donation link
  - **Established verification rule**: a charity is "verified" only if it has all three: working website, Amuta number, and donation link
  - **Directory grew from 45 → 57 charities** across all 15 categories (Technology & Innovation no longer empty)
- **March 20, 2026** — Removed CSS truncation on charity card descriptions: deleted `-webkit-line-clamp: 2` and related overflow rules from `.card-desc` so the full short_description text is always visible on every card. Cards grow taller as needed. Works in both English and Hebrew/RTL views.
- **March 20, 2026** — New logo and mobile UX improvements:
  - **New logo icon**: Replaced the CSS blue square + Star of David emoji with the actual Give Israel shield logo (`give-israel-logo.png` in `/public`). Icon displays at 70×70px alongside the "GiveIsrael" wordmark. Original 1024×1024 PNG resized to 128×128 (~6 KB) for fast loading.
  - **Mobile suggest button**: Styled as a filled blue circle with white "+" icon, properly centered, pushed to the right next to the language toggle.
  - **Scroll offset fix**: All `scrollIntoView` calls replaced with a `scrollToEl()` helper that accounts for the sticky header and category nav height. Quiz results and category filters now scroll to the correct visible position.
  - **Auto-hide header on mobile**: Header slides up and hides when scrolling down (below 680px width), reappears on scroll up. Category nav adjusts its top position accordingly. Desktop header remains sticky and always visible.
- **August 16, 2026** — **Moved off Supabase completely. The site no longer uses a database.**
  - **Why**: Avigdor's free Supabase account is capped at 2 projects. Give Israel was using one of those slots. Freeing it unblocked a separate product, Sage Review.
  - **New `public/data.js`**: all 15 categories and 60 charities now live in one plain JavaScript file loaded by index.html. This is now the single source of truth. To change the directory, edit the file and push.
  - **Suggest form removed the same day**: the whole "Suggest a Charity" modal and form were deleted from `index.html` to keep things simple. The header button is now just an email link to avigdor@crunchybuzz.com. This also removed the `api/` folder, the Resend email service, the honeypot spam field, and every environment variable. The site is 100% static files again — no backend, no secrets.
  - **Admin dashboard retired**: `public/admin.html` moved to `retired/admin.html`. It is no longer deployed and cannot work. giveisrael.charity/admin is gone. Suggestions are reviewed by email now.
  - **Logos moved in-house**: 50 charity logos now live in `public/logos/` and are served from the site. 3 still use a Google favicon URL, 7 have none and show initials instead. The Google Favicon API is no longer the general method.
  - **Security tightened**: Supabase URL removed from the CSP; ipapi.co added (needed for the Hebrew geolocation check). No API keys of any kind remain in the code.
  - **Kept for reference**: `backup-supabase/` holds a raw JSON backup of the old database, and `download-logos.sh` is the one-time script that pulled the logo files out. Nothing on the site reads either of them.
