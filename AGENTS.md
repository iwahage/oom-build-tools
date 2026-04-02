# AGENTS.md for oom-build-tools

## Purpose
This repository contains helper scripts and GitHub Actions workflow files for building OpenOrienteering Mapper Android APKs using:

- Windows
- WSL2 Ubuntu
- self-hosted GitHub Actions runner
- superbuild

## Critical architecture rule
The Android APK is built from the superbuild source tree, not directly from `~/src/mapper`.

Actual build source:

```text
~/src/superbuild/build-android/source/openorienteering-mapper-git-master

Development source:

~/src/mapper

This means build scripts must sync ~/src/mapper into the superbuild source tree before building.

Required Android build order

The Android build must follow this order:

Sync mapper source into superbuild source tree
Build libkml-1.3.0-9-aarch64-linux-android
Run oom-fix-libkml.sh
Build openorienteering-mapper-git-master-aarch64-linux-android-package

If the order changes, libkml export paths may break.

Known fragile point: libkml

libkml export files can become invalid.
The safe pattern is:

build libkml first
patch the release export file
only then build the package target

Do not simplify this flow unless you have re-tested a full Android build.

Main scripts
oom-env.sh
oom-fix-qt.sh
oom-fix-libkml.sh
oom-build-android.sh
oom-run.sh
Build entry point

Normal local entry point:

bash -lc '~/src/oom-build-tools/oom-run.sh'
GitHub Actions behavior

Workflow responsibilities:

run on self-hosted Windows runner
invoke WSL cleanly
build Android APK
sign with debug keystore
upload APK and build log as artifacts
Signing notes

APK artifacts must be signed before installation.
The workflow uses a debug keystore on Windows.

Expected location:

C:\Users\<username>\.android\debug.keystore

Build tools and apksigner.bat are expected under:

%LOCALAPPDATA%\Android\Sdk\build-tools

Java runtime is expected from Android Studio JBR.

What to avoid
Do not assume ~/src/mapper alone controls the APK output
Do not remove the mapper-to-superbuild sync step
Do not modify libkml handling casually
Do not change workflow shell/WSL invocation without testing on the actual self-hosted runner
Helpful checks

Confirm feature exists in build source:

git -C ~/src/superbuild/build-android/source/openorienteering-mapper-git-master grep "Configure mobile toolbars" || true

Confirm feature exists in APK:

strings ~/src/superbuild/build-android/aarch64-linux-android/openorienteering-mapper-git-master/OpenOrienteering-Mapper-git-master-Android-arm64-v8a.apk | grep -F "Configure mobile toolbars" || true
Success criteria

A change is only successful when:

it is present in the actual build source
the APK builds successfully
the APK is signed
the feature can be observed on device
