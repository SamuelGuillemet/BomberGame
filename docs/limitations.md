# Limitations, known issues and improvement ideas

Findings come from reading the source. Items marked **(to verify)** were not reproduced at runtime.

## Known bugs

| # | Area | Issue | Where |
|---|---|---|---|
| 1 | Pause | `Esc` quits the application: Processing's default `Esc` handler is not disabled (`key = 0` is never set in `keyPressed()`), so only `²` or the pause button are safe | [Mooving.pde](../Mooving.pde) |
| 2 | Options | The **Sounds** checkbox does nothing: the click handler executes `sounds = sounds;` instead of `sounds = !sounds;` | [Menu_Pause.pde](../Menu_Pause.pde) |
| 3 | Persistence | `savePara()` writes to the absolute path `/data/Settings.txt` instead of the sketch `data/` folder, so settings may not be saved (and cannot be in an exported app) **(to verify)** | [Init_Images_and_savePara.pde](../Init_Images_and_savePara.pde) |
| 4 | Rules | If both players die in the same frame, `PlayerPool` is empty, `state` never reaches 3 and the game stays on an empty board | [GuideLine.pde](../GuideLine.pde) |
| 5 | AI | Dirt edge cost is overwritten (`if (dirt) cost = 10; if (powerUp) cost = 1; else cost = 5;`), so dirt is never more expensive to cross | [PathFinding_Stuff.pde](../PathFinding_Stuff.pde) |
| 6 | Strings | Text is compared with `==` / `!=` (`Player1.name == ""`, `Text != ""`, `clientName != ""`) which compares references in Java; use `.equals()` | several |
| 7 | Network | In `network_Waiting()` the branch `Client client = server.available()` runs for the **client** (`waitingClient`, `state != 0`) where `server` is `null`, and the host has no equivalent read loop; host-to-client or client-to-host input forwarding likely needs review **(to verify)** | [Network.pde](../Network.pde) |
| 8 | UI | The clock shows `m: s` without zero padding (`1: 5`) | [BomberGame.pde](../BomberGame.pde) |
| 9 | UI | The victory message is in French while the rest of the UI is in English | [GuideLine.pde](../GuideLine.pde) |
| 10 | UI | The selection screen calls `loadImage("Perso.png")` on every frame in network mode | [GuideLine.pde](../GuideLine.pde) |

## Functional limitations

- Two players only; no bots beyond the single AI, no spectator.
- One map, 13x13, hard-coded in the source (`map` array).
- Keyboard: AZERTY layout and `²` key assumed; controls are not configurable.
- One tile per key press, no key repeat, no smooth animation.
- No rounds limit or match score target: the score only counts rounds won in the current session and is not saved.
- No game-over for a draw; no sudden death.
- Names are restricted to ASCII codes 32-122 and to the width of the field.
- Both characters use the same sprite, only the helmet hue differs.
- Fixed window size (590x420), no scaling or full screen.
- The AI has a single level and never learns the difficulty slider (only the fuse timing changes).

## Technical limitations

- **Network**: no authority, no resynchronisation, no encryption or authentication, text protocol
  breakable by `-` in names, blocking `delay()` calls in the UI thread, port 5204 hard-coded, no discovery
  (the IP must be typed). See [network-protocol.md](network-protocol.md).
- **Timing**: timers are in frames (power-ups) or ms (bombs); if the frame rate drops below 30 FPS,
  power-ups last longer in real time. Pausing relies on `millis()` bookkeeping.
- **Assets**: reloaded completely on every restart (`settings()` is called again), 250 MB of data,
  uncompressed WAV music, no loading screen.
- **Code**: heavy use of globals, four copy-pasted direction loops in `Bomb`, mixed French and English naming,
  inconsistent indentation, no automated tests, no CI before the release workflow of this repository.
- **Platform**: Processing Java mode: desktop only, no web or mobile build. The Pathfinder library must be
  installed manually.
- **Settings file**: fixed-order parsing without validation; editing it incorrectly crashes the game at start-up.

## Ideas for improvement

1. Fix bugs 1 to 6 (small, local changes).
2. Move the music to OGG/MP3 and load it lazily to cut the repository and download size.
3. Introduce small classes (`Game`, `Grid`, `Input`, `NetSession`) and pass dependencies instead of using globals;
   replace tile boolean flags by an enum plus overlay flags.
4. Factor the four blast directions into a single method with a direction vector.
5. Authoritative host for network mode (client sends inputs, host broadcasts state), binary or JSON messages,
   explicit versioning.
6. Configurable key bindings, QWERTY preset, gamepad support.
7. More levels loaded from text files, rounds to win, draws handled, sudden death.
8. Smarter AI: check an escape path before placing a bomb, seek power-ups, difficulty levels.
9. Web version by porting to p5.js, for instant play from GitHub Pages.
10. Windows and macOS builds in CI, code signing, automatic release notes.
