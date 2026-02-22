#!/usr/bin/env bash
set -euo pipefail

cd /repo

export MAZELCLAW_STATE_DIR="/tmp/mazelclaw-test"
export MAZELCLAW_CONFIG_PATH="${MAZELCLAW_STATE_DIR}/mazelclaw.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${MAZELCLAW_STATE_DIR}/credentials"
mkdir -p "${MAZELCLAW_STATE_DIR}/agents/main/sessions"
echo '{}' >"${MAZELCLAW_CONFIG_PATH}"
echo 'creds' >"${MAZELCLAW_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${MAZELCLAW_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm mazelclaw reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${MAZELCLAW_CONFIG_PATH}"
test ! -d "${MAZELCLAW_STATE_DIR}/credentials"
test ! -d "${MAZELCLAW_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${MAZELCLAW_STATE_DIR}/credentials"
echo '{}' >"${MAZELCLAW_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm mazelclaw uninstall --state --yes --non-interactive

test ! -d "${MAZELCLAW_STATE_DIR}"

echo "OK"
