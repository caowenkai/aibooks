#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"

echo "== processes =="
ps -ef | grep 'openclaw agent' | grep -v grep || true

echo
echo "== output files =="
ls -lh "$BASE_DIR/output" 2>/dev/null || true

echo
echo "== log files =="
ls -lh "$BASE_DIR/logs" 2>/dev/null || true

for name in architect volume1 style_guide batch01; do
  echo
  echo "== ${name} preview =="
  head -n 40 "$BASE_DIR/output/${name}.json" 2>/dev/null || true
done
