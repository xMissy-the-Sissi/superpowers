---
name: rolling-out-superpowers
description: Use when installing, updating, or verifying Superpowers across multiple assistant harnesses in one coordinated rollout
---

# Rolling Out Superpowers

## Overview

Run cross-harness rollout as one coordinated operation: one version target, one install pass, one verification pass, one status record.

## Required references

- `docs/system-wide-rollout.md`
- `../using-superpowers/references/harness-capability-matrix.md`

## Process

1. Pick one source-of-truth version (tag or pinned commit SHA).
2. Build a checklist of every harness in scope and its install/update command.
3. Execute installs/updates harness-by-harness using native plugin flows.
4. Verify each harness with the canonical acceptance smoke test:
   - fresh session
   - prompt: `Let's make a react todo list`
   - pass: `brainstorming` triggers before any code is written
5. Record pass/fail per harness and stop rollout completion until failures are resolved.

## Rules

- Do not mix versions across harnesses in the same rollout unless explicitly doing canary testing.
- Do not claim rollout complete without recorded smoke-test results per harness.
- If a harness cannot run automatic session-start bootstrap injection, treat it as unsupported and route to harness-porting workflow.
