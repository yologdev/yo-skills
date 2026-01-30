# /yo update

Update session context with current task state, decisions, or questions.

## Usage

```
/yo update                    # Interactive - prompt for what to update
/yo update task <description> # Set active task
/yo update decision <text>    # Add a decision
/yo update question <text>    # Add an open question
/yo update resolve <text>     # Resolve a question
```

## Instructions

1. Get `YOLOG_SESSION_ID` from environment (set by SessionStart hook)

2. If `YOLOG_SESSION_ID` is not set, inform user:
```
Session ID not available. Make sure the Yolog SessionStart hook is configured.
Check .claude/settings.local.json for hook configuration.
```

3. Parse `$ARGUMENTS` after "update":
   - If empty: Prompt user what to update (task, decision, or question)
   - If starts with "task": Extract task description
   - If starts with "decision": Extract decision text
   - If starts with "question": Extract question text
   - If starts with "resolve": Extract question to resolve

4. Build the arguments object based on what's being updated:
```json
{
  "session_id": "<SESSION_ID>",
  "project_path": "<CWD>",
  "active_task": "<if updating task>",
  "add_decision": "<if adding decision>",
  "add_question": "<if adding question>",
  "resolve_question": "<if resolving question>"
}
```

5. Call `yolog_update_session_context`:
```bash
printf '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"yolog_update_session_context","arguments":<ARGS_JSON>}}' | <MCP_CLI_PATH>
```

6. Confirm the update to user:
```
Session context updated:
- Active Task: [task]
- Decisions recorded: [count]
- Open Questions: [count]
```

## Examples

```
/yo update task Implementing memory states system
/yo update decision Use SQLite instead of file-based storage for session context
/yo update question Should we add automatic memory ranking?
/yo update resolve Should we add automatic memory ranking?
```

## Notes

- Replace `<CWD>` with the current working directory
- Replace `<SESSION_ID>` with YOLOG_SESSION_ID from environment
- Replace `<MCP_CLI_PATH>` with the path from SKILL.md Configuration section
- Use this to checkpoint progress - especially before ending a session
- The lifeboat (resume_context) is automatically saved on context compaction
