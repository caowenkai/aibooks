#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${1:-/root/openclaw_xianxia_factory_remote/test}"
mkdir -p "$OUT_DIR"

openclaw agent \
  --to +19990000001 \
  --thinking minimal \
  --timeout 180 \
  --json \
  --message "你现在是传统修仙小说写手。只输出三段中文：第一段一句话概括主角，第二段一句话概括冲突，第三段一句话写一个带张力的开场钩子。不要解释，不要使用 Markdown，不要超过180字。" \
  > "$OUT_DIR/smoke_test.json"

echo "saved:$OUT_DIR/smoke_test.json"
