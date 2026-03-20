# Give Israel — Hebrew/English Language Toggle
## Mikoshi Protocol Research Findings

**Date:** March 19, 2026
**Status:** Research complete — awaiting Avigdor's review before any changes

---

## What We're Trying To Do

Add a button to the Give Israel site that lets visitors switch between English and Hebrew. When someone picks Hebrew, all the text flips to Hebrew and the whole layout mirrors (reads right-to-left instead of left-to-right). Their choice gets remembered for next time.

---

## The 10 Hardest Problems (And How To Solve Each)

### 1. Flipping the Entire Layout for Hebrew (RTL)

**The problem:** Hebrew reads right-to-left. That means the whole page needs to mirror — the logo goes to the right, search bar flips, buttons swap sides, cards flow the other direction.

**The solution:** One single HTML attribute change (`dir="rtl"` on the page) handles about 80% of this automatically. For the remaining 20%, we use "CSS logical properties" — a modern CSS feature (supported by all browsers since 2023) that says "put the margin on the *start* side" instead of "put the margin on the *left* side." When the page flips to RTL, "start" automatically becomes the right side.

**CIQ Score: 97/100** — This is a proven, standards-based approach with universal browser support.

---

### 2. Where To Store All The Hebrew Text

**The problem:** The site has two kinds of text: (A) fixed labels like "Search," "Donate," "Featured," "All Charities" — about 80+ pieces of text baked into the HTML, and (B) charity data like names, descriptions, and categories — stored in Supabase.

**The solution — Part A (Labels):** Create a JavaScript "dictionary" object right inside index.html with every label in both languages. Example:
```
en: { search: "Search", donate: "Donate", featured: "Featured" }
he: { search: "חיפוש", donate: "תרומה", featured: "מומלצים" }
```
When someone toggles to Hebrew, JavaScript swaps all the text on the page instantly — no page reload needed.

**The solution — Part B (Charity Data):** Add Hebrew columns directly to the existing Supabase tables. For example, add `name_he`, `description_he`, and `short_description_he` to the charities table, and `name_he` and `description_he` to the categories table. This is the simplest approach since we only need two languages.

**CIQ Score: 96/100** — Simple, maintainable, keeps the single-file architecture. The only thing to watch is making sure every piece of text gets translated.

---

### 3. Fonts That Actually Support Hebrew

**The problem:** The site currently uses Cormorant Garamond (for headings) and Figtree (for body text). Neither of these fonts includes Hebrew characters — they only have Latin/English letters.

**The solution:** Use companion Hebrew fonts from Google Fonts that have a similar *feel*:

| Current (English) | Hebrew Replacement | Why It Works |
|---|---|---|
| Cormorant Garamond (elegant serif headings) | **Frank Ruhl Libre** | The most classic Hebrew serif — elegant, editorial, similar vibe |
| Figtree (clean sans-serif body) | **Heebo** or **Assistant** | Clean, modern Hebrew sans-serif that pairs naturally |

Both fonts load from Google Fonts (free, fast). When Hebrew is active, CSS swaps in the Hebrew fonts. When English is active, the original fonts stay.

**CIQ Score: 98/100** — Frank Ruhl Libre is *the* standard Hebrew serif font. Heebo/Assistant are battle-tested for Hebrew web body text.

---

### 4. The Quiz ("Help Me Find My Cause")

**The problem:** The quiz has 4 questions, each with 4 answer options, plus persona results — that's roughly 40+ pieces of text that all need Hebrew translations. Plus the quiz questions are stored in JavaScript, not in the database.

**The solution:** Move the quiz text into the same dictionary system as the labels. Each question, option, sub-text, and persona description gets an English and Hebrew version. The quiz rendering code picks from the active language. The scoring logic (which is math-based) stays the same — only the visible text changes.

**CIQ Score: 95/100** — Straightforward but labor-intensive. The Hebrew translations for the quiz need to be quality-checked by a Hebrew speaker since the emotional tone matters.

---

### 5. SEO — Making Google Happy With Two Languages

**The problem:** Google recommends separate URLs for each language (like `/en/` and `/he/`). But this is a single-file site with no build tools or server-side rendering.

**The solution (Practical):** Since this is a client-side toggle on a single page:

- Add `hreflang` meta tags pointing to the same URL with language variants
- Use `?lang=he` query parameter as the "Hebrew URL" — the toggle sets this
- Set the `<html lang="...">` tag dynamically when language changes
- Add a `x-default` hreflang for unmatched languages

This isn't *perfect* SEO (separate pages would be ideal), but it's the best you can do without a build system or server. Google can still read the default English content, and Hebrew users get a great experience.

**CIQ Score: 88/100** — This is the weakest point. For truly optimal SEO, you'd eventually want two separate HTML files or a server that detects language. But for a charity directory, the user experience matters more than search ranking for Hebrew keywords. *Noted for future improvement.*

---

### 6. The Language Toggle Button Itself

**The problem:** Where does the button go? What does it look like? How does it behave on mobile?

