#!/usr/bin/env bash
# install.sh — Symlink my_ai_toolkit configs into a target project
#
# Usage:  ./install.sh /path/to/your/project
# Effect: Creates symlinks for CLAUDE.md, .cursorrules, and AGENTS.md

set -euo pipefail

TARGET="${1:-.}"
TOOLKIT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$TARGET" ]; then
  echo "Error: Target directory '$TARGET' does not exist."
  exit 1
fi

echo "🧰 Installing my_ai_toolkit into: $TARGET"
echo ""

for file in CLAUDE.md .cursorrules AGENTS.md; do
  src="$TOOLKIT_DIR/$file"
  dest="$TARGET/$file"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  ⚠️  $file already exists at $dest — skipping (back up or remove first)"
  else
    ln -s "$src" "$dest"
    echo "  ✅ $file → linked"
  fi
done

echo ""
echo "Done! Your project now loads skills for Claude Code, Cursor, and Codex."
echo "To uninstall, remove the symlinks: rm $TARGET/{CLAUDE.md,.cursorrules,AGENTS.md}"
