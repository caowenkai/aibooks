#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory}"
PROMPT_DIR="$BASE_DIR/prompts"
OUT_DIR="$BASE_DIR/output_compact"
LOG_DIR="$BASE_DIR/logs_compact"
SCRIPT="$BASE_DIR/scripts/run_prompt_remote.sh"

mkdir -p "$OUT_DIR" "$LOG_DIR"

launch_job() {
  local job_id="$1"
  local agent_id="$2"
  local prompt_file="$3"
  local thinking="$4"
  local timeout="$5"

  nohup bash -lc "
    '$SCRIPT' \
      '$agent_id' \
      '$prompt_file' \
      '$OUT_DIR/${job_id}.json' \
      '$LOG_DIR/${job_id}.log' \
      '$thinking' \
      '$timeout'
  " >/dev/null 2>&1 &

  echo "${job_id} agent:${agent_id} pid:$!"
}

launch_job "architect_compact" "novel-architect" "$PROMPT_DIR/architect_compact.txt" "minimal" "600"
launch_job "volume1_compact" "novel-volume1" "$PROMPT_DIR/volume1_compact.txt" "minimal" "600"
launch_job "style_compact" "novel-style" "$PROMPT_DIR/style_compact.txt" "minimal" "420"
launch_job "batch01_scene_compact" "novel-writer-a" "$PROMPT_DIR/batch01_scene_compact.txt" "minimal" "600"
