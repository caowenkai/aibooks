#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-/root/openclaw_xianxia_factory_remote}"
PROMPT_DIR="$BASE_DIR/prompts"
OUT_DIR="$BASE_DIR/output"
LOG_DIR="$BASE_DIR/logs"

mkdir -p "$PROMPT_DIR" "$OUT_DIR" "$LOG_DIR"

launch_job() {
  local job_id="$1"
  local agent_id="$2"
  local prompt_file="$3"
  local out_file="$OUT_DIR/${job_id}.json"
  local log_file="$LOG_DIR/${job_id}.log"

  nohup bash -lc "
    openclaw agent \
      --agent ${agent_id} \
      --thinking medium \
      --timeout 1800 \
      --json \
      --message \"\$(cat '${prompt_file}')\" \
      > '${out_file}'
  " >"${log_file}" 2>&1 &

  echo "${job_id} agent:${agent_id} pid:$! out:${out_file} log:${log_file}"
}

launch_job "architect" "novel-architect" "$PROMPT_DIR/architect_first_wave.txt"
launch_job "volume1" "novel-volume1" "$PROMPT_DIR/volume1_first_wave.txt"
launch_job "style_guide" "novel-style" "$PROMPT_DIR/style_guide_first_wave.txt"
launch_job "batch01" "novel-writer-a" "$PROMPT_DIR/batch01_first_wave.txt"
