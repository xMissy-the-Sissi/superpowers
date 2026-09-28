# System-Wide Superpowers Rollout (Multi-Harness)

Superpowers is installed per assistant harness (plugin/extension/package), not with one global OS-level switch. This guide gives you a single operating model to keep many harnesses in sync.

## 1) Pick one source-of-truth version

Choose one target and use it everywhere:

- a tagged release (recommended), or
- a pinned git ref (commit SHA)

Do not mix versions across harnesses unless you are intentionally testing.

## 2) Install on each first-class supported harness

Use each harness's native install flow from `/home/runner/work/superpowers/superpowers/README.md`.

| Harness | Install / register |
|---|---|
| Claude Code | `/plugin install superpowers@claude-plugins-official` or `superpowers@superpowers-marketplace` (after `/plugin marketplace add obra/superpowers-marketplace`) |
| Antigravity | `agy plugin install https://github.com/obra/superpowers` |
| Codex App | Install from the Codex plugin marketplace UI |
| Codex CLI | `/plugins` → search `superpowers` → install |
| Cursor | `/add-plugin superpowers` (or marketplace search) |
| Devin CLI | `devin plugins install obra/superpowers` |
| Factory Droid | `droid plugin marketplace add https://github.com/obra/superpowers` then `droid plugin install superpowers@superpowers` |
| Gemini CLI | `gemini extensions install https://github.com/obra/superpowers` |
| GitHub Copilot CLI | `copilot plugin marketplace add obra/superpowers-marketplace` then `copilot plugin install superpowers@superpowers-marketplace` |
| Grok Build CLI | `grok plugin install superpowers@xai-official --trust` (or `/marketplace`) |
| Kimi Code | Kimi plugin marketplace UI, or `/plugins install https://github.com/obra/superpowers` |
| OpenCode | Follow `/home/runner/work/superpowers/superpowers/.opencode/INSTALL.md` |
| Pi | `pi install git:github.com/obra/superpowers` |
| Qwen Code | `qwen extensions install obra/superpowers` |
| Hermes Agent | `hermes plugins install obra/superpowers --enable` |
| Muse | `muse plugins install ./` then `muse plugins approve superpowers` (or install from clone path) |

## 3) Validate every harness the same way

For each harness, start a fresh session and send:

> Let's make a react todo list

Pass condition:

- `brainstorming` auto-triggers before any code is written.

If it does not trigger, treat that harness install as failed and troubleshoot before rollout completion.

## 4) Run updates as one coordinated change

Use this checklist each time you upgrade:

- [ ] Confirm new source-of-truth version (tag or commit SHA)
- [ ] Update every harness to that exact version
- [ ] Restart each assistant if its runtime requires restart for plugin hooks
- [ ] Run the acceptance prompt in a fresh session per harness
- [ ] Record pass/fail per harness and fix failures before declaring rollout complete

## 5) Add support for not-yet-supported harnesses

Use `/home/runner/work/superpowers/superpowers/docs/porting-to-a-new-harness.md`.

Hard requirement:

- automatic session-start bootstrap injection (no per-session manual prompting)

Supported integration shapes:

- shell hook at session start
- in-process plugin/extension callback
- extension-declared always-loaded instructions file

Also required:

- harness-specific tool mapping
- passing the same acceptance test (`Let's make a react todo list` triggers `brainstorming` before coding)

## 6) Critical constraint

Copying skill files alone is not enough. The `using-superpowers` bootstrap must load automatically at session start, or skills will not reliably trigger.
