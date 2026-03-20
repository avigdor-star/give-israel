# Next Task Prompts for Give Israel

Copy and paste these into new conversations one at a time.

---

## TASK 1: Fix Charity Logos

```
Review the CLAUDE.md in my give-israel folder for full project context.

The logo_url field for all 57 charities currently uses Google's favicon API, which just pulls tiny browser icons — not real organization logos. I need you to fix this.

For each charity in the Supabase database (project ID: psrtcjaxfeutecirypwd):

STEP 1 — RESEARCH AGENT: For each charity, search the web for their actual logo. Good sources include:
- Their official website (look for logo in header/about page)
- IsraelGives.org profile pages (israelgives.org/amuta/AMUTA_NUMBER)
- Wikipedia
- Their Facebook or LinkedIn page
- GuideStar Israel

Find a direct URL to a decent-quality logo image (PNG, JPG, or SVG). If a charity doesn't have a findable logo, keep the Google favicon as a fallback.

STEP 2 — VERIFICATION AGENT: A separate agent should independently verify that each logo URL:
- Actually loads an image (not a broken link)
- Shows the correct organization's logo (not a generic icon or wrong org)
- Is a reasonable size/quality for display on a charity card

STEP 3 — Also figure out a hosting solution. Options:
- Supabase Storage (the project already uses Supabase)
- Keep using direct external URLs if they're stable
Recommend the best approach.

STEP 4 — Update the logo_url field in the charities table for every charity that got an upgrade.

Important: I'm not a developer — keep explanations simple. Don't change anything on the site itself (index.html), only update the database logo URLs.
```

---

## TASK 2: Rewrite Charity Descriptions

```
Review the CLAUDE.md in my give-israel folder for full project context.

The short_description and short_description_he fields for all 57 charities need to be audited and rewritten. These are the one-liner summaries shown on each charity's card on the site. Many are vague, inaccurate, or unhelpful.

STEP 1 — RESEARCH AGENT: For each charity in the Supabase database (project ID: psrtcjaxfeutecirypwd):
- Visit their actual website and read what they do in their own words
- Check their IsraelGives.org page (israelgives.org/amuta/AMUTA_NUMBER) for their official description
- Cross-reference with Wikipedia or news articles if available
- Write a new short_description that is:
  - 100-200 characters max (this is a hard limit — do not exceed 200 characters)
  - Factually accurate based on what the organization actually says about itself
  - Specific (not generic — say WHAT they do, not just that they "help people")
  - Helpful for a donor deciding whether to click

STEP 2 — HEBREW TRANSLATION AGENT: A separate agent should write the Hebrew short_description_he for every charity. Rules:
- Do NOT do word-for-word translation — write it the way a native Hebrew speaker would naturally say it
- If the charity has a Hebrew website, use their own Hebrew wording as a reference
- Keep the same 100-200 character limit (this is a hard limit — do not exceed 200 characters)
- Use natural Israeli Hebrew, not formal/literary Hebrew
- Make sure the tone matches the English version without being a robotic mirror of it

STEP 3 — VERIFICATION AGENT: A third agent should independently check every rewritten description (English AND Hebrew) by:
- Searching for the charity and confirming the English description matches what the org actually does
- Flagging any description that overstates, understates, or misrepresents the charity
- Confirming both English and Hebrew versions are within the 100-200 character limit
- Reading the Hebrew version and confirming it sounds natural, is grammatically correct, and accurately represents the charity — not just a stiff translation of the English
- Having the Hebrew checked against the charity's own Hebrew website text where available
- Scoring each description PASS or FAIL (both languages must pass independently)

STEP 4 — Update ONLY the descriptions that passed verification in BOTH languages in the Supabase charities table (both short_description and short_description_he fields). If Hebrew failed but English passed, don't update either — both must pass.

Important: I'm not a developer — keep explanations simple. Don't change anything on the site itself (index.html), only update the database fields. Don't touch the full description field — only the short_description shown on cards.
```
