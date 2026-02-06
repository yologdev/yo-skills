# /yo memory-search

Search extracted memories by keyword, topic, or tag. Uses hybrid FTS5 + vector search.

## Usage

```
/yo memory-search <query>                    # Keyword/semantic search
/yo memory-search tag:<tagname>              # Filter by tag only
/yo memory-search tag:<tagname> <query>      # Combined: tag filter + keyword search
```

## Examples

```
/yo memory-search error handling
/yo memory-search authentication flow
/yo memory-search tag:bug
/yo memory-search tag:bug timezone
/yo memory-search tag:security api
```

## Instructions

1. Extract the search query (everything after "memory-search ")

2. Parse for tag and keyword:
   - If starts with `tag:<name>` -> extract tag name, rest is keyword query
   - Otherwise -> keyword-only search

3. Resolve the project ID (use resolved `<YOCORE_URL>` and `<AUTH_HEADER>`, see SKILL.md):
```bash
curl -s <YOCORE_URL>/api/projects/resolve?path=<CWD> <AUTH_HEADER>
```
Extract the `id` field as `<PROJECT_ID>`.

4. Call the Yocore HTTP API:
```bash
# Keyword-only search
curl -s -X POST <YOCORE_URL>/api/memories/search \
  -H "Content-Type: application/json" \
  <AUTH_HEADER> \
  -d '{"query":"<QUERY>","project_id":"<PROJECT_ID>","limit":10}'

# Tag-only filter (use browse endpoint)
curl -s <YOCORE_URL>/api/memories?project_id=<PROJECT_ID>&tags=<TAG>&limit=10 <AUTH_HEADER>

# Tag + keyword combined
curl -s -X POST <YOCORE_URL>/api/memories/search \
  -H "Content-Type: application/json" \
  <AUTH_HEADER> \
  -d '{"query":"<QUERY>","project_id":"<PROJECT_ID>","tags":["<TAG>"],"limit":10}'
```

5. Parse the JSON response and display:

```
## Memory Search Results for "<query>"

1. [#id] [Type] **Title** (confidence%)
   Content summary
   Tags: tag1, tag2

2. [#id] [Type] **Title** (confidence%)
   Content summary
```

6. Summarize key findings at the end

## Notes

- **Always include memory IDs** (e.g., `[#42]`) — enables `/yo update` and `/yo delete`
- Keyword search uses hybrid (keyword + semantic) for best relevance
- Tag search filters by exact tag match (AND logic when multiple tags)
- For searching raw session messages (conversations), use `/yo project-search` instead
