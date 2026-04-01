#!/usr/bin/env bash
set -euo pipefail

echo "== Load environment =="
source "$HOME/src/scripts/oom-env.sh"

echo "== Run Android build =="
"$HOME/src/scripts/oom-build-android.sh"
