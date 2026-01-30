# /yo search

Search memories by keyword or topic.

## Usage

```
/yo search <query>
/yo recall <query>  # Alias
```

## Examples

```
/yo search error handling
/yo search authentication flow
/yo search database migrations
/yo recall design decisions
```

## Instructions

1. Extract the search query (everything after "search " or "recall ")

2. Call `yolog_search_memories` via CLI:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_search_memories","arguments":{"query":"<QUERY>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```

3. Parse the JSON response

4. Display memories grouped by type:
```
## Search Results for "<query>"

### Decisions
- **[title]**: [summary]

### Patterns
- **[title]**: [summary]

### Architecture
- **[title]**: [summary]

### Bugs
- **[title]**: [summary]

### Other
- **[type] [title]**: [summary]
```

5. Summarize key findings at the end

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<QUERY>` with the user's search query
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- Results use hybrid search (keyword + semantic) for best relevance
