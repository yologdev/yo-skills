# Yolog Skills for Claude Code

Recall project memories during coding sessions. Give Claude Code access to decisions, patterns, bugs, and architecture insights extracted from your past coding sessions.

## What is this?

[Yolog](https://yolog.dev) archives and analyzes your AI coding sessions, extracting valuable memories like:
- **Decisions** - Why you chose a particular approach
- **Patterns** - Established coding patterns in your project
- **Bugs** - Issues you've encountered and fixed
- **Architecture** - How your codebase is structured

These skills let you quickly recall this knowledge in Claude Code using simple commands.

## Available Skills

### `/yo` - Memory Recall

| Command | Description |
|---------|-------------|
| `/yo recall <query>` | Search memories by keyword or topic |
| `/yo context` | Get project overview at session start |

**Examples:**
```
/yo recall error handling
/yo recall authentication
/yo context
```

## Installation

### Prerequisites

1. [Yolog Desktop](https://yolog.dev) installed with sessions imported
2. Memory extraction enabled (Settings > AI Features)

### Option 1: Install via Claude Code (Recommended)

In Claude Code, simply say:
```
install skill https://github.com/yologdev/yo-skills
```

### Option 2: Manual Installation

1. **Clone this repo**
   ```bash
   git clone https://github.com/yologdev/yo-skills.git
   ```

2. **Copy to your project**
   ```bash
   cp -r yo-skills/skills/yo /path/to/your/project/.claude/skills/
   ```

### Configure MCP CLI Path

After installation, configure the MCP CLI path:

1. Open Yolog Desktop > Settings > Memory & Skills
2. Copy the "MCP CLI Path"
3. Open `.claude/skills/yo/SKILL.md`
4. Replace `/path/to/yolog-mcp-server` with the copied path

### Start Using

```
/yo context
/yo recall database migrations
```

## How it Works

The skills invoke the Yolog MCP server CLI to search your local memory database. All data stays on your machine - nothing is sent to external servers.

```
Claude Code → Skill → MCP CLI → Local SQLite DB → Memories
```

## Requirements

- Yolog Desktop (release build with MCP server)
- Claude Code
- Sessions with memory extraction completed

## License

MIT
