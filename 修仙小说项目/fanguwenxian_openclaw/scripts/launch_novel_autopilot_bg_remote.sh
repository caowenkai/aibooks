#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"
QUEUE_FILE="${2:-$BASE_DIR/autopilot/batch01_queue.tsv}"
LOG_FILE="$BASE_DIR/logs_compact/autopilot.launch.log"

mkdir -p "$(dirname "$LOG_FILE")"

nohup bash "$BASE_DIR/scripts/novel_autopilot_remote.sh" "$BASE_DIR" "$QUEUE_FILE" >> "$LOG_FILE" 2>&1 &
PID=$!

echo "pid:$PID"
echo "log:$LOG_FILE"
