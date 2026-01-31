---
name: yo
description: Yolog Memory System - session context, search, and recall. Commands: "/yo context" (session state + memories), "/yo update" (checkpoint progress), "/yo search <query>" (search memories).
---

# Yolog Memory System

Access project memories and session context from the Yolog desktop app.

## Configuration

MCP CLI path (copy from Yolog Settings > Memory & Skills):

```
MCP_CLI_PATH=/Applications/yolog.app/Contents/MacOS/yolog-mcp-server
```

## Commands

| Command | Description |
|---------|-------------|
| `/yo context` | Get session context (current state + memories). See [CONTEXT.md](CONTEXT.md) |
| `/yo project` | Get project context (shared across all sessions). See [PROJECT.md](PROJECT.md) |
| `/yo update` | Update session context (task, decisions, questions). See [UPDATE.md](UPDATE.md) |
| `/yo search <query>` | Search memories by keyword or topic. See [SEARCH.md](SEARCH.md) |
| `/yo recall <query>` | Alias for `/yo search <query>` |

## Instructions

Parse `$ARGUMENTS` to determine the command:

- **If arguments equal `context` or empty**: Follow [CONTEXT.md](CONTEXT.md)
- **If arguments equal `project`**: Follow [PROJECT.md](PROJECT.md)
- **If arguments start with `update`**: Follow [UPDATE.md](UPDATE.md)
- **If arguments start with `search` or `recall`**: Follow [SEARCH.md](SEARCH.md)
- **If arguments invalid**: Show usage help below

## Environment Variables

The following environment variables are set by SessionStart hook:

- `YOLOG_SESSION_ID`: Current Claude Code session ID (required for context/update)
- `YOLOG_SESSION_SOURCE`: How session started (startup, resume, compact)

## Usage Help

```
Yolog Memory Commands:
  /yo context              - Get session context (current state + memories)
  /yo project              - Get project context (shared across all sessions)
  /yo update               - Update current task/decisions (interactive)
  /yo search <query>       - Search memories by keyword
  /yo recall <query>       - Alias for search
```
