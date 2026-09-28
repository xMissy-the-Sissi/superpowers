#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

MATRIX="$REPO_ROOT/skills/using-superpowers/references/harness-capability-matrix.md"
USING_SKILL="$REPO_ROOT/skills/using-superpowers/SKILL.md"

if [ ! -f "$MATRIX" ]; then
  echo "missing matrix: $MATRIX"
  exit 1
fi

if ! grep -q "Let's make a react todo list" "$MATRIX"; then
  echo "matrix missing canonical smoke prompt"
  exit 1
fi

if ! grep -q "brainstorming" "$MATRIX"; then
  echo "matrix missing brainstorming acceptance condition"
  exit 1
fi

required_harnesses=(
  "Claude Code"
  "Cursor"
  "GitHub Copilot CLI"
  "Codex (App/CLI)"
  "Gemini CLI"
  "Antigravity CLI"
  "Kimi Code"
  "OpenCode"
  "Pi"
  "Qwen Code"
  "Grok Build CLI"
  "Devin CLI"
  "Factory Droid"
  "Hermes Agent"
  "Muse"
)

for harness in "${required_harnesses[@]}"; do
  if ! grep -q "$harness" "$MATRIX"; then
    echo "matrix missing harness row: $harness"
    exit 1
  fi
done

if ! grep -q "harness-capability-matrix.md" "$USING_SKILL"; then
  echo "using-superpowers skill missing matrix reference"
  exit 1
fi

if ! grep -q "Bootstrap Health Check" "$USING_SKILL"; then
  echo "using-superpowers skill missing bootstrap health-check section"
  exit 1
fi

echo "STATUS: PASSED"
