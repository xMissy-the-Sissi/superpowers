---
name: bootstrap-verification-and-recovery
description: Use when Superpowers skills are not triggering as expected and bootstrap injection may be missing, stale, or partially loaded
---

# Bootstrap Verification and Recovery

## Overview

When skill triggering is suspicious, verify bootstrap first. Most integration failures are bootstrap failures.

## Canonical check

1. Start a fresh session.
2. Send: `Let's make a react todo list`
3. Pass only if `brainstorming` triggers before code generation.

## Recovery flow

1. Confirm harness install/enablement for Superpowers plugin/extension.
2. Restart or reopen session/runtime where required by harness.
3. Re-run canonical check in a fresh session.
4. If still failing, inspect harness-specific mapping and bootstrap path in:
   - `../using-superpowers/references/harness-capability-matrix.md`
   - harness-specific mapping file in `../using-superpowers/references/`
5. If bootstrap capability does not exist for the harness, classify as unsupported for full Superpowers behavior and route to porting workflow.

## Rules

- Never proceed as if skills are active without verification evidence.
- Do not treat manual one-off prompting as equivalent to automatic bootstrap.
