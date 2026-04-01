#!/usr/bin/env bash
set -euo pipefail

install_root="$HOME/src/superbuild/build-android/aarch64-linux-android/install"
release_file="$install_root/usr/lib/cmake/libkml/LibKMLTargets-release.cmake"
lib_dir="$install_root/usr/lib"

echo "== Fix libkml release export file =="

if [ ! -f "$release_file" ]; then
  echo "missing: $release_file"
  exit 1
fi

python3 - "$release_file" "$lib_dir" <<'PY'
from pathlib import Path
import re
import sys

release_file = Path(sys.argv[1])
lib_dir = Path(sys.argv[2])

libs = [
    "libkmlbase.so",
    "libkmlconvenience.so",
    "libkmldom.so",
    "libkmlengine.so",
    "libkmlregionator.so",
    "libkmlxsd.so",
]

text = release_file.read_text()

for lib in libs:
    abs_path = str(lib_dir / lib)

    text = re.sub(
        rf'(^\s*IMPORTED_LOCATION_RELEASE\s+)"/usr/lib/{re.escape(lib)}"',
        rf'\1"{abs_path}"',
        text,
        flags=re.M,
    )
    text = re.sub(
        rf'(^\s*list\(APPEND _cmake_import_check_files_for_[A-Za-z0-9_]+ )"/usr/lib/{re.escape(lib)}"( \))',
        rf'\1"{abs_path}"\2',
        text,
        flags=re.M,
    )

release_file.write_text(text)
print(f"patched: {release_file}")
PY

echo
echo "== Verify =="
grep -nE 'IMPORTED_LOCATION_RELEASE|_cmake_import_check_files_for_' "$release_file"
