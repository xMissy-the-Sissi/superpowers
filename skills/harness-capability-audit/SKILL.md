---
name: harness-capability-audit
description: Use when a harness tool surface is uncertain and you need to determine supported capabilities before choosing workflow steps
---

# Harness Capability Audit

## Overview

Audit capabilities first, then choose execution paths that the harness can actually support.

## Required references

- `../using-superpowers/references/harness-capability-matrix.md`
- `../using-superpowers/references/fallback-contract.md`

## Audit checklist

For the current harness, identify:

1. Bootstrap mechanism (session-start hook, in-process extension, or instructions file)
2. Skill invocation path (native skill tool vs direct SKILL.md read fallback)
3. Subagent support (native, optional, unavailable)
4. Task tracking support (native todos, artifact/file fallback)
5. Web/tooling capabilities used by your planned workflow

## Decision rules

- If capability exists: use native path.
- If missing: apply shared fallback contract.
- If bootstrap path is uncertain: run canonical smoke test before deep work.
- Never invent tools; use exact machine names exposed by the harness.
