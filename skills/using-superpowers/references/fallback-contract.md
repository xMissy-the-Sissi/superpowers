# Shared Fallback Contract

When a harness is missing a native tool that a skill requests, use this contract:

1. **Do not invent tool names.** Use only tools the harness actually exposes.
2. **Prefer documented native fallback first.** If the harness reference defines one, use it.
3. **Skill invocation fallback:** if no native skill tool exists, read the target `skills/<name>/SKILL.md` directly and follow it.
4. **Subagent fallback:** if no subagent capability exists, execute sequentially in the current session.
5. **Task tracking fallback:** if no todo/task tool exists, maintain checklist state in plan markdown or `TODO.md`.
6. **Bootstrap uncertainty fallback:** run the canonical smoke test (`Let's make a react todo list`) in a fresh session before deep work.
7. **State limitations explicitly.** If capability is absent, say exactly which step is degraded.

This contract standardizes behavior across harness mappings and reduces contradictory ad-hoc fallback logic.
