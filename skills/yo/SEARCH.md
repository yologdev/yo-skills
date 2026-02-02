# /yo search

Search memories by keyword, topic, or tag.

## Usage

```
/yo search <query>                    # Keyword/semantic search
/yo search tag:<tagname>              # Filter by tag only
/yo search tag:<tagname> <query>      # Combined: tag filter + keyword search
```

## Examples

```
/yo search error handling
/yo search authentication flow
/yo search tag:bug
/yo search tag:bug timezone           # Bugs related to timezone
/yo search tag:security api           # Security issues about API
```

## Instructions

1. Extract the search query (everything after "search ")

2. Parse for tag and keyword:
   - If starts with `tag:<name>` → extract tag name, rest is keyword query
   - Otherwise → keyword-only search

   Examples:
   - `tag:bug` → tag="bug", query=none
   - `tag:frontend api` → tag="frontend", query="api"
   - `error handling` → tag=none, query="error handling"

3. **Tag filter (with or without query)** - Call `yolog_get_memories_by_tag`:
```bash
# Tag only
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_memories_by_tag","arguments":{"tag":"<TAG>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>

# Tag + keyword
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_get_memories_by_tag","arguments":{"tag":"<TAG>","query":"<QUERY>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```

4. **Keyword-only search** - Call `yolog_search_memories`:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_search_memories","arguments":{"query":"<QUERY>","project_path":"<CWD>","limit":10}}}' | <MCP_CLI_PATH>
```

5. Parse the JSON response

6. Display memories:
```
## Search Results for "<query>"

1. [Type] **Title** (confidence%)
   Content summary
   Tags: tag1, tag2

2. ...
```

7. Summarize key findings at the end

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<QUERY>` or `<TAG>` with the extracted value
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- Keyword search uses hybrid (keyword + semantic) for best relevance
- Tag search filters by exact tag match, then optionally by keyword in title/content
