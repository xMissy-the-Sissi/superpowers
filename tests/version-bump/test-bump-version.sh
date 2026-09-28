#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCRIPT_SOURCE="$REPO_ROOT/scripts/bump-version.sh"
TEST_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

make_fixture() {
  local repo="$1"
  local yaml_body="$2"

  mkdir -p "$repo/scripts" "$repo/.hermes-plugin" "$repo/.github/plugin"
  cp "$SCRIPT_SOURCE" "$repo/scripts/bump-version.sh"
  cat >"$repo/.version-bump.json" <<'JSON'
{
  "files": [
    { "path": "package.json", "field": "version" },
    { "path": ".hermes-plugin/plugin.yaml", "field": "version" },
    { "path": ".github/plugin/marketplace.json", "field": "metadata.version" },
    { "path": ".github/plugin/marketplace.json", "field": "plugins[name=superpowers].version" }
  ],
  "audit": { "exclude": [] }
}
JSON
  cat >"$repo/package.json" <<'JSON'
{
  "name": "fixture",
  "version": "1.2.3"
}
JSON
  printf '%s\n' "$yaml_body" >"$repo/.hermes-plugin/plugin.yaml"
  cat >"$repo/.github/plugin/marketplace.json" <<'JSON'
{
  "metadata": {
    "version": "1.2.3"
  },
  "plugins": [
    {
      "name": "superpowers",
      "version": "1.2.3"
    },
    {
      "name": "other-plugin",
      "version": "9.9.9"
    }
  ]
}
JSON
}

happy_repo="$TEST_ROOT/happy"
make_fixture "$happy_repo" $'name: superpowers\nversion: 1.2.3'

/bin/bash "$happy_repo/scripts/bump-version.sh" --check >"$TEST_ROOT/check.out"
/bin/bash "$happy_repo/scripts/bump-version.sh" --audit >"$TEST_ROOT/audit.out"
/bin/bash "$happy_repo/scripts/bump-version.sh" 2.3.4 >"$TEST_ROOT/bump.out"

[[ "$(jq -r '.version' "$happy_repo/package.json")" == "2.3.4" ]] \
  || fail "JSON manifest was not bumped"
[[ "$(yq -r '.version' "$happy_repo/.hermes-plugin/plugin.yaml")" == "2.3.4" ]] \
  || fail "YAML manifest was not bumped"
[[ "$(jq -r '.metadata.version' "$happy_repo/.github/plugin/marketplace.json")" == "2.3.4" ]] \
  || fail "marketplace metadata version was not bumped"
[[ "$(jq -r '.plugins[] | select(.name == "superpowers") | .version' "$happy_repo/.github/plugin/marketplace.json")" == "2.3.4" ]] \
  || fail "selected marketplace plugin version was not bumped"
[[ "$(jq -r '.plugins[] | select(.name == "other-plugin") | .version' "$happy_repo/.github/plugin/marketplace.json")" == "9.9.9" ]] \
  || fail "non-selected marketplace plugin version should remain unchanged"

jq -e '
  any(.files[];
    .path == ".hermes-plugin/plugin.yaml" and .field == "version")
' "$REPO_ROOT/.version-bump.json" >/dev/null \
  || fail "Hermes manifest is not registered"

jq -e '
  any(.files[];
    .path == ".github/plugin/marketplace.json" and .field == "plugins[name=superpowers].version")
' "$REPO_ROOT/.version-bump.json" >/dev/null \
  || fail "Copilot marketplace manifest is not registered with name-based lookup"

invalid_repo="$TEST_ROOT/invalid"
make_fixture "$invalid_repo" $'name: superpowers\nversion: 123'
cp "$invalid_repo/package.json" "$TEST_ROOT/package.before"
cp "$invalid_repo/.hermes-plugin/plugin.yaml" "$TEST_ROOT/plugin.before"

if /bin/bash "$invalid_repo/scripts/bump-version.sh" 2.3.4 \
  >"$TEST_ROOT/invalid.out" 2>&1; then
  fail "bump accepted a non-string YAML version"
fi

cmp -s "$TEST_ROOT/package.before" "$invalid_repo/package.json" \
  || fail "JSON manifest changed before YAML validation failed"
cmp -s "$TEST_ROOT/plugin.before" "$invalid_repo/.hermes-plugin/plugin.yaml" \
  || fail "invalid YAML manifest changed"

invalid_json_repo="$TEST_ROOT/invalid-json"
make_fixture "$invalid_json_repo" $'name: superpowers\nversion: 1.2.3'
cp "$invalid_json_repo/package.json" "$TEST_ROOT/package-json.before"

jq '.metadata.version = 123' "$invalid_json_repo/.github/plugin/marketplace.json" >"$TEST_ROOT/invalid-marketplace.json"
mv "$TEST_ROOT/invalid-marketplace.json" "$invalid_json_repo/.github/plugin/marketplace.json"
cp "$invalid_json_repo/.github/plugin/marketplace.json" "$TEST_ROOT/marketplace.before"

if /bin/bash "$invalid_json_repo/scripts/bump-version.sh" 2.3.4 \
  >"$TEST_ROOT/invalid-json.out" 2>&1; then
  fail "bump accepted a non-string JSON version"
fi

cmp -s "$TEST_ROOT/package-json.before" "$invalid_json_repo/package.json" \
  || fail "package.json changed before JSON validation failed"
cmp -s "$TEST_ROOT/marketplace.before" "$invalid_json_repo/.github/plugin/marketplace.json" \
  || fail "invalid JSON marketplace manifest changed"

echo "Version-bump tests passed"
