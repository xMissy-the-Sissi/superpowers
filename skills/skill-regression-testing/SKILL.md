---
name: skill-regression-testing
description: Use when creating or modifying skills and you need repeatable evidence that behavior still routes, triggers, and executes correctly
---

# Skill Regression Testing

## Overview

Treat skill changes like code changes: define expected behavior, run deterministic checks, and capture evidence before declaring the skill safe.

## Verification scope

For each changed skill, verify:

1. **Discovery:** skill name/description still routes for intended prompts.
2. **Triggering:** expected invocation path still happens for target scenarios.
3. **Execution:** required steps and constraints are followed in outputs.
4. **Fallbacks:** degraded harness behavior follows documented fallback contract.

## Test ladder

Run checks in this order:

1. Static structure checks (frontmatter, references, required files)
2. Deterministic repo tests related to touched skills/docs
3. Scenario evidence (at least one representative prompt per changed behavior)
4. Cross-harness smoke check when bootstrap/routing behavior changed

## Evidence standard

- Do not claim a skill is good without command output or transcript evidence.
- Record what passed, what failed, and what remains unverified.
- If unverified, state the exact gap and required follow-up check.
