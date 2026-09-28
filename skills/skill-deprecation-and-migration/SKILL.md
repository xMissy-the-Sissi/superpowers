---
name: skill-deprecation-and-migration
description: Use when retiring, replacing, or renaming skills so routing remains stable and users get clear migration guidance
---

# Skill Deprecation and Migration

## Overview

Deprecate skills intentionally: preserve discoverability, provide migration targets, and avoid silent breakage in existing workflows.

## Deprecation workflow

1. **Declare scope:** what skill is deprecated and why.
2. **Choose replacement:** exact successor skill(s) or explicit removal with no replacement.
3. **Update references:** README catalog, related skills, and mapping docs.
4. **Bridge period:** keep compatibility guidance long enough for active users to transition.
5. **Validate routing:** verify likely prompts still land on an appropriate skill.

## Migration note template

For each deprecated skill, publish:

- deprecated skill name
- replacement skill name/path
- behavior differences that matter
- cutoff/removal condition

## Rules

- Never remove a skill without a documented migration note.
- Never leave references pointing to removed/renamed skills.
- If no replacement exists, explicitly document the fallback workflow.
