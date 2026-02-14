#!/bin/bash
# Plays a random chime sound from the sounds directory.
# Used as a Cursor hook to play sounds on task completion.
#
# Usage: ./scripts/play-chime.sh [sounds_dir]
#
# sounds_dir: path to folder containing MP3s (default: ../sounds relative to script)

# Determine sounds directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOUNDS_DIR="${1:-$SCRIPT_DIR/../sounds}"

# Exit silently if sounds directory doesn't exist
[ ! -d "$SOUNDS_DIR" ] && exit 0

# Find all MP3 files
shopt -s nullglob
mp3_files=("$SOUNDS_DIR"/*.mp3)
shopt -u nullglob

# Exit silently if no MP3s found
[ ${#mp3_files[@]} -eq 0 ] && exit 0

# Pick a random sound
random_index=$((RANDOM % ${#mp3_files[@]}))
selected_sound="${mp3_files[$random_index]}"

# Play the sound in background, fully detached, all output silenced
if command -v afplay &>/dev/null; then
  (afplay "$selected_sound" &>/dev/null &)
elif command -v paplay &>/dev/null; then
  (paplay "$selected_sound" &>/dev/null &)
elif command -v pw-play &>/dev/null; then
  (pw-play "$selected_sound" &>/dev/null &)
elif command -v ffplay &>/dev/null; then
  (ffplay -nodisp -autoexit "$selected_sound" &>/dev/null &)
fi

exit 0
