# /yo tags

List available memory tags for the current project.

## Usage

```
/yo tags
```

## Instructions

1. Resolve the project ID (use resolved `<YOCORE_URL>` and `<AUTH_HEADER>`, see SKILL.md):
```bash
curl -s <YOCORE_URL>/api/projects/resolve?path=<CWD> <AUTH_HEADER>
```
Extract the `id` field as `<PROJECT_ID>`.

2. Call the Yocore HTTP API:
```bash
curl -s <YOCORE_URL>/api/projects/<PROJECT_ID>/memory-tags <AUTH_HEADER>
```

3. Display the tags:
```
## Memory Tags for [project_name]

architecture, bug, database, deployment, performance, security, testing, ui, ...
(N tags total)

Use: /yo memory-search tag:<name> to filter memories by tag
```

## Notes

- Replace `<CWD>` with the current working directory
- Tags help discover what to search for with `/yo memory-search tag:<name>`
