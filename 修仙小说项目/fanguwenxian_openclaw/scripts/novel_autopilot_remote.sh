#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"
QUEUE_FILE="${2:-$BASE_DIR/autopilot/batch01_queue.tsv}"
STATE_DIR="$BASE_DIR/autopilot/state"
LOG_FILE="$BASE_DIR/logs_compact/autopilot.log"
LOCK_FILE="$BASE_DIR/autopilot/autopilot.lock"
SLEEP_SECONDS="${SLEEP_SECONDS:-600}"

mkdir -p "$STATE_DIR" "$(dirname "$LOG_FILE")"

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  echo "autopilot_locked" >&2
  exit 1
fi

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$*" | tee -a "$LOG_FILE"
}

all_done=true

while true; do
  all_done=true

  while IFS=$'\t' read -r task_id target_md primary_agent primary_prompt fallback_agent fallback_prompt; do
    [ -n "${task_id:-}" ] || continue
    [ "$task_id" = "task_id" ] && continue

    if [ -f "$BASE_DIR/$target_md" ]; then
      log "skip_done:$task_id"
      continue
    fi

    all_done=false
    log "start:$task_id"

    if bash "$BASE_DIR/scripts/run_task_with_fallback_remote.sh" \
      "$BASE_DIR" \
      "$task_id" \
      "$target_md" \
      "$primary_agent" \
      "$primary_prompt" \
      "$fallback_agent" \
      "$fallback_prompt"; then
      log "done:$task_id"
      bash "$BASE_DIR/scripts/sync_to_aibooks_remote.sh" >> "$LOG_FILE" 2>&1 || log "sync_failed:$task_id"
      continue
    fi

    log "retry_later:$task_id"
    sleep "$SLEEP_SECONDS"
  done < "$QUEUE_FILE"

  if [ "$all_done" = true ]; then
    log "queue_complete"
    exit 0
  fi
done
