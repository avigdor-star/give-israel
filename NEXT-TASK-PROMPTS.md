# Next Task Prompts for Give Israel

Copy and paste these into new conversations one at a time.

Reminder for every task: there is no database. All charity and category data lives in `public/data.js`.

Also: there is no form and no backend. The "Suggest a Charity" button is just an email link to avigdor@crunchybuzz.com. The site is 100% static files — no serverless functions, no API keys, no environment variables.

Note on TASK 1 below: the logo situation has moved on. See `LOGO-HANDOFF.md` and `LOGO-TASK-LIST.md` — those are now the up-to-date brief for the logos job.

---

## TASK 1: Finish The Charity Logos

```
Review the CLAUDE.md in my give-israel folder for full project context.

All charity data lives in public/data.js — there is no database. Most charities already have a
real logo image saved in public/logos/ and referenced as "/logos/name.png". But 10 still don't:
3 are still using a Google favicon URL (a tiny browser icon, not a real logo), and 7 are null
(the site shows their initials instead).

Find those 10 in public/data.js by looking at logo_url, then:

STEP 1 — RESEARCH AGENT: For each of those charities, search the web for their actual logo.
Good sources:
- Their official website (look for the logo in the header or about page)
- IsraelGives.org profile pages (israelgives.org/amuta/AMUTA_NUMBER)
- Wikipedia
- Their Facebook or LinkedIn page
- GuideStar Israel

Find a direct URL to a decent-quality logo image (PNG, JPG, or SVG).

STEP 2 — VERIFICATION AGENT: A separate agent should independently check that each logo:
- Actually loads (not a broken link)
- Shows the correct organization (not a generic icon or the wrong org)
- Is a reasonable size and quality for a charity card

STEP 3 — Download each approved logo into public/logos/ with a simple lowercase filename,
then update that charity's logo_url in public/data.js to "/logos/thatfilename.png".
Do not link to outside websites for logos — we host them ourselves now.

STEP 4 — Tell me which ones you couldn't find a logo for, and leave those as they are.

Important: I'm not a developer — keep explanations simple. Don't change anything in
public/index.html, only public/data.js and the public/logos/ folder.
```

---

## TASK 2: Rewrite Charity Descriptions

```
Review the CLAUDE.md in my give-israel folder for full project context.

All charity data lives in public/data.js — there is no database.

The short_description and short_description_he fields for all 60 charities need to be audited
and rewritten. These are the one-liner summaries shown on each charity's card on the site.
Many are vague, inaccurate, or unhelpful.

STEP 1 — RESEARCH AGENT: For each charity in public/data.js:
- Visit their actual website and read what they do in their own words
- Check their IsraelGives.org page (israelgives.org/amuta/AMUTA_NUMBER) for their official description
- Cross-reference with Wikipedia or news articles if available
- Write a new short_description that is:
  - 100-200 characters max (this is a hard limit — do not exceed 200 characters)
  - Factually accurate based on what the organization actually says about itself
  - Specific (not generic — say WHAT they do, not just that they "help people")
  - Helpful for a donor deciding whether to click

STEP 2 — HEBREW TRANSLATION AGENT: A separate agent should write the Hebrew
short_description_he for every charity. Rules:
- Do NOT do word-for-word translation — write it the way a native Hebrew speaker would naturally say it
- If the charity has a Hebrew website, use their own Hebrew wording as a reference
- Keep the same 100-200 character limit (this is a hard limit — do not exceed 200 characters)
- Use natural Israeli Hebrew, not formal/literary Hebrew
- Make sure the tone matches the English version without being a robotic mirror of it

STEP 3 — VERIFICATION AGENT: A third agent should independently check every rewritten
description (English AND Hebrew) by:
- Searching for the charity and confirming the English description matches what the org actually does
- Flagging any description that overstates, understates, or misrepresents the charity
- Confirming both English and Hebrew versions are within the 100-200 character limit
- Reading the Hebrew version and confirming it sounds natural, is grammatically correct, and
  accurately represents the charity — not just a stiff translation of the English
- Having the Hebrew checked against the charity's own Hebrew website text where available
- Scoring each description PASS or FAIL (both languages must pass independently)

STEP 4 — Update ONLY the descriptions that passed verification in BOTH languages, by editing
the short_description and short_description_he fields in public/data.js. If Hebrew failed but
English passed, don't update either — both must pass.

Important: I'm not a developer — keep explanations simple. Don't change anything in
public/index.html, only the description fields in public/data.js. Don't touch the full
description field — only the short_description shown on cards.
```
