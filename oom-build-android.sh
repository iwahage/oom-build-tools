#!/usr/bin/env bash
set -euo pipefail

source /home/yutaro/src/scripts/oom-env.sh

cd /home/yutaro/src/superbuild/build-android

cmake --build . \
  --target openorienteering-mapper-git-master-aarch64-linux-android-package \
  -j1 2>&1 | tee /home/yutaro/src/logs/oom-build-$(date +%Y%m%d-%H%M%S).log
