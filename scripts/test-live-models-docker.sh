#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${MAZELCLAW_IMAGE:-${CLAWDBOT_IMAGE:-mazelclaw:local}}"
CONFIG_DIR="${MAZELCLAW_CONFIG_DIR:-${CLAWDBOT_CONFIG_DIR:-$HOME/.mazelclaw}}"
WORKSPACE_DIR="${MAZELCLAW_WORKSPACE_DIR:-${CLAWDBOT_WORKSPACE_DIR:-$HOME/.mazelclaw/workspace}}"
PROFILE_FILE="${MAZELCLAW_PROFILE_FILE:-${CLAWDBOT_PROFILE_FILE:-$HOME/.profile}}"

PROFILE_MOUNT=()
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE_MOUNT=(-v "$PROFILE_FILE":/home/node/.profile:ro)
fi

echo "==> Build image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo "==> Run live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e MAZELCLAW_LIVE_TEST=1 \
  -e MAZELCLAW_LIVE_MODELS="${MAZELCLAW_LIVE_MODELS:-${CLAWDBOT_LIVE_MODELS:-all}}" \
  -e MAZELCLAW_LIVE_PROVIDERS="${MAZELCLAW_LIVE_PROVIDERS:-${CLAWDBOT_LIVE_PROVIDERS:-}}" \
  -e MAZELCLAW_LIVE_MODEL_TIMEOUT_MS="${MAZELCLAW_LIVE_MODEL_TIMEOUT_MS:-${CLAWDBOT_LIVE_MODEL_TIMEOUT_MS:-}}" \
  -e MAZELCLAW_LIVE_REQUIRE_PROFILE_KEYS="${MAZELCLAW_LIVE_REQUIRE_PROFILE_KEYS:-${CLAWDBOT_LIVE_REQUIRE_PROFILE_KEYS:-}}" \
  -v "$CONFIG_DIR":/home/node/.mazelclaw \
  -v "$WORKSPACE_DIR":/home/node/.mazelclaw/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
