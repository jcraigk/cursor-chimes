#!/bin/bash
# Installs custom chime sounds into Cursor (macOS only).
# Usage: ./scripts/cursor-chimes-install.sh [sounds_dir]
#
# sounds_dir: path to folder containing MP3s (default: ./sounds)
#
# Run after each Cursor update, then restart Cursor.

set -euo pipefail

SOUNDS_DIR="${1:-$(cd "$(dirname "$0")/../sounds" && pwd)}"
MEDIA_DIR="/Applications/Cursor.app/Contents/Resources/app/out/vs/platform/accessibilitySignal/browser/media"
JS_FILE="/Applications/Cursor.app/Contents/Resources/app/out/vs/workbench/workbench.desktop.main.js"

if [ ! -d "$MEDIA_DIR" ]; then
  echo "Error: Cursor media directory not found. Is Cursor installed?"
  exit 1
fi

if [ ! -f "$JS_FILE" ]; then
  echo "Error: Cursor JS file not found."
  exit 1
fi

mp3_files=("$SOUNDS_DIR"/*.mp3)
if [ ${#mp3_files[@]} -eq 0 ]; then
  echo "Error: No MP3 files found in $SOUNDS_DIR"
  exit 1
fi

if grep -q 'zchime1' "$JS_FILE" 2>/dev/null; then
  echo "Patch already applied, nothing to do."
  exit 0
fi

echo "Found ${#mp3_files[@]} sound(s) in $SOUNDS_DIR"

# Copy MP3s as zchime1.mp3, zchime2.mp3, etc.
i=1
registrations=""
sound_refs=""
for f in "${mp3_files[@]}"; do
  dest="$MEDIA_DIR/zchime${i}.mp3"
  cp "$f" "$dest"
  echo "  Copied $(basename "$f") -> zchime${i}.mp3"
  registrations="${registrations};this.zchime${i}=RB.register({fileName:\"zchime${i}.mp3\"})"
  if [ -n "$sound_refs" ]; then
    sound_refs="${sound_refs},"
  fi
  sound_refs="${sound_refs}vk.zchime${i}"
  i=$((i + 1))
done

count=$((i - 1))

echo "Backing up JS..."
cp "$JS_FILE" "$JS_FILE.bak"

echo "Patching JS..."

# Register custom sound files
sed -i '' "s/this\.done1=RB\.register({fileName:\"done1\.mp3\"})/this.done1=RB.register({fileName:\"done1.mp3\"})${registrations}/" "$JS_FILE"

# Replace chime playSound calls with random selection
sed -i '' "s/this\.accessibilitySignalService\.playSound(vk\.done1,\!0,/this.accessibilitySignalService.playSound([${sound_refs}][Math.floor(Math.random()*${count})],!0,/g" "$JS_FILE"

if grep -q 'zchime1' "$JS_FILE"; then
  echo "Done! Restart Cursor to hear your custom chimes."
else
  echo "Patch failed. Restoring backup..."
  cp "$JS_FILE.bak" "$JS_FILE"
  exit 1
fi
