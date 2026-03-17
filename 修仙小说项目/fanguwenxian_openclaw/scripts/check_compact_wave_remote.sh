#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"

echo "== compact outputs =="
ls -lh "$BASE_DIR/output_compact" 2>/dev/null || true

echo
echo "== compact logs =="
ls -lh "$BASE_DIR/logs_compact" 2>/dev/null || true

for name in architect_compact volume1_compact style_compact batch01_scene_compact; do
  echo
  echo "== ${name} preview =="
  sed -n '1,60p' "$BASE_DIR/output_compact/${name}.json" 2>/dev/null || true
done
