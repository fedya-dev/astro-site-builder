# Astro Site Builder

**An interactive Bash generator for creating a standalone bilingual Astro blog.** It produces a clean project that you can edit, validate and deploy independently, without a CMS or a runtime dependency on the generator itself.

[Author's GitHub profile](https://github.com/fedya-dev) · [Документация на български](README.md) · [Customization guide](CUSTOMIZATION.en.md) · [Change log](CHANGELOG.en.md)

> **Credit:** This project was created y by **Fedya Serafiev **. The idea, requirements, design decisions and practical testing were developed iteratively from the author.

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Install and run](#install-and-run)
- [Working with the generated site](#working-with-the-generated-site)
- [Adding posts and images](#adding-posts-and-images)
- [Languages, themes and configuration](#languages-themes-and-configuration)
- [SEO, RSS and Sitemap](#seo-rss-and-sitemap)
- [Validation](#validation)
- [Deployment](#deployment)
- [Repository layout](#repository-layout)
- [Limitations](#limitations)
- [License and contributing](#license-and-contributing)

## Features

- Generates a standalone static blog with Astro.
- Bulgarian and English routes with localized interface elements.
- Two visually distinct design presets: **Midnight** and **Ocean**.
- Light/dark theme toggle.
- Markdown/MDX articles using Astro Content Collections.
- Automatic table of contents (TOC) from H2/H3 headings.
- Local article filtering, categories and tags.
- SEO metadata, canonical URLs, Open Graph/Twitter metadata, JSON-LD and `hreflang`.
- RSS feeds, `robots.txt`, Sitemap and favicon assets.
- Sample posts, a `public/images/` directory and a file-by-file customization guide.

## Requirements

- Linux, macOS or Ubuntu on WSL2.
- Node.js 20 or newer; a currently supported LTS release is recommended.
- npm.
- Internet access to install npm dependencies.

## Install and run

Clone the repository or download the ZIP archive, then enter the project directory and run:

```bash
chmod +x astro-site-builder.sh
./astro-site-builder.sh
```

The generator prompts for:

1. The destination directory for the new site.
2. The site title.
3. The canonical site URL.
4. A design preset — `Midnight` or `Ocean`.

Choose an empty destination directory. The builder refuses to overwrite files in a non-empty directory. It copies the template, installs dependencies and runs a production build. If installation or the build fails, review the error output, fix the issue and run the relevant npm commands from the generated directory.

Useful generator options:

```bash
./astro-site-builder.sh --help
./astro-site-builder.sh --version
```

## Working with the generated site

From the generated site's directory:

```bash
npm run dev       # local development server
npm run check     # Astro and TypeScript diagnostics
npm run build     # validate and create dist/
npm run preview   # preview the production build locally
```

## Adding posts and images

Create a file such as `src/content/blog/linux-tips.md`:

```yaml
---
title: "Practical Linux Tips"
seoTitle: "Linux Tips for Everyday Work"
description: "A concise summary for search results and article listings."
pubDate: 2026-10-10
category: "Linux"
tags: [Linux, Bash]
lang: en
draft: false
heroImage: "/images/linux-tips.webp"
heroImageAlt: "Describe the meaningful content of the image"
---

Write the article in Markdown here.
```

Required fields are `title`, `description` and `pubDate`. `lang` must be `bg` or `en`. Posts with `draft: true` are excluded from production output. Bulgarian posts use `/blog/`; English posts use `/en/blog/`.

Put image files in `public/images/` and reference them with URLs such as `/images/linux-tips.webp`. The image must be included in the project to be available after deployment.

Optional frontmatter fields include `seoTitle`, `translationKey`, `updatedDate`, `category`, `tags`, `heroImage`, `heroImageAlt` and `author`. Use the same `translationKey` for matching Bulgarian and English versions to generate alternate-language links.

## Languages, themes and configuration

- Bulgarian routes: `/`, `/blog/`, `/categories/`, `/tags/`, `/about/`.
- English routes: `/en/`, `/en/blog/`, `/en/categories/`, `/en/tags/`, `/en/about/`.
- Content is not translated automatically; create a separate post for each language.
- The language switch sends readers to the other language's home page, not automatically to a translated version of the current post.

The `site.config.json` file contains the main settings:

```json
{
  "type": "blog",
  "defaultLang": "bg",
  "title": "My Site",
  "site": "https://example.com",
  "design": "midnight"
}
```

- **Midnight** — dark-first styling with a vivid green accent.
- **Ocean** — blue/green styling, a light default background, gradients and rounder elements.

Both presets support light and dark modes. Set `site` to the final public HTTPS origin before deployment; canonical URLs, RSS and Sitemap use this value. Do not leave the local development URL in a production configuration.

For a file-by-file guide to editing navigation, footer, colors, SEO or the TOC, see [CUSTOMIZATION.en.md](CUSTOMIZATION.en.md).

## SEO, RSS and Sitemap

- `/rss.xml` contains posts in the language configured by `defaultLang`; `/en/rss.xml` contains English posts.
- The RSS discovery link and label follow the current page language.
- Article pages emit `BlogPosting` JSON-LD; home pages emit `WebSite` JSON-LD.
- `hreflang` links are generated for matching static routes and articles sharing a `translationKey`.
- `@astrojs/sitemap` generates a Sitemap during the production build.
- `src/pages/robots.txt.ts` generates `robots.txt` with a Sitemap reference.
- Favicon assets are copied from `public/` to the build output.

After a successful build, check the generated files with:

```bash
ls -la dist/sitemap-index.xml dist/robots.txt dist/favicon.svg dist/favicon.ico dist/apple-touch-icon.png
```

## Validation

From the repository root, validate the shell syntax and run the included smoke tests:

```bash
bash -n astro-site-builder.sh
bash tests/test-builder.sh
./astro-site-builder.sh --version
```

Smoke tests check the generator structure and key regressions, but **do not replace** `npm run check` and `npm run build` on a real generated site. Before accepting changes, generate a test site in an empty directory and verify both themes, BG/EN routes, a post with an image, RSS and the production build.

## Deployment

The generated site is static and can be deployed to Cloudflare Pages or another static host. Typical Cloudflare Pages settings are:

- Build command: `npm run build`
- Output directory: `dist`

After the first successful install, commit `package-lock.json` so CI/CD can use `npm ci` for reproducible dependency installation.

## Repository layout

```text
astro-site-builder/
├── astro-site-builder.sh       # interactive Bash generator
├── templates/
│   ├── shared/                 # shared Astro project, components and routes
│   └── blog/                   # Blog home-page template
├── tests/
│   └── test-builder.sh         # smoke tests
├── README.md                   # Bulgarian documentation
├── README.en.md                # English documentation
├── CUSTOMIZATION.md            # customization guide (BG)
├── CUSTOMIZATION.en.md         # customization guide (EN)
├── CHANGELOG.md                # change log (BG)
├── CHANGELOG.en.md             # change log (EN)
├── CONTRIBUTING.md             # contribution guidelines
└── LICENSE                     # MIT license
```

## Limitations

- The generator creates Blog projects only; Portfolio and Hybrid modes are not supported.
- This is not a CMS. Posts are authored in Markdown/MDX and changes require a new build and deployment.
- Automatic translation between Bulgarian and English is not provided.
- Always inspect the production build before deployment; smoke tests alone cannot guarantee every generated site is fully functional.

## License and contributing

The project is distributed under the [MIT License](LICENSE). For a bug report or suggestion, open an issue from the author's GitHub profile or follow [CONTRIBUTING.md](CONTRIBUTING.md).

Created collaboratively by **Fedya Serafiev and ChatGPT (OpenAI)**, with practical testing and an emphasis on maintainability, accessibility and real-world use.
