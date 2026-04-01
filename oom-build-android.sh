#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cd "$HOME/src/superbuild/build-android"
source "$SCRIPT_DIR/oom-env.sh"

echo "== Build libkml first =="
gmake -j1 libkml-1.3.0-9-aarch64-linux-android

echo "== Fix libkml export file =="
"$SCRIPT_DIR/oom-fix-libkml.sh"

echo "== Build OOM Android package =="
gmake -j1 openorienteering-mapper-git-master-aarch64-linux-android-package
