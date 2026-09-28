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
package_path = repo_root / "package.json"

if not marketplace_path.exists():
    raise AssertionError(".github/plugin/marketplace.json must exist")
if not plugin_path.exists():
    raise AssertionError("plugin.json must exist")
if not package_path.exists():
    raise AssertionError("package.json must exist")

marketplace = json.loads(marketplace_path.read_text(encoding="utf-8"))
plugin = json.loads(plugin_path.read_text(encoding="utf-8"))
package = json.loads(package_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

assert_equal(marketplace.get("name"), "superpowers-marketplace", "marketplace name")
assert_equal(
    marketplace.get("metadata", {}).get("description"),
    "Marketplace for Superpowers core skills library",
    "marketplace description",
)
assert_equal(
    marketplace.get("owner"),
    {"name": "Jesse Vincent", "email": "jesse@fsck.com"},
    "marketplace owner",
)

plugins = marketplace.get("plugins")
if not isinstance(plugins, list):
    raise AssertionError("plugins must be a list")

matching_plugins = [entry for entry in plugins if entry.get("name") == "superpowers"]
assert_equal(len(matching_plugins), 1, "superpowers plugin entry count")

marketplace_plugin = matching_plugins[0]
assert_equal(marketplace_plugin.get("source"), "./", "marketplace plugin source")
assert_equal(
    marketplace_plugin.get("description"),
    "Core skills library: TDD, debugging, collaboration patterns, and proven techniques",
    "marketplace plugin description",
)
assert_equal(
    marketplace_plugin.get("author"),
    {
        "name": "Jesse Vincent",
        "email": "jesse@fsck.com",
        "url": "https://github.com/obra",
    },
    "marketplace plugin author",
)
assert_equal(marketplace_plugin.get("license"), "MIT", "marketplace plugin license")
assert_equal(marketplace_plugin.get("category"), "Developer Tools", "marketplace plugin category")
shared_fields = [
    "name",
    "description",
    "version",
    "author",
    "homepage",
    "repository",
    "license",
    "keywords",
    "category",
]
assert_equal(
    {field: plugin.get(field) for field in shared_fields},
    {field: marketplace_plugin.get(field) for field in shared_fields},
    "shared plugin metadata",
)
assert_equal(plugin.get("version"), package.get("version"), "package version")
assert_equal(
    marketplace.get("metadata", {}).get("version"),
    plugin.get("version"),
    "marketplace metadata version",
)
assert_equal(plugin.get("skills"), "./skills/", "plugin skills path")
assert_equal(plugin.get("hooks"), "./hooks/hooks.json", "plugin hooks path")

hooks_config = repo_root / "hooks" / "hooks.json"
if not hooks_config.exists():
    raise AssertionError("hooks/hooks.json must exist")

print("Copilot marketplace manifest looks good")
PY
