#!/usr/bin/env bash
set -euo pipefail

FILE="/home/yutaro/src/superbuild/build-android/aarch64-linux-android/install/usr/lib/cmake/libkml/LibKMLTargets-release.cmake"
BASE="/home/yutaro/src/superbuild/build-android/aarch64-linux-android/install/usr/lib"

if [ ! -f "$FILE" ]; then
  echo "LibKMLTargets-release.cmake が見つかりません: $FILE"
  exit 1
fi

sed -i "s|/usr/lib/libkmlbase.so|$BASE/libkmlbase.so|g" "$FILE"
sed -i "s|/usr/lib/libkmldom.so|$BASE/libkmldom.so|g" "$FILE"
sed -i "s|/usr/lib/libkmlxsd.so|$BASE/libkmlxsd.so|g" "$FILE"
sed -i "s|/usr/lib/libkmlengine.so|$BASE/libkmlengine.so|g" "$FILE"
sed -i "s|/usr/lib/libkmlconvenience.so|$BASE/libkmlconvenience.so|g" "$FILE"
sed -i "s|/usr/lib/libkmlregionator.so|$BASE/libkmlregionator.so|g" "$FILE"

echo "libkml paths fixed."
