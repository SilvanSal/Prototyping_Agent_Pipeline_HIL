#!/usr/bin/env bash
set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty' <<< "$CLAUDE_HOOK_INPUT")

if [[ "$cmd" == *"--no-verify"* || "$cmd" == *"--no-gpg-sign"* ]]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Hook-bypass flags are not allowed. Fix the underlying issue."
    }
  }'
  exit 0
fi
