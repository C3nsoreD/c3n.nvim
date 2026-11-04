#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
# Installs the "JetBrainsMono NL Nerd Font" (NL = No Ligatures) used by this
# Neovim config for icons in the UI.
#
#   macOS  → ~/Library/Fonts
#   Linux  → ~/.local/share/fonts  (then refreshes the font cache)
#
# Usage:  ./install-font.sh
# ──────────────────────────────────────────────────────────────────────────
set -euo pipefail

FONT_NAME="JetBrainsMono"
# Only install the "NL" (no-ligature) faces to match the requested font.
FONT_GLOB="JetBrainsMonoNLNerdFont*.ttf"
RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"

info()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# ── Pick a destination per OS ──────────────────────────────────────────────
case "$(uname -s)" in
  Darwin) FONT_DIR="$HOME/Library/Fonts" ;;
  Linux)  FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts" ;;
  *)      die "Unsupported OS: $(uname -s). Install the font manually from $RELEASE_URL" ;;
esac

# ── On macOS, prefer Homebrew if it's available (keeps the font updatable) ──
if [ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
  info "Homebrew detected — installing via cask (includes the NL variant)…"
  brew install --cask font-jetbrains-mono-nerd-font
  info "Done. Set 'JetBrainsMono Nerd Font' (or the NL face) as your terminal font."
  exit 0
fi

# ── Manual download path ───────────────────────────────────────────────────
command -v unzip >/dev/null 2>&1 || die "'unzip' is required but not installed."

if command -v curl >/dev/null 2>&1; then
  DL=(curl -fL --progress-bar -o)
elif command -v wget >/dev/null 2>&1; then
  DL=(wget -O)
else
  die "Neither curl nor wget is installed."
fi

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

ZIP="$TMP_DIR/${FONT_NAME}.zip"
info "Downloading ${FONT_NAME} Nerd Font…"
"${DL[@]}" "$ZIP" "$RELEASE_URL"

info "Extracting the NL (no-ligature) faces…"
unzip -q -o "$ZIP" "$FONT_GLOB" -d "$TMP_DIR/extracted" \
  || die "No files matching '$FONT_GLOB' found in the archive."

mkdir -p "$FONT_DIR"
count=0
while IFS= read -r -d '' f; do
  cp -f "$f" "$FONT_DIR/"
  count=$((count + 1))
done < <(find "$TMP_DIR/extracted" -name "$FONT_GLOB" -print0)

[ "$count" -gt 0 ] || die "Nothing was installed."
info "Installed $count font file(s) to $FONT_DIR"

# ── Refresh font cache on Linux ────────────────────────────────────────────
if [ "$(uname -s)" = "Linux" ] && command -v fc-cache >/dev/null 2>&1; then
  info "Refreshing font cache…"
  fc-cache -f "$FONT_DIR" >/dev/null
fi

cat <<'EOF'

✔ JetBrainsMono NL Nerd Font installed.

Next: set it as your terminal font.
  • Ghostty   → ~/.config/ghostty/config  →  font-family = JetBrainsMono Nerd Font
  • WezTerm   → font = wezterm.font("JetBrainsMono NL Nerd Font")
  • Kitty     → ~/.config/kitty/kitty.conf →  font_family JetBrainsMono NL Nerd Font
  • Apple Terminal → Settings ▸ Profiles ▸ Text ▸ Font ▸ "JetBrainsMono NL Nerd Font"

Then restart the terminal and run `nvim` — the icons/boxes should be gone.
EOF
