#!/usr/bin/env bash
# Install the educational-pr-description agent skill.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/USER/REPO/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/USER/REPO/main/install.sh | bash -s -- claude
#   curl -fsSL https://raw.githubusercontent.com/USER/REPO/main/install.sh | bash -s -- project
#
# Targets:
#   agents   (default) -> ~/.agents/skills/educational-pr-description/SKILL.md
#   claude             -> ~/.claude/skills/educational-pr-description/SKILL.md
#   project            -> ./.claude/skills/educational-pr-description/SKILL.md

set -euo pipefail

# Update this to the raw URL of SKILL.md in your published repo.
SKILL_URL="${SKILL_URL:-https://raw.githubusercontent.com/USER/REPO/main/SKILL.md}"

TARGET="${1:-agents}"
SKILL_NAME="educational-pr-description"

case "$TARGET" in
  agents)
    DIR="$HOME/.agents/skills/$SKILL_NAME"
    ;;
  claude)
    DIR="$HOME/.claude/skills/$SKILL_NAME"
    ;;
  project)
    DIR="./.claude/skills/$SKILL_NAME"
    ;;
  *)
    echo "Unknown target: $TARGET" >&2
    echo "Usage: install.sh [agents|claude|project]" >&2
    exit 1
    ;;
esac

mkdir -p "$DIR"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$SKILL_URL" -o "$DIR/SKILL.md"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$DIR/SKILL.md" "$SKILL_URL"
else
  echo "Error: need curl or wget installed." >&2
  exit 1
fi

echo "Installed educational-pr-description skill to:"
echo "  $DIR/SKILL.md"
echo
echo "Ask your agent to write a PR/MR description and the skill will activate."
