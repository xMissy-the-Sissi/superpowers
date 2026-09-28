# Superpowers Harness Capability Matrix

Use this matrix to map skill actions to harness capabilities and fallbacks.

## Canonical acceptance smoke test

For any harness install, start a fresh session and send:

> Let's make a react todo list

Pass condition: `brainstorming` triggers before any code is written.

## Capability matrix

| Harness | Bootstrap behavior | Skill invocation path | Subagents | Task tracking | Fallback summary |
|---|---|---|---|---|---|
| Claude Code | SessionStart shell hook (`hooks/session-start`) | Native `Skill` tool | Native subagents | Native todos | None needed in normal path |
| Cursor | SessionStart shell hook (`hooks/session-start`) | Claude-compatible skill flow | Claude-compatible | Claude-compatible | Use Claude-style behavior; see fallback contract |
| GitHub Copilot CLI | SessionStart shell hook (`hooks/session-start`) | Claude-compatible skill flow | Claude-compatible | Claude-compatible | Use Claude-style behavior; see fallback contract |
| Codex (App/CLI) | Native skill discovery (no session-start hook injection path) | Native skill discovery + Codex mapping | Requires multi-agent support enabled | Native task tools vary by version | If multi-agent unavailable, execute inline; do not invent tools |
| Gemini CLI | Extension instructions file (`GEMINI.md`) includes bootstrap + mapping | Native `activate_skill` | `invoke_agent` | `write_todos` | If capability absent, execute inline and track tasks in file |
| Antigravity CLI | Plugin installer + generated context file/session-start path | Read mapped skill mechanism from Antigravity reference | `invoke_subagent` | task artifact (`write_to_file` artifact) | No todo tool; use task artifact |
| Kimi Code | Manifest-driven `sessionStart.skill` | Native marketplace/plugin mechanism | Harness-specific | Harness-specific | Follow Kimi manifest mapping and inline instructions |
| OpenCode | In-process plugin injects bootstrap | Native `skill` tool | `subagent` (V2) / `task` (V1) | No todo tool in V2 | If no subagent tool, run inline |
| Pi | In-process extension context injection | Native skill discovery | Optional companion package | Optional companion package | Read `SKILL.md` and track tasks in plan/TODO when tools missing |
| Qwen Code | Installs from Claude marketplaces | Inherits Claude-compatible behavior | Inherits Claude-compatible behavior | Inherits Claude-compatible behavior | Use Claude-compatible behavior + fallback contract |
| Grok Build CLI | Marketplace install | Harness-native plugin commands | Harness-specific | Harness-specific | If uncertain, run capability audit and use fallback contract |
| Devin CLI | Plugin install from repo | Harness-native plugin commands | Harness-specific | Harness-specific | If uncertain, run capability audit and use fallback contract |
| Factory Droid | Marketplace registration + install | Harness-native plugin commands | Harness-specific | Harness-specific | If uncertain, run capability audit and use fallback contract |
| Hermes Agent | Plugin install + bootstrap limitations on deep compaction | `skill_view` then direct-read fallback | `delegate_task` | `todo` | If `skill_view` misses skill, read SKILL.md directly |
| Muse | Native plugin SessionStart hook | Native skill support + file-read fallback | `subagent_spawn` | `write_todos` | If native tool absent, read SKILL.md and execute inline |

## Fallback policy

Use `fallback-contract.md` as the shared rule set when expected native tools are unavailable.
