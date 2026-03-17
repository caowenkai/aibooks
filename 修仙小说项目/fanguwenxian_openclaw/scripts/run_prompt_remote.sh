#!/usr/bin/env bash
set -euo pipefail

AGENT_ID="${1:?agent id required}"
PROMPT_FILE="${2:?prompt file required}"
OUT_FILE="${3:?out file required}"
LOG_FILE="${4:?log file required}"
THINKING="${5:-minimal}"
TIMEOUT_SECONDS="${6:-600}"

mkdir -p "$(dirname "$OUT_FILE")" "$(dirname "$LOG_FILE")"
TMP_OUT="${OUT_FILE}.raw"

nohup bash -lc "
  openclaw agent \
    --agent '${AGENT_ID}' \
    --thinking '${THINKING}' \
    --timeout '${TIMEOUT_SECONDS}' \
    --json \
    --message \"\$(cat '${PROMPT_FILE}')\" \
    > '${TMP_OUT}' 2>'${LOG_FILE}'
" >/dev/null 2>&1 &

PID=$!
echo "pid:${PID}" >> "$LOG_FILE"
echo "raw:${TMP_OUT}" >> "$LOG_FILE"

wait "$PID" || true

awk 'found || /^\{/ { found=1; print }' "$TMP_OUT" > "$OUT_FILE" || true
echo "cleaned:${OUT_FILE}" >> "$LOG_FILE"