**The solution:** A small button in the header (next to the "Suggest a Charity" button) showing:

- **When in English:** Shows "עב" (Hebrew abbreviation) with a small globe icon
- **When in Hebrew:** Shows "EN" with a small globe icon
- On mobile, it shrinks to just the text (no globe)
- Clicking it instantly swaps everything — no page reload
- The choice is saved in localStorage so it sticks between visits

**CIQ Score: 96/100** — Standard, expected, unintrusive. Users from bilingual sites will immediately recognize this pattern.

---

### 7. Remembering The User's Choice

**The problem:** If someone picks Hebrew, we don't want them to have to pick it again every time they visit.

**The solution:** Save the choice in `localStorage` (same way the cookie consent already works on the site). On page load, check localStorage first — if it says "he", immediately set the page to Hebrew before anything renders. This prevents a "flash" of English content.

**CIQ Score: 97/100** — Simple, reliable, already proven by the cookie consent on the site.

---

### 8. The Admin Dashboard

**The problem:** admin.html is a separate file. Does it need Hebrew too? And how do admins enter Hebrew translations for charities?

**The solution:** Keep the admin dashboard in English only — it's only used by Avigdor. BUT, add Hebrew input fields next to the English ones when publishing a new charity. So when reviewing a suggestion, the admin sees:

- Name (English): [filled in]
- Name (Hebrew): [empty — fill this in]
- Description (English): [filled in]
- Description (Hebrew): [empty — fill this in]

This way, Hebrew translations get added at publish time, and the admin page stays simple.

**CIQ Score: 96/100** — Practical, doesn't over-complicate the admin workflow.

---

### 9. What Happens When Hebrew Translations Are Missing

**The problem:** Not every charity will have Hebrew translations right away. What shows up on a Hebrew charity card if there's no Hebrew description?

**The solution:** Graceful fallback — if a Hebrew field is empty, show the English version instead. The card still appears, still works, still has a Donate button. Optionally, show a tiny indicator (like a small "EN" tag) so visitors know that particular card hasn't been translated yet.

**CIQ Score: 97/100** — This is the standard approach used by every major multilingual site (Wikipedia, etc.).

---

### 10. Keeping It Maintainable Long-Term

**The problem:** Every time you add new text to the site (new button, new section, new feature), you have to remember to add it in both languages. This can get messy over time.

**The solution:**

- Keep ALL translatable UI text in one clearly-labeled dictionary section at the top of the JavaScript
- Add a comment block that says "ADD TRANSLATIONS HERE" so it's easy to find
- For charity data, the Hebrew columns in Supabase are obvious — if `name_he` is empty, it hasn't been translated yet
- A simple checklist in the docs: "When adding new text: 1. Add English version, 2. Add Hebrew version to the dictionary"

**CIQ Score: 95/100** — Discipline-dependent but realistic for a small, single-maintainer project.

---

## Recommendation Summary

**Overall approach: "Dictionary + Hebrew Columns"**

Here's what the implementation would involve:

1. **A JavaScript translation dictionary** inside index.html with all UI labels in English and Hebrew (~80 entries)
2. **Hebrew columns added to Supabase** (`name_he`, `description_he`, `short_description_he` on charities; `name_he`, `description_he` on categories)
3. **A toggle button** in the header that swaps language instantly
4. **CSS adjustments** for RTL layout (using the `dir="rtl"` attribute + logical properties)
5. **Hebrew Google Fonts** loaded alongside the existing fonts (Frank Ruhl Libre + Heebo)
6. **localStorage** to remember the visitor's choice
7. **Fallback to English** when Hebrew translations are missing

**What does NOT change:**
- The single-file architecture (still one index.html)
- The design aesthetic (same colors, same luxury feel)
- The Supabase setup (just adding columns, no new tables)
- The admin workflow (just adding Hebrew input fields)
- Any existing functionality

---

## Estimated Effort

| Task | Effort |
|---|---|
| Build the translation dictionary (code) | Medium — a few hours |
| CSS RTL adjustments | Medium — needs careful testing |
| Add Hebrew fonts | Quick — just adding Google Font links |
| Add Supabase columns | Quick — done in the dashboard |
| Update admin.html with Hebrew fields | Medium |
| Actually *translating* all the text to Hebrew | **The biggest job** — needs a Hebrew speaker |
| Testing everything in both directions | Medium — needs thorough checking |

---

## What I'd Suggest We Discuss

1. **Do you have someone who can do the Hebrew translations?** The code work is something I can handle, but the actual Hebrew text needs a native speaker.

2. **Should the quiz be translated too, or can it stay English-only for now?** It's the most text-heavy part.

3. **Are you okay with the SEO trade-off?** The toggle approach isn't perfect for Google rankings in Hebrew, but it works great for actual visitors.

4. **Do you want the site to default to Hebrew for visitors from Israel?** (We could detect location, but this can be tricky and Google actually recommends against it.)

---

*Research conducted using the Mikoshi Protocol. No changes have been made to the site.*
