#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="${1:-/root/openclaw_xianxia_factory}"
REPO_DIR="${2:-/root/github_work/aibooks_tmp}"
TARGET_DIR="${3:-$REPO_DIR/修仙小说项目/fanguwenxian_openclaw}"
BRANCH="${4:-master}"

SSH_CMD='ssh -i /root/.ssh/aibooks_ed25519 -o IdentitiesOnly=yes -o StrictHostKeyChecking=no'

if ! command -v rsync >/dev/null 2>&1; then
  echo "rsync not found" >&2
  exit 2
fi

mkdir -p "$TARGET_DIR"

rsync -a --delete \
  --exclude 'remote_snapshots/' \
  --exclude '.DS_Store' \
  --exclude 'output/' \
  --exclude 'logs/' \
  --exclude 'output_compact/' \
  --exclude 'logs_compact/' \
  "$SRC_DIR/" "$TARGET_DIR/"

cd "$REPO_DIR"

git add "修仙小说项目/fanguwenxian_openclaw"

if git diff --cached --quiet; then
  echo "no_changes"
  exit 0
fi

git commit -m "Sync OpenClaw fanguwenxian workspace"
GIT_SSH_COMMAND="$SSH_CMD" git push origin "$BRANCH"

echo "pushed:$(git rev-parse --short HEAD)"
