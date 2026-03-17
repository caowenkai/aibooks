#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"
LOG_FILE="${2:-$BASE_DIR/logs_compact/sequential_runner.log}"
SCRIPT="$BASE_DIR/scripts/run_compact_sequential_remote.sh"

mkdir -p "$(dirname "$LOG_FILE")"

nohup bash -lc "'$SCRIPT' '$BASE_DIR'" >"$LOG_FILE" 2>&1 &

echo "pid:$!"
echo "log:$LOG_FILE"
