# /yo init

Set up Yocore memory integration for LLM coding tools in the current project.

## Usage

```
/yo init                  # Auto-detect installed clients, configure all
/yo init <client>         # Configure one: claude, openclaw, cursor, windsurf, copilot, cline
```

## What This Does

1. Verifies Yocore HTTP API is accessible
2. Detects installed LLM clients (or uses specified client)
3. Injects memory protocol into each client's rules file
4. For Claude Code: also adds auto-approve permissions

> **Note:** If installed via `claude plugin install`, hooks are registered automatically. This command only needs to set up project-specific configuration.

## Instructions

### Step 1: Verify Yocore is running

Check if the Yocore HTTP API is accessible:

```bash
curl -s --max-time 3 http://127.0.0.1:19420/health
```

If this fails, warn the user to start Yocore but continue (configuration will work once Yocore starts).

### Step 2: Determine target clients

Parse the arguments after "init" to determine which clients to configure.

**If a specific client name is given** (e.g., `/yo init cursor`), use only that client:

| Argument | Client |
|----------|--------|
| `claude` | Claude Code |
| `openclaw` | OpenClaw |
| `cursor` | Cursor |
| `windsurf` | Windsurf |
| `copilot` | GitHub Copilot |
| `cline` | Cline |

If the argument is unrecognized, show usage help and stop.

**If no argument** (bare `/yo init`), auto-detect by running these checks:

```bash
# Claude Code — always included (this command runs inside Claude Code)

# OpenClaw
test -d ~/.openclaw

# Cursor
test -d ~/.cursor

# Windsurf
test -d ~/.windsurf

# GitHub Copilot — only if instructions file already exists
test -f .github/copilot-instructions.md

# Cline
test -f .clinerules
```

A client is "detected" if its check succeeds. Claude Code is always included. Collect the list of detected clients for Step 3.

### Step 3: Configure each detected client

For each detected client, perform the steps below. **Idempotency:** Before writing, check if the target file already contains the snippet marker. If found, skip and note "already configured".

#### 3a. Claude Code

