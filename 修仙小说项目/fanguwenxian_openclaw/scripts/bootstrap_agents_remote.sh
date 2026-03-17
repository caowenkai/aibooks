#!/usr/bin/env bash
set -euo pipefail

MODEL_ID="${1:-rayincode/gpt-5.4}"
BASE_WS="${2:-/root/openclaw_xianxia_factory_remote/agents}"

mkdir -p "$BASE_WS"

ensure_agent() {
  local name="$1"
  local ws="$BASE_WS/$name"

  if openclaw agents list | grep -qE "^Agents:|^- ${name} "; then
    if openclaw agents list | grep -q -- "- ${name} "; then
      echo "exists:$name"
      return 0
    fi
  fi

  openclaw agents add "$name" \
    --workspace "$ws" \
    --model "$MODEL_ID" \
    --non-interactive

  echo "created:$name workspace:$ws"
}

ensure_agent "novel-architect"
ensure_agent "novel-volume1"
ensure_agent "novel-style"
ensure_agent "novel-writer-a"
