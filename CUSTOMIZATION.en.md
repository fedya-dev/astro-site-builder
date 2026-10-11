# Site customization guide

This guide describes where to make common changes in the **generated site** (the project directory you chose when running the builder). You do not need to edit the builder's `templates/` directory for normal site maintenance.

## Quick map: what lives where

| What you want to change | File / location in the generated project |
|---|---|
| Site title, public URL, default language and design preset | `site.config.json` |
| Header logo text, brand name layout, main menu and language switch | `src/components/Header.astro` |
| Mobile menu open/close behavior | `src/components/Navigation.astro` |
| Footer text, links, copyright and GitHub icon | `src/components/Footer.astro` |
| Light/dark toggle behavior | `src/components/ThemeToggle.astro` |
| Global colors, fonts, widths, spacing, responsive styles and theme presets | `src/styles/global.css` |
| Article page layout, author/date display, tags and JSON-LD | `src/layouts/ArticleLayout.astro` |
| Page title, meta description, canonical, Open Graph, Twitter, hreflang and RSS discovery | `src/layouts/BaseLayout.astro` |
| Table of Contents structure and active-heading behavior | `src/components/TableOfContents.astro` |
| Add or edit an article | `src/content/blog/*.md` |
| Homepage content and hero section | `src/pages/index.astro` |
| About page text | `src/pages/about.astro` and `src/pages/en/about.astro` |
| Bulgarian RSS feed | `src/pages/rss.xml.ts` |
| English RSS feed | `src/pages/en/rss.xml.ts` |
| Browser icons / favicon | `public/favicon.svg`, `public/favicon.ico`, `public/apple-touch-icon.png` |
| Search behavior and searchable fields | `src/pages/search-index.json.ts` and `src/pages/blog/index.astro` |
| Crawler rules | `src/pages/robots.txt.ts` |
| Sitemap plugin configuration | `astro.config.mjs` |

## GitHub link in the footer

The icon in the lower-right footer area links to `https://github.com/fedya-dev`. To change the destination, accessible label or placement, edit the `github-link` element in `src/components/Footer.astro`. Its visual styling lives in `src/styles/global.css`.

## Change the logo

The small **FS** mark in the header is text in `src/components/Header.astro`, in the element with class `brand-mark`. Change the text or replace that element with your own inline SVG. Browser and mobile icons are separate files in `public/`; update all three icon files if you replace the monogram with a different logo.

## Add a new category

Categories are generated from article frontmatter; there is no category registry to edit. To introduce a category, add it to an article in `src/content/blog/`:

```yaml
category: "Linux & DevOps"
lang: bg
```

Save the article and rebuild. The category will appear on the category index and the article page. To support both languages, use a suitable localized category label on the English article too (for example, `category: "Linux & DevOps"` or another English label). Keep the category label consistent across articles if you want them grouped together. The URL slug is generated from the label, including Bulgarian-to-Latin transliteration.

## Add a new article

Create a Markdown file such as `src/content/blog/linux-tips.md`, add the required frontmatter (`title`, `description`, `pubDate`, `lang`, `draft`) and then write the article body. Use `lang: bg` for Bulgarian and `lang: en` for English. Published articles use `draft: false`. Images belong in `public/images/` and are referenced as root-relative paths, such as `heroImage: "/images/linux-tips.webp"`. For translations, use the same `translationKey` in both articles to generate reciprocal `hreflang` links.

## Change the visual theme

Choose **Midnight** or **Ocean** when the builder asks for a design. The Midnight theme is the original dark-first design. Ocean is a substantially different blue-and-green style with a light background, gradients, rounded navigation and cards. Visitors can still switch between light and dark modes.

To fine-tune colors later, edit the CSS variables near the top of `src/styles/global.css`. Midnight uses the `:root` and `:root[data-theme=light]` rules. Ocean uses `:root[data-design="ocean"]` and `:root[data-design="ocean"][data-theme="dark"]`.

## Add or change a menu item

Edit the navigation links in `src/components/Header.astro`. Add a link inside `<nav id="primary-navigation">` and provide a localized label where appropriate. If the new link needs a translated destination, add the matching route under `src/pages/en/`. `src/components/Navigation.astro` handles mobile menu interactions; it normally does not need changes just to add a link.

## Check changes before publishing

Run these commands in the generated project:

```bash
npm run check
npm run build
```

Set `site` in `site.config.json` to the real HTTPS domain before deployment. Inspect the generated `dist/` output after a successful build.
