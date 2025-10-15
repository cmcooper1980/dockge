#!/bin/sh
set -e

# --- Paths (adjust only if your image differs) ---
APP_DIR="${APP_DIR:-/app}"
DATA_DIR="${DATA_DIR:-$APP_DIR/data}"
STAMP_FILE="${STAMP_FILE:-$DATA_DIR/.init-user-done}"

# --- Load secrets (compose mounts secrets under /run/secrets/...) ---
# Prefer env if already set; otherwise read from secret files.
: "${PASSWORD_FILE:=/run/secrets/dockge_password}"
if [ -z "${PASSWORD:-}" ] && [ -f "$PASSWORD_FILE" ]; then
  PASSWORD="$(cat "$PASSWORD_FILE" | tr -d '\r\n')"
  export PASSWORD
fi

: "${USER_FILE:=/run/secrets/dockge_user}"
if [ -z "${USER:-}" ] && [ -f "$USER_FILE" ]; then
  USER="$(cat "$USER_FILE" | tr -d '\r\n')"
  export USER
fi

echo "[init] Data Dir: $DATA_DIR"
mkdir -p "$DATA_DIR"

# --- Optional: reset password on every boot if you explicitly ask for it ---
if [ "${RESET_PASSWORD_ON_START:-0}" = "1" ] && [ -n "${PASSWORD:-}" ]; then
  echo "[init] RESET_PASSWORD_ON_START=1; resetting password from secret/env..."
  npm run reset-password || { echo "[init] reset-password failed"; exit 1; }
fi

# --- One-time user creation (when no user exists yet) ---
if [ "${AUTO_CREATE_USER:-1}" = "1" ]; then
  if [ ! -f "$STAMP_FILE" ]; then
    if [ -n "${USER:-}" ] && [ -n "${PASSWORD:-}" ]; then
      echo "[init] Initializing first user from secret/env..."
      npm run reset-password || { echo "[init] reset-password failed"; exit 1; }
      touch "$STAMP_FILE"
      echo "[init] User initialized. Stamp written to $STAMP_FILE"
    else
      echo "[init] Skipping one-time init (USER or PASSWORD missing)."
    fi
  else
    echo "[init] One-time init already done (found $STAMP_FILE)."
  fi
fi

echo "[init] Starting Dockge..."
exec tsx ./backend/index.ts
