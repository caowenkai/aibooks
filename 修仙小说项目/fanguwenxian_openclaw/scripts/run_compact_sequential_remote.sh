#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"
SCRIPT="$BASE_DIR/scripts/run_prompt_remote.sh"
PROMPT_DIR="$BASE_DIR/prompts"
OUT_DIR="$BASE_DIR/output_compact"
LOG_DIR="$BASE_DIR/logs_compact"

mkdir -p "$OUT_DIR" "$LOG_DIR"

"$SCRIPT" \
  "novel-architect" \
  "$PROMPT_DIR/architect_compact.txt" \
  "$OUT_DIR/architect_compact.json" \
  "$LOG_DIR/architect_compact.log" \
  "minimal" \
  "600"

"$SCRIPT" \
  "novel-volume1" \
  "$PROMPT_DIR/volume1_compact.txt" \
  "$OUT_DIR/volume1_compact.json" \
  "$LOG_DIR/volume1_compact.log" \
  "minimal" \
  "600"

"$SCRIPT" \
  "novel-writer-a" \
  "$PROMPT_DIR/batch01_scene_compact.txt" \
  "$OUT_DIR/batch01_scene_compact.json" \
  "$LOG_DIR/batch01_scene_compact.log" \
  "minimal" \
  "600"
