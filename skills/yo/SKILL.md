---
name: yo
description: Yolog Memory System - session context, search, and recall. Commands: "/yo init" (setup hooks), "/yo context" (session state + memories), "/yo update" (checkpoint progress), "/yo search <query>" (search memories).
---

# Yolog Memory System

Access project memories and session context from the Yolog desktop app.

## Prerequisites

- [Yolog](https://yolog.dev) desktop app installed
- `jq` installed for JSON parsing (`brew install jq` on macOS)

## Quick Start

Run `/yo init` to set up hooks for the current project, then restart Claude Code.

## Proactive Usage (IMPORTANT)

**At session start:** Use `/yo context` to check for active tasks and recent decisions.

**Before answering historical questions** like "What did we decide about X?":
- ALWAYS use `/yo search <keywords>` BEFORE answering
- Do NOT rely on your own memory - search the project memories first
- Quote the relevant memory in your response

**After significant progress:** Use `/yo update` to checkpoint your work.

## Configuration

MCP CLI path (copy from Yolog Settings > Memory & Skills):

```
MCP_CLI_PATH=/Applications/yolog.app/Contents/MacOS/yolog-mcp-server
```

## Commands

| Command | Description |
|---------|-------------|
| `/yo init` | Set up hooks for current project. See [INIT.md](INIT.md) |
| `/yo context` | Get session context (current state + memories). See [CONTEXT.md](CONTEXT.md) |
| `/yo update` | Update session context (task, decisions, questions). See [UPDATE.md](UPDATE.md) |
| `/yo search <query>` | Search memories by keyword or topic. See [SEARCH.md](SEARCH.md) |
| `/yo recall <query>` | Alias for `/yo search <query>` |

## Instructions

Parse `$ARGUMENTS` to determine the command:

- **If arguments equal `init`**: Follow [INIT.md](INIT.md)
- **If arguments equal `context` or empty**: Follow [CONTEXT.md](CONTEXT.md)
- **If arguments start with `update`**: Follow [UPDATE.md](UPDATE.md)
- **If arguments start with `search` or `recall`**: Follow [SEARCH.md](SEARCH.md)
- **If arguments invalid**: Show usage help below

## Environment Variables

The following environment variables are set by SessionStart hook (after running `/yo init`):

- `YOLOG_SESSION_ID`: Current Claude Code session ID (required for context/update)
- `YOLOG_SESSION_SOURCE`: How session started (startup, resume, compact)

## Included Files

```
yo/
├── SKILL.md        # This file
├── INIT.md         # Setup instructions
├── CONTEXT.md      # Get session context
├── UPDATE.md       # Update session state
├── SEARCH.md       # Search memories
└── hooks/
    ├── session-start.sh  # Captures session ID
    └── pre-compact.sh    # Saves lifeboat before compaction
```

## Usage Help

```
Yolog Memory Commands:
  /yo init                 - Set up hooks for current project
  /yo context              - Get session context + relevant memories
  /yo update               - Update current task/decisions (interactive)
  /yo search <query>       - Search memories by keyword
  /yo recall <query>       - Alias for search
```