**Target file:** `CLAUDE.md` in the project root (create if doesn't exist)
**Idempotency check:** `grep -q "Yolog Memory Protocol" CLAUDE.md 2>/dev/null` — skip if found
**Snippet to append:**

```markdown
### Yolog Memory Protocol (PROACTIVE USE REQUIRED)

This project uses Yolog for persistent memory across coding sessions. Hooks handle session lifecycle automatically.

**Commands (use proactively — do NOT wait for the user to ask):**

| Command | When to use |
|---------|-------------|
| `/yo context` | At session start. When summarizing work or asked "what did we do?" |
| `/yo memory-search <query>` | BEFORE implementing features. BEFORE answering "what did we decide about X?" |
| `/yo memory-search tag:<name>` | Filter by tag: `tag:bug`, `tag:security`, `tag:architecture`, etc. |
| `/yo project-search <query>` | Find past conversations: "when did we discuss X?", "how did we do X before?" |
| `/yo project` | Before working in an unfamiliar area of the codebase |
| `/yo memories` | When user asks about extracted memories from this session |

**Rules — you MUST follow these:**
- **ALWAYS** `/yo memory-search` BEFORE answering questions about past decisions, patterns, or conventions — do NOT rely on your own memory
- **ALWAYS** `/yo memory-search` BEFORE implementing a feature — check if it was discussed or attempted before
- **ALWAYS** `/yo memory-search` when debugging — past sessions may have solved the same issue
- After compaction, context is auto-injected by hooks — no manual `/yo context` needed
- Quote relevant memory IDs (e.g., `[#42]`) when referencing past decisions
- `/yo update` and `/yo delete` are NEVER proactive — only when user explicitly asks
```

**Additional for Claude Code only:** Merge the following into `~/.claude/settings.json` permissions allow list (create `permissions.allow` array if needed):

```json
"Skill(yo)",
"Bash(curl *)"
```

If `~/.claude/settings.json` has invalid JSON, back it up and create fresh.

#### 3b. Non-Claude clients (OpenClaw, Cursor, Windsurf, Copilot, Cline)

For each non-Claude client, use the target file and idempotency check from this table:

| Client | Target file | Idempotency check |
|--------|-------------|-------------------|
| OpenClaw | `~/.openclaw/workspace/USER.md` | `grep -q "Yocore Memory System" ~/.openclaw/workspace/USER.md 2>/dev/null` |
| Cursor | `.cursorrules` (project root) | `grep -q "Yocore Memory System" .cursorrules 2>/dev/null` |
| Windsurf | `.windsurfrules` (project root) | `grep -q "Yocore Memory System" .windsurfrules 2>/dev/null` |
| Copilot | `.github/copilot-instructions.md` | `grep -q "Yocore Memory System" .github/copilot-instructions.md 2>/dev/null` |
| Cline | `.clinerules` (project root) | `grep -q "Yocore Memory System" .clinerules 2>/dev/null` |

If the idempotency check passes (exit code 0), skip and note "already configured".

Otherwise, append the **portable snippet** below to the target file (create the file if it doesn't exist). For Copilot, create the `.github/` directory first if needed. When appending to an existing file, add two blank lines before the snippet.

**Portable snippet to append:**

```
## Yocore Memory System (PROACTIVE USE REQUIRED)

This project uses Yocore for persistent memory across coding sessions. Base URL: http://127.0.0.1:19420 (override with YOCORE_URL env var). If YOCORE_API_KEY is set, add -H "Authorization: Bearer <key>" to all curl calls.

### When to search memories (do NOT wait for user to ask)
- User asks "what did we decide/do?", "why did we...", "I don't remember" → search memories
- Before implementing a feature → search for prior decisions
- User is debugging → search for past solutions
- User asks "how did we do X before?" → search conversations

### Core commands

# 1. Get session context (current state + memories)
curl -s -X POST http://127.0.0.1:19420/api/context/session \
  -H "Content-Type: application/json" \
  -d '{"session_id":"<SESSION_ID>","project_path":"<CWD>"}'

# 2. Search extracted memories (decisions, facts, patterns)
# First resolve project ID:
PROJECT_ID=$(curl -s http://127.0.0.1:19420/api/projects/resolve?path=<CWD> | jq -r '.id')
# Then search:
curl -s -X POST http://127.0.0.1:19420/api/memories/search \
  -H "Content-Type: application/json" \
  -d '{"query":"<SEARCH_QUERY>","project_id":"'$PROJECT_ID'","limit":10}'

# 3. Search raw session conversations
curl -s -X POST http://127.0.0.1:19420/api/search \
  -H "Content-Type: application/json" \
  -d '{"query":"<SEARCH_QUERY>","project_id":"'$PROJECT_ID'","limit":20}'

# 4. Get project-wide context
curl -s http://127.0.0.1:19420/api/context/project?project_path=<CWD>

### Rules
- ALWAYS search memories BEFORE answering questions about past decisions
- ALWAYS search memories BEFORE implementing features — check if discussed before
- Display memory IDs (e.g., [#42]) when referencing results
- If the answer might exist in past sessions, search first, answer second
```

### Step 4: Display results

Show a dynamic summary based on what was configured:

```
Yolog configured successfully!

Clients configured:
  ✓ Claude Code → CLAUDE.md (Yolog Memory Protocol)
  ✓ OpenClaw → ~/.openclaw/workspace/USER.md (Yocore Memory System)
  ✓ Cursor → .cursorrules (Yocore Memory System)
  - Windsurf → not detected
  - Copilot → not detected
  - Cline → already configured

Settings updated:
  - ~/.claude/settings.json (auto-approve permissions)

Next steps:
  1. Restart Claude Code to activate hooks
  2. Open other configured clients for their config to take effect
  3. Use /yo context to verify session ID is captured

Yocore API: [http://127.0.0.1:19420 or "Not reachable - start Yocore"]
```

Adjust the list based on actual detection and configuration results. Use ✓ for newly configured, "already configured" for skipped (idempotent), and "not detected" for clients not found.

## Error Handling

- If `~/.claude/settings.json` has invalid JSON, back it up and create fresh
- If Yocore is not reachable, warn but continue (hooks will work once Yocore starts)
- If a target file is read-only, warn and continue to next client
- If creating `.github/` directory fails, warn and continue

## Notes

- The hooks require `jq` and `curl` to be installed
- After init, user must restart Claude Code for hooks to take effect
- OpenClaw's `USER.md` is user-level (applies across all OpenClaw sessions, not just this project)
- For Copilot, auto-detection only triggers if `.github/copilot-instructions.md` already exists. Use `/yo init copilot` to create it explicitly.
