#!/bin/bash
# Python Backend Launcher for Tauri Sidecar

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$(dirname "$SCRIPT_DIR")/../../backend"

# Change to backend directory
cd "$BACKEND_DIR" || exit 1

# Activate virtual environment if exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Parse arguments
PORT="${1:-8000}"
if [ "$1" = "--port" ]; then
    PORT="${2:-8000}"
fi

# Start uvicorn
exec python3 -m uvicorn main:app --host 127.0.0.1 --port "$PORT"
