# BomberGame

A local-multiplayer Bomberman-style game written in [Processing](https://processing.org) (Java mode).
Two players (or one player against an A* powered AI) fight on a 13x13 grid: place bombs, destroy
dirt blocks, collect power-ups and be the last one standing.

- Modes: 1 vs 1 (same keyboard), 1 vs AI, network (host / join over TCP)
- Window: 590x420 px, 30 FPS
- UI language: English (the victory message is in French)

## Documentation

| Document | Audience | Content |
|---|---|---|
| [docs/playable-version.md](docs/playable-version.md) | Players | How to get and run a playable build |
| [docs/gameplay.md](docs/gameplay.md) | Players / designers | Rules, controls, power-ups, menus, game modes |
| [docs/configuration.md](docs/configuration.md) | Players / devs | `Settings.txt` format, constants, assets |
| [docs/dev-setup.md](docs/dev-setup.md) | Developers | Install, run, export, troubleshoot |
| [docs/architecture.md](docs/architecture.md) | Developers | File map, classes, game loop, state machine, algorithms |
| [docs/network-protocol.md](docs/network-protocol.md) | Developers | TCP message format and message catalogue |
| [docs/ai.md](docs/ai.md) | Developers | AI behaviour and path finding |
| [docs/limitations.md](docs/limitations.md) | Everyone | Known bugs, limitations, improvement ideas |

## Quick start

1. Easiest: download a build from the repository **Releases** page (see
   [docs/playable-version.md](docs/playable-version.md)).
2. From source: install Processing 4 and the *Pathfinder* library, open `BomberGame.pde`, press Run
   (see [docs/dev-setup.md](docs/dev-setup.md)).
3. Build the playable apps yourself: `./scripts/export.sh` (needs `processing-java` in `PATH`).
4. Browser version (p5.js, local play only, no music): `cd p5js && python3 -m http.server`, then open
   http://localhost:8000.

## Controls (summary)

| Action | Player 1 | Player 2 |
|---|---|---|
| Move | `Z` `Q` `S` `D` (AZERTY layout) | Arrow keys |
| Bomb | `Space` | `0` |
| Pause | `²` or `Esc` | same |

## Repository layout

```
BomberGame.pde                 entry point: globals, map, settings(), setup(), draw()
GuideLine.pde                  menu(): drives the 4 screens (menu, selection, game, win)
Player.pde, Bomb.pde, Tile.pde, Overlay.pde   game entities
IA_Boi.pde, PathFinding_Stuff.pde             AI and A* graph
Network.pde                    host / join screens and message decoding
Mooving.pde                    keyboard and mouse input
Menu_Pause.pde                 pause screen and options
TextInput_and_DrawSlider.pde   UI widgets
Init_Images_and_savePara.pde   asset loading, settings saving
data/                          images, fonts, sounds, Settings.txt (about 250 MB, mostly music)
docs/                          documentation
p5js/                          browser port (p5.js): index.html, js/, assets/
scripts/export.sh              local build of the playable apps
.github/workflows/release.yml  CI build and release of the playable apps
```

## License

No license file is present in the repository; all rights remain with the author.
