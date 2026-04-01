#!/usr/bin/env bash
set -euo pipefail

echo "== Load environment =="
source /home/yutaro/src/scripts/oom-env.sh

echo "== Reapply Qt fixes =="
/home/yutaro/src/scripts/oom-fix-qt.sh || true

echo "== Reapply libkml fixes =="
/home/yutaro/src/scripts/oom-fix-libkml.sh || true

echo "== Build Android package =="
/home/yutaro/src/scripts/oom-build-android.sh
