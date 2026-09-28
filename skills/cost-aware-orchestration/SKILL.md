---
name: cost-aware-orchestration
description: Use when coordinating subagents or long multi-step execution and you need to control model cost, turn count, and waiting overhead
---

# Cost-Aware Orchestration

## Overview

Optimize for total execution cost (turns × model tier × retries), not just per-call price.

## Core rules

1. Match model tier to task complexity.
2. Batch same-shape small edits where independent.
3. Keep dispatch prompts scoped; avoid pasting session history.
4. Use bounded waits when idle; do local work instead of polling.
5. Reuse artifacts/files for context handoff instead of long inline summaries.

## Routing guidance

- Mechanical, tightly scoped work: cheap model
- Integration/judgment work: standard model
- Architecture/final broad review: most capable model

## Failure guards

- If repeated fix loops persist, escalate model tier and refresh agent context.
- If subagent capability is unavailable, execute inline and keep strict verification gates.
- Always keep evidence-driven verification before completion claims.
