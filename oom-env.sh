#!/usr/bin/env bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="/home/yutaro/src/superbuild/build-android/default/install/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export GRADLE_OPTS="-Dorg.gradle.internal.http.connectionTimeout=120000 -Dorg.gradle.internal.http.socketTimeout=120000"
export GDAL_DATA_DIR=/home/yutaro/src/superbuild/build-android/aarch64-linux-android/install/usr/share/gdal
