#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT/astro-site-builder.sh" --help >/dev/null
"$ROOT/astro-site-builder.sh" --version | grep -q '1.1.1'
test -f "$ROOT/templates/blog/src/pages/index.astro"
test ! -e "$ROOT/templates/portfolio"
test ! -e "$ROOT/templates/hybrid"
grep -q 'TYPE=blog' "$ROOT/astro-site-builder.sh"
grep -q 'mkdir -p "$DEST/public/images"' "$ROOT/astro-site-builder.sh"
test -f "$ROOT/templates/shared/src/content.config.ts"
test -f "$ROOT/templates/shared/src/pages/rss.xml.ts"
test -f "$ROOT/templates/shared/src/pages/robots.txt.ts"
test -f "$ROOT/templates/shared/public/favicon.svg"
test -f "$ROOT/templates/shared/public/images/article-placeholder.svg"
grep -q 'heroImage: "/images/article-placeholder.svg"' "$ROOT/templates/shared/src/content/blog/welcome-bg.md"
grep -q 'heroImageAlt:' "$ROOT/templates/shared/src/content/blog/welcome-bg.md"
grep -q 'heroImage: "/images/article-placeholder.svg"' "$ROOT/templates/shared/src/content/blog/welcome-en.md"
test ! -e "$ROOT/templates/shared/src/pages/projects"
test ! -e "$ROOT/templates/shared/src/content/projects"
test -f "$ROOT/templates/shared/public/favicon.ico"
test -f "$ROOT/templates/shared/public/apple-touch-icon.png"
grep -q "@astrojs/sitemap" "$ROOT/templates/shared/astro.config.mjs"
grep -q "Sitemap:.*sitemap-index.xml" "$ROOT/templates/shared/src/pages/robots.txt.ts"
grep -q "rel=\"icon\" type=\"image/svg+xml\"" "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q "seoTitle: z.string().optional()" "$ROOT/templates/shared/src/content.config.ts"
grep -q "heroImageAlt: z.string().optional()" "$ROOT/templates/shared/src/content.config.ts"
for route in \
  "$ROOT/templates/shared/src/pages/en/categories/index.astro" \
  "$ROOT/templates/shared/src/pages/en/tags/index.astro" \
  "$ROOT/templates/shared/src/pages/en/categories/[slug].astro" \
  "$ROOT/templates/shared/src/pages/en/tags/[slug].astro"; do
  grep -q "import BaseLayout from" "$route"
  ! grep -q '=>v\.toLowerCase' "$route"
done
node --input-type=module - <<'NODE'
import assert from 'node:assert/strict';
const map = { а:'a', б:'b', в:'v', г:'g', д:'d', е:'e', ж:'zh', з:'z', и:'i', й:'y', к:'k', л:'l', м:'m', н:'n', о:'o', п:'p', р:'r', с:'s', т:'t', у:'u', ф:'f', х:'h', ц:'ts', ч:'ch', ш:'sh', щ:'sht', ъ:'a', ь:'y', ю:'yu', я:'ya' };
const slugify = value => Array.from(value.toLowerCase(), char => map[char] ?? char).join('').normalize('NFKD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
assert.equal(slugify('Спирачки'), 'spirachki');
assert.equal(slugify('Linux & DevOps'), 'linux-devops');
NODE
# v1.0.6 regression checks for accessibility, localization and article metadata.
grep -q 'Skip to main content' "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'article:published_time' "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'No results found.' "$ROOT/templates/shared/src/pages/en/blog/index.astro"
grep -q 'Няма намерени резултати.' "$ROOT/templates/shared/src/pages/blog/index.astro"
grep -q 'Затвори менюто' "$ROOT/templates/shared/src/components/Navigation.astro"
grep -q 'href={localPath(lang, `tags/\${slugify(tag)}`)}' "$ROOT/templates/shared/src/layouts/ArticleLayout.astro"

# v1.0.7 regression checks for generated article TOC.
test -f "$ROOT/templates/shared/src/components/TableOfContents.astro"
grep -q 'TableOfContents lang={lang}' "$ROOT/templates/shared/src/layouts/ArticleLayout.astro"
grep -q 'IntersectionObserver' "$ROOT/templates/shared/src/components/TableOfContents.astro"
grep -q 'article-layout-grid' "$ROOT/templates/shared/src/styles/global.css"

grep -q 'GET(context: APIContext)' "$ROOT/templates/shared/src/pages/rss.xml.ts"
test -f "$ROOT/templates/shared/src/pages/en/rss.xml.ts"
grep -q 'GET(context: APIContext)' "$ROOT/templates/shared/src/pages/en/rss.xml.ts"

# v1.0.8 regression checks for SEO metadata, localization and structured data.
grep -q 'BlogPosting' "$ROOT/templates/shared/src/layouts/ArticleLayout.astro"
grep -q 'application/ld+json' "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'hreflang={alternate.lang}' "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'translationKey: z.string().optional()' "$ROOT/templates/shared/src/content.config.ts"
grep -q "lang === 'en' ? '/en/rss.xml' : '/rss.xml'" "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'translationKey: "welcome"' "$ROOT/templates/shared/src/content/blog/welcome-bg.md"
grep -q 'translationKey: "welcome"' "$ROOT/templates/shared/src/content/blog/welcome-en.md"

# v1.0.9 regression checks for design presets, branding, localized RSS and user guide.
grep -q 'SITE_DESIGN=ocean' "$ROOT/astro-site-builder.sh"
grep -q 'data-design={siteConfig.design' "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'brand-mark.*FS' "$ROOT/templates/shared/src/components/Header.astro"
grep -q "lang === 'en' ? '/en/rss.xml' : '/rss.xml'" "$ROOT/templates/shared/src/components/Footer.astro"
grep -q 'Последни статии' "$ROOT/templates/shared/src/pages/rss.xml.ts"
test -f "$ROOT/CUSTOMIZATION.md"

grep -q 'RSS емисия' "$ROOT/templates/shared/src/layouts/BaseLayout.astro"
grep -q 'FS</span>' "$ROOT/templates/shared/src/components/Header.astro"
grep -q 'FS' "$ROOT/templates/shared/public/favicon.svg"
grep -q 'Ocean' "$ROOT/CUSTOMIZATION.md"

# v1.1.1 regression checks for the Ocean design and Bulgarian documentation.
grep -q 'data-design="ocean"' "$ROOT/templates/shared/src/styles/global.css"
test -f "$ROOT/README.md"
test -f "$ROOT/README.en.md"
test -f "$ROOT/CUSTOMIZATION.md"
test -f "$ROOT/CUSTOMIZATION.en.md"
test -f "$ROOT/CHANGELOG.md"
test -f "$ROOT/CHANGELOG.en.md"

# v1.1.1 regression checks for GitHub profile link and public project docs.
grep -q 'https://github.com/fedya-dev' "$ROOT/templates/shared/src/components/Footer.astro"
grep -q 'github-link' "$ROOT/templates/shared/src/components/Footer.astro"
grep -q 'target="_blank" rel="noopener noreferrer"' "$ROOT/templates/shared/src/components/Footer.astro"
grep -q 'Fedya Serafiev and ChatGPT (OpenAI)' "$ROOT/README.en.md"
grep -q 'Федя Серафиев и ChatGPT (OpenAI)' "$ROOT/README.md"
test -f "$ROOT/CONTRIBUTING.md"
grep -q 'CONTRIBUTING.md' "$ROOT/README.md"
grep -q 'CONTRIBUTING.md' "$ROOT/README.en.md"

printf 'Builder smoke tests passed.\n'
