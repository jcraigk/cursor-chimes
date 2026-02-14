# Cursor Chimes

Custom chime sounds for [Cursor](https://cursor.sh). Replace the default "task done" chime with something better.

Inspired by [peon-ping](https://github.com/PeonPing/peon-ping).


### Setup

1. **Disable Cursor's built-in sound** (to avoid double chimes):

Settings → search "completion" → disable "Completion Sound"

2. **Clone this repo** (or download it somewhere permanent):

```bash
git clone https://github.com/jcraigk/cursor-chimes.git ~/cursor-chimes
```

3. **Create the hooks config** at `~/.cursor/hooks.json`:

```json
{
  "hooks": [
    {
      "event": "onAgentStop",
      "command": "bash ~/cursor-chimes/scripts/play-chime.sh"
    }
  ]
}
```

Adjust the path if you cloned elsewhere.

4. **Restart Cursor.** That's it — you'll hear a random chime when the agent finishes.

### Available Hook Events

You can trigger sounds on different events by adding more entries to `hooks.json`:

| Event | When it fires |
|-------|---------------|
| `onAgentStop` | Agent finishes responding |
| `onAgentStart` | Agent starts working |
| `beforeShellExecution` | Before running a shell command |
| `afterFileEdit` | After editing a file |

Example with multiple events (using different sound folders):

```json
{
  "hooks": [
    {
      "event": "onAgentStop",
      "command": "bash ~/cursor-chimes/scripts/play-chime.sh ~/cursor-chimes/sounds"
    },
    {
      "event": "onAgentStart",
      "command": "bash ~/cursor-chimes/scripts/play-chime.sh ~/cursor-chimes/sounds-start"
    }
  ]
}
```

### Customizing

The `play-chime.sh` script picks a random MP3 from the sounds directory each time. To use your own sounds:

Add MP3 files to the `sounds/` folder (keep them under 3 seconds). The script will automatically include them in rotation

You can also point the script at a different directory:
```bash
bash ~/cursor-chimes/scripts/play-chime.sh /path/to/my/sounds
```

---

## Included Sounds

| File | Description | Duration |
|------|-------------|----------|
| `zelda_botw.mp3` | Breath of the Wild chime | ~2.8s |
| `zelda_orb.mp3` | Zelda orb collected | ~3.0s |
| `zelda_puzzle.mp3` | Zelda puzzle solved | ~2.3s |
| `zelda_treasure.mp3` | Zelda treasure chest opened | ~3.0s |

## Adding Your Own Sounds

Drop any MP3 into the `sounds/` folder. Keep them under 3 seconds for best results.

## Platform Support

- **macOS**: Uses `afplay` (built-in)
- **Linux**: Uses `paplay` (PulseAudio), `pw-play` (PipeWire), or `ffplay` (FFmpeg)
- **Windows**: Not yet supported

## License

MIT
