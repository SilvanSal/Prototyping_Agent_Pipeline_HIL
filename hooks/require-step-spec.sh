#!/usr/bin/env bash
set -euo pipefail

path=$(jq -r '.tool_input.file_path // empty' <<< "$CLAUDE_HOOK_INPUT")

# Always allow writes inside specs/, .claude/, or the triad root files.
case "$path" in
  specs/*|*/specs/*) exit 0 ;;
  .claude/*|*/.claude/*) exit 0 ;;
  */CLAUDE.md|*/tech-stack.md|*/code-style.md|*/best-practices.md|CLAUDE.md|tech-stack.md|code-style.md|best-practices.md) exit 0 ;;
esac

# Application-code writes require an active step-spec.
if ls specs/*/slices/*/step-spec.md >/dev/null 2>&1; then
  exit 0
fi

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: "No active step-spec.md found. Run plan-slices + research-step stages before writing application code."
  }
}'
