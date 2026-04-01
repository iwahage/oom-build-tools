#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "== Load environment =="
source "$SCRIPT_DIR/oom-env.sh"

echo "== Run Android build =="
"$SCRIPT_DIR/oom-build-android.sh"
