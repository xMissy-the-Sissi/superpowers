#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MARKETPLACE="$REPO_ROOT/.github/plugin/marketplace.json"
PLUGIN_MANIFEST="$REPO_ROOT/plugin.json"

python3 - "$MARKETPLACE" "$PLUGIN_MANIFEST" "$REPO_ROOT" <<'PY'
import json
import sys
from pathlib import Path

marketplace_path = Path(sys.argv[1])
plugin_path = Path(sys.argv[2])
repo_root = Path(sys.argv[3])

if not marketplace_path.exists():
    raise AssertionError(".github/plugin/marketplace.json must exist")
if not plugin_path.exists():
    raise AssertionError("plugin.json must exist")

marketplace = json.loads(marketplace_path.read_text(encoding="utf-8"))
plugin = json.loads(plugin_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

assert_equal(marketplace.get("name"), "superpowers-marketplace", "marketplace name")
assert_equal(
    marketplace.get("metadata", {}).get("description"),
    "Marketplace for Superpowers core skills library",
    "marketplace description",
)

plugins = marketplace.get("plugins")
if not isinstance(plugins, list):
    raise AssertionError("plugins must be a list")

matching_plugins = [entry for entry in plugins if entry.get("name") == "superpowers"]
assert_equal(len(matching_plugins), 1, "superpowers plugin entry count")

marketplace_plugin = matching_plugins[0]
assert_equal(marketplace_plugin.get("source"), "./", "marketplace plugin source")
assert_equal(plugin.get("name"), marketplace_plugin.get("name"), "plugin manifest name")
assert_equal(plugin.get("version"), marketplace_plugin.get("version"), "plugin version")
assert_equal(
    marketplace.get("metadata", {}).get("version"),
    plugin.get("version"),
    "marketplace metadata version",
)
assert_equal(plugin.get("homepage"), marketplace_plugin.get("homepage"), "plugin homepage")
assert_equal(plugin.get("repository"), marketplace_plugin.get("repository"), "plugin repository")
assert_equal(plugin.get("license"), marketplace_plugin.get("license"), "plugin license")
assert_equal(plugin.get("keywords"), marketplace_plugin.get("keywords"), "plugin keywords")
assert_equal(plugin.get("skills"), "./skills/", "plugin skills path")
assert_equal(plugin.get("hooks"), "./hooks/hooks.json", "plugin hooks path")

hooks_config = repo_root / "hooks" / "hooks.json"
if not hooks_config.exists():
    raise AssertionError("hooks/hooks.json must exist")

print("Copilot marketplace manifest looks good")
PY
