#!/usr/bin/env bash
# Reminder only; does not block. Emits a note if the latest commit touched a handoff.md.
latest_handoff=$(git log -1 --name-only --format='' 2>/dev/null | grep 'handoff\.md$' || true)
if [[ -n "$latest_handoff" ]]; then
  jq -n --arg path "$latest_handoff" '{
    systemMessage: ("Handoff committed: " + $path + ". Auto-advance: run drift check then dispatch stage 06 for the next slice, or stage 10 if this was the final slice.")
  }'
fi
