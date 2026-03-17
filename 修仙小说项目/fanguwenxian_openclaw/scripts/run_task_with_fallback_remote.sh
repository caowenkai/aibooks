#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:?base dir required}"
TASK_ID="${2:?task id required}"
TARGET_MD_REL="${3:?target md required}"
PRIMARY_AGENT="${4:?primary agent required}"
PRIMARY_PROMPT_REL="${5:?primary prompt required}"
FALLBACK_AGENT="${6:?fallback agent required}"
FALLBACK_PROMPT_REL="${7:?fallback prompt required}"

OUT_DIR="$BASE_DIR/output_compact"
LOG_DIR="$BASE_DIR/logs_compact"
STATE_DIR="$BASE_DIR/autopilot/state"
TARGET_MD="$BASE_DIR/$TARGET_MD_REL"

mkdir -p "$OUT_DIR" "$LOG_DIR" "$STATE_DIR"

validate_json() {
  local json_file="$1"
  [ -s "$json_file" ] || return 1
  jq -e '.status == "ok" and (.result.payloads[0].text // "") != ""' "$json_file" >/dev/null 2>&1
}

record_attempt() {
  local attempt_key="$1"
  local status="$2"
  printf '%s\t%s\t%s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$attempt_key" "$status" >> "$STATE_DIR/${TASK_ID}.history.tsv"
}

run_one() {
  local agent_id="$1"
  local prompt_rel="$2"
  local suffix="$3"
  local json_file="$OUT_DIR/${TASK_ID}${suffix}.json"
  local log_file="$LOG_DIR/${TASK_ID}${suffix}.log"

  bash "$BASE_DIR/scripts/run_prompt_remote.sh" \
    "$agent_id" \
    "$BASE_DIR/$prompt_rel" \
    "$json_file" \
    "$log_file" \
    "minimal" \
    "300"

  if validate_json "$json_file"; then
    bash "$BASE_DIR/scripts/promote_output_remote.sh" "$BASE_DIR" "$TASK_ID" "$json_file" "$TARGET_MD"
    record_attempt "${agent_id}:${prompt_rel}" "ok"
    echo "success:$json_file"
    return 0
  fi

  record_attempt "${agent_id}:${prompt_rel}" "empty_or_invalid"
  return 1
}

if [ -f "$TARGET_MD" ]; then
  echo "already_done:$TARGET_MD"
  exit 0
fi

if run_one "$PRIMARY_AGENT" "$PRIMARY_PROMPT_REL" ""; then
  exit 0
fi

if run_one "$FALLBACK_AGENT" "$FALLBACK_PROMPT_REL" "_fresh"; then
  exit 0
fi

echo "failed:$TASK_ID" >&2
exit 1
