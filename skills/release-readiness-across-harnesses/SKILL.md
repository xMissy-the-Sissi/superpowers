---
name: release-readiness-across-harnesses
description: Use when preparing a Superpowers release and you must confirm cross-harness installability, bootstrap behavior, and version consistency
---

# Release Readiness Across Harnesses

## Overview

Gate releases on cross-harness integrity: manifests, version sync, bootstrap path health, and acceptance smoke evidence.

## Required checks

1. Version consistency
   - Ensure manifest/version-tracked files align (`.version-bump.json` and harness manifests).
2. Installation path integrity
   - Validate each first-class harness has a documented, current install flow.
3. Bootstrap integrity
   - Validate bootstrap path still matches harness contract (hook/extension/context-file).
4. Acceptance smoke coverage
   - Ensure canonical smoke test expectation is documented and tracked for each supported harness.

## Evidence standard

- Do not mark release-ready without explicit pass/fail evidence per harness class.
- If a harness is degraded, list it as blocked/degraded with owner + next step.

## References

- `../using-superpowers/references/harness-capability-matrix.md`
- `docs/system-wide-rollout.md`
- `docs/porting-to-a-new-harness.md`
