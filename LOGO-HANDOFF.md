# Give Israel — Logo Task (Handoff)

Paste this whole document as the first message of a **new session**, and give that
session access to the `~/dev/give-israel` folder.

---

## Who you're working with

Avigdor Levi — solo founder of Crunchy Buzz and Sage & Savvy. **Not a techie**: explain
everything in plain language, no jargon, keep it short. His #1 rule: **never change
anything without his explicit OK.** Propose → get approval → build → summarise in plain
English. Small low-risk calls are yours; anything significant is his.

---

## ⚠️ READ THIS FIRST — there is a live risk

The site currently references **50 logo images that do not exist yet.**

`public/data.js` has 50 charities with `logo_url` values like `/logos/aleh.png`,
but the folder `public/logos/` **is empty / not present**. If the site is deployed as-is,
those 50 charities show their initials instead of a logo. The site still works — it
degrades gracefully — but it looks worse than it should.

**The original images still exist in the old Supabase Storage bucket right now.**
That is the safety net. `download-logos.sh` in the project root will pull all 50 down in
one command, and `backup-supabase/logo-urls.txt` lists every original URL.

**DO NOT let Avigdor delete the Supabase project until the logos are sorted.**
Once it's deleted, those 50 original images are gone permanently.

---

## The job

Avigdor does not want to host logo files. He wants each charity's logo **linked directly
from that charity's own website**, so nothing is stored in his project.

So: for each of the 50 charities listed in `LOGO-TASK-LIST.md`, find the direct URL to
their logo image on their own site, and replace the `/logos/...` value in
`public/data.js` with that URL.

---

## Background — what this project is now

Give Israel (giveisrael.charity) is a directory of Israeli charities. Visitors browse,
search, filter, and click through to donate on each charity's own site.

- **There is no database.** It was removed on 16 Aug 2026. All data lives in
  `public/data.js` as two plain constants: `GI_CATEGORIES` (15) and `GI_CHARITIES` (60).
- `public/index.html` is one self-contained file (HTML + CSS + JS inline). **Do not split it.**
- No frameworks, no build step. Static files on Vercel, auto-deploys from GitHub.
- The site is bilingual (English + Hebrew, RTL).
- Full context is in `CLAUDE.md` — read it before touching anything.

---

## How the logo actually gets used

In `public/data.js`, each charity has a `logo_url`. The site renders it in an `<img>` tag
on the charity card. If the image fails to load, the card falls back to showing the
charity's initials in a styled blue box. So a broken link is ugly but not fatal.

Three kinds of value are valid:
- a full URL (`https://charity.org/logo.png`) ← **this is what we're moving to**
- a local path (`/logos/name.png`) ← what's there now, files missing
- `null` ← shows initials

---

## Suggested approach (propose it, get his OK, then do it)

**1. Work in batches and delegate.** There are 50 sites. Fetching 50 full web pages is
expensive. Use subagents to do the fetching in parallel batches (e.g. 5 agents × 10
charities) so the raw page dumps land in *their* context, not yours. Have each agent
report back only a compact list of `charity name → logo URL`.

**2. For each charity, look for a logo URL in this order:**
   a. The `og:image` meta tag — often a proper logo, sometimes a social banner. Check it looks like a logo, not a photo.
   b. The header/nav `<img>` on the homepage — usually the real logo, often an `.svg`.
   c. An obvious `/logo.png`, `/logo.svg`, or `/assets/logo...` path.
   d. If nothing good: fall back to `https://www.google.com/s2/favicons?domain=DOMAIN&sz=128`
      (three charities already use this format — it's an accepted fallback here).

**3. Prefer:** square-ish or wordmark logos, `https://` only, no query strings that look
   session-specific, and avoid huge files (a 3 MB banner will slow the site).

**4. Verify every URL actually loads before writing it in.** A URL that 404s is worse than
   the initials fallback. Check status codes.

**5. Update `public/data.js`** — replace only the `logo_url` field for those 50. Change
   nothing else. Keep the file valid JS (`node --check public/data.js`).

**6. Test the real page** before declaring done. A reliable method used previously:
   load `public/index.html` in jsdom with `data.js` inlined, then assert 60 cards render,
   counters read 60/15, the Hebrew toggle flips to RTL and back, search narrows results,
   and there are no JavaScript errors.

**7. Report honestly** which charities you could not find a good logo for, and what you
   used instead.

---

## Things Avigdor should be told plainly

- Linked logos **break silently** when a charity redesigns their website. There is no
  alarm. Suggest he re-check them occasionally, or that a future session adds a small
  script to test all logo URLs at once.
- Some sites block outside linking (hotlink protection). Those will show initials.
- The safe alternative is always available: run `./download-logos.sh` and host the 50
  files. Costs nothing, never breaks. He chose linking to avoid hosting — respect that,
  but if a charity's logo can't be linked reliably, say so rather than forcing it.

---

## Files that matter

| File | What it is |
|---|---|
| `public/data.js` | **The file you're editing.** All 60 charities + 15 categories |
| `LOGO-TASK-LIST.md` | The 50 charities needing logos, with their website URLs. Also lists the 10 to leave alone |
| `download-logos.sh` | Fallback: downloads all 50 originals from Supabase Storage |
| `backup-supabase/logo-urls.txt` | The 50 original Supabase image URLs |
| `CLAUDE.md` | Full project context — read this first |

---

## When it's done

Tell Avigdor in plain English: how many logos are now linked, how many fell back to
favicons or initials, what to check on the live site, and give him the exact terminal
command to push. Then — and only then — confirm the Supabase project is safe to delete.

Written 16 Aug 2026, at the end of the session that moved Give Israel off Supabase.
