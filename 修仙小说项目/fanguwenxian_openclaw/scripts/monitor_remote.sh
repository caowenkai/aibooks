#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory_remote}"
LOG_DIR="$BASE_DIR/logs"
OUT_DIR="$BASE_DIR/output"

echo "== PIDS =="
ps -ef | grep -E "openclaw agent|launch_first_wave_remote" | grep -v grep || true

echo
echo "== OUTPUT FILES =="
find "$OUT_DIR" -maxdepth 1 -type f | sort || true

echo
echo "== LOG TAILS =="
for f in "$LOG_DIR"/*.log; do
  [ -e "$f" ] || continue
  echo "--- $f ---"
  tail -n 20 "$f"
done
