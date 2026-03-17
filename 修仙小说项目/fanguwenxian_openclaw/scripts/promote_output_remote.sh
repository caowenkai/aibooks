#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:?base dir required}"
TASK_ID="${2:?task id required}"
JSON_FILE="${3:?json file required}"
TARGET_FILE="${4:?target file required}"

if [ ! -s "$JSON_FILE" ]; then
  echo "missing_json:$JSON_FILE" >&2
  exit 2
fi

TEXT="$(jq -r '.result.payloads[0].text // empty' "$JSON_FILE")"

if [ -z "$TEXT" ]; then
  echo "missing_text:$JSON_FILE" >&2
  exit 3
fi

mkdir -p "$(dirname "$TARGET_FILE")"

{
  printf '# `%s` 自动产物\n\n' "$TASK_ID"
  printf '生成时间：%s\n\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
  printf '%s\n' "$TEXT"
} > "$TARGET_FILE"

echo "promoted:$TARGET_FILE"
