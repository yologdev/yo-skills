# /yo project

Get project-level context shared across all sessions. Includes key decisions, patterns, architecture insights, and bugs from all past sessions.

## Usage

```
/yo project
```

## Instructions

1. Call `yolog_get_project_context` with current working directory:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_project_context","arguments":{"project_path":"<CWD>"}}}' | <MCP_CLI_PATH>
```

2. Parse the JSON response

3. Display the project context:
```
## Project Context: [project_name]

### Key Decisions
- [decision memories - architectural choices, technology selections]

### Established Patterns
- [pattern memories - code conventions, naming rules]

### Architecture
- [architecture memories - system structure, module relationships]

### Known Bugs & Fixes
- [bug memories - issues found and how they were resolved]

**Total memories:** [count]
```

4. Summarize key conventions and decisions to follow

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- This returns project-wide knowledge, not session-specific state
- Use `/yo context` for session-specific state (active task, recent decisions)
