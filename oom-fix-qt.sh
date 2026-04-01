#!/usr/bin/env bash
set -euo pipefail

QT_BASE="/home/yutaro/src/superbuild/build-android/source/qtbase-everywhere-src-5.12.10-1+openorienteering2"
GENERATOR_CPP="$QT_BASE/src/tools/moc/generator.cpp"
XCB_KEYBOARD_CPP="$QT_BASE/src/plugins/platforms/xcb/qxcbkeyboard.cpp"

if [ ! -f "$GENERATOR_CPP" ]; then
  echo "generator.cpp が見つかりません: $GENERATOR_CPP"
  exit 1
fi

if [ ! -f "$XCB_KEYBOARD_CPP" ]; then
  echo "qxcbkeyboard.cpp が見つかりません: $XCB_KEYBOARD_CPP"
  exit 1
fi

echo "== Qt patch: generator.cpp =="

if grep -q '^#include <limits>$' "$GENERATOR_CPP"; then
  echo "  <limits> は既に追加済みです"
else
  python3 <<'PY'
from pathlib import Path

path = Path("/home/yutaro/src/superbuild/build-android/source/qtbase-everywhere-src-5.12.10-1+openorienteering2/src/tools/moc/generator.cpp")
text = path.read_text(encoding="utf-8")

lines = text.splitlines()
for i, line in enumerate(lines):
    if line.startswith("#include "):
        lines.insert(i + 1, "#include <limits>")
        break

path.write_text("\n".join(lines) + "\n", encoding="utf-8")
PY
  echo "  <limits> を追加しました"
fi

echo "== Qt patch: qxcbkeyboard.cpp =="

python3 <<'PY'
from pathlib import Path

path = Path("/home/yutaro/src/superbuild/build-android/source/qtbase-everywhere-src-5.12.10-1+openorienteering2/src/plugins/platforms/xcb/qxcbkeyboard.cpp")
text = path.read_text(encoding="utf-8")

targets = [
    ("XKB_KEY_dead_lowline", "Qt::Key_Dead_Lowline"),
    ("XKB_KEY_dead_aboveverticalline", "Qt::Key_Dead_Aboveverticalline"),
    ("XKB_KEY_dead_belowverticalline", "Qt::Key_Dead_Belowverticalline"),
    ("XKB_KEY_dead_longsolidusoverlay", "Qt::Key_Dead_Longsolidusoverlay"),
]

changed = False

for key, qtkey in targets:
    wrapped = f"""#ifdef {key}
        Xkb2Qt<{key},            {qtkey}>,
        #endif"""
    wrapped_alt = f"""#ifdef {key}
                Xkb2Qt<{key}, {qtkey}>,
        #endif"""
    raw = f"        Xkb2Qt<{key},            {qtkey}>,"
    raw_alt = f"        Xkb2Qt<{key}, {qtkey}>,"
    if f"#ifdef {key}" in text:
        print(f"  {key}: 既に ifdef 済み")
        continue

    if raw in text:
        text = text.replace(raw, f"#ifdef {key}\n{raw}\n        #endif")
        print(f"  {key}: ifdef で囲みました")
        changed = True
    elif raw_alt in text:
        text = text.replace(raw_alt, f"#ifdef {key}\n{raw_alt}\n        #endif")
        print(f"  {key}: ifdef で囲みました")
        changed = True
    else:
        print(f"  {key}: 対象行が見つかりません（既に別形か upstream 差分の可能性）")

if changed:
    path.write_text(text, encoding="utf-8")
PY

echo "Qt patch check complete."
