#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

VERSION="1.1.1"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

info(){ printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn(){ printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
err(){ printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }
die(){ err "$*"; exit 1; }
cleanup(){ :; }
trap cleanup EXIT

usage(){ cat <<'EOF'
Astro Site Builder
Usage: ./astro-site-builder.sh [--help] [--version]
Creates a new Astro blog with Bulgarian and English content support.
EOF
}
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  -v|--version) printf 'Astro Site Builder %s\n' "$VERSION"; exit 0 ;;
  "") ;;
  *) usage; die "Unknown option: $1" ;;
esac

command -v node >/dev/null 2>&1 || die "Node.js is missing. Install a supported Node.js LTS release first."
command -v npm >/dev/null 2>&1 || die "npm is missing. Install npm with Node.js."
node -e 'const [a,b]=process.versions.node.split(".").map(Number); process.exit(a<20?1:0)' || die "Node.js 20 or newer is required."
[[ -d "$SCRIPT_DIR/templates/shared" ]] || die "Template directory not found: $SCRIPT_DIR/templates/shared"

printf '\n\033[1;36mAstro Site Builder %s\033[0m\n\n' "$VERSION"
read -r -p 'Project directory [my-astro-site]: ' PROJECT_DIR
PROJECT_DIR=${PROJECT_DIR:-my-astro-site}
[[ "$PROJECT_DIR" != *$'\n'* && "$PROJECT_DIR" != *$'\r'* ]] || die "Invalid project path."
if [[ -e "$PROJECT_DIR" ]]; then
  [[ -d "$PROJECT_DIR" ]] || die "Destination exists and is not a directory."
  if [[ -n "$(find "$PROJECT_DIR" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    read -r -p "Directory '$PROJECT_DIR' is not empty. Continue? [y/N]: " CONFIRM
    [[ "$CONFIRM" =~ ^[Yy]$ ]] || die "Cancelled; existing files were not changed."
    die "For safety, choose an empty directory. The builder will not overwrite existing files."
  fi
fi

TYPE=blog
info "Site type: Blog"

DEFAULT_LANG=bg

read -r -p 'Site title [My Astro Site]: ' SITE_TITLE
SITE_TITLE=${SITE_TITLE:-My Astro Site}
read -r -p 'Site URL (e.g. https://example.com; blank for localhost): ' SITE_URL
SITE_URL=${SITE_URL:-http://localhost:4321}
[[ "$SITE_URL" =~ ^https?://[^[:space:]]+$ ]] || die "Site URL must start with http:// or https:// and contain no spaces."
printf '\nDesign theme:\n  1) Midnight — current dark-first design\n  2) Ocean — blue and green, clean modern layout\n'
read -r -p 'Choose design [1]: ' DESIGN_CHOICE
DESIGN_CHOICE=${DESIGN_CHOICE:-1}
case "$DESIGN_CHOICE" in
  1) SITE_DESIGN=midnight ;;
  2) SITE_DESIGN=ocean ;;
  *) die "Choose 1 (Midnight) or 2 (Ocean)." ;;
esac

mkdir -p "$PROJECT_DIR"
DEST="$(cd "$PROJECT_DIR" && pwd)"
cp -R "$SCRIPT_DIR/templates/shared/." "$DEST/"
cp -R "$SCRIPT_DIR/templates/blog/." "$DEST/"
mkdir -p "$DEST/public/images"

# Safely write user values as JSON strings for the project configuration.
node - "$DEST/site.config.json" "$TYPE" "$DEFAULT_LANG" "$SITE_TITLE" "$SITE_URL" "$SITE_DESIGN" <<'NODE'
const fs = require('node:fs');
const [file, type, defaultLang, title, site, design] = process.argv.slice(2);
fs.writeFileSync(file, JSON.stringify({type, defaultLang, title, site, design}, null, 2) + '\n');
NODE

# Keep the human-readable npm package name valid.
PACKAGE_NAME="$(basename "$DEST" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g; s/^[.-]+//; s/[.-]+$//')"
[[ -n "$PACKAGE_NAME" ]] || PACKAGE_NAME="astro-site"
node - "$DEST/package.json" "$PACKAGE_NAME" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2], name = process.argv[3];
const pkg = JSON.parse(fs.readFileSync(file, 'utf8')); pkg.name = name;
fs.writeFileSync(file, JSON.stringify(pkg, null, 2) + '\n');
NODE

info "Installing dependencies in $DEST"
cd "$DEST"
npm install
info "Checking production build"
npm run build
printf '\n\033[1;32mProject created successfully.\033[0m\n\n'
printf 'Type: %s | Default language: %s | Design: %s\n' "$TYPE" "$DEFAULT_LANG" "$SITE_DESIGN"
printf 'Directory: %s\n\n' "$DEST"
printf 'Next steps:\n  cd %q\n  npm run dev\n\n' "$DEST"
printf 'Edit site.config.json to change the title or canonical site URL.\n'
printf 'Read README.md and CUSTOMIZATION.md for content, design and customization instructions.\n'
