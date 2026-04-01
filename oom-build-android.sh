#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/src/superbuild/build-android"
source "$HOME/src/scripts/oom-env.sh"

echo "== Build libkml first =="
gmake -j1 libkml-1.3.0-9-aarch64-linux-android

echo "== Fix libkml export files =="
"$HOME/src/scripts/oom-fix-libkml.sh"

echo "== Build OOM Android package =="
gmake -j1 openorienteering-mapper-git-master-aarch64-linux-android-package
