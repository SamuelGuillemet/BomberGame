# Developer setup

## Requirements

| Tool | Version | Notes |
|---|---|---|
| Processing | 4.x (3.5.4+ should work; the code uses `push()` / `pop()`) | Bundles its own JDK, no separate Java needed |
| Library *Sound* | any recent | `processing.sound`: audio playback |
| Library *Network* | built in | `processing.net` |
| Library *Pathfinder* | V1.0.1 | Manual install from SourceForge (`pathfinder4processing`); provides `pathfinder.*` by Peter Lager: `Graph`, `GraphNode`, `GraphSearch_Astar`, `AshCrowFlight` |
| Git | any | to clone |

Optional: VS Code with a Java extension (the workspace has `.vscode/settings.json` with
`java.project.sourcePaths: ["data"]`), but the Processing PDE is the supported way to run the game.

## Get the code

```bash
git clone https://github.com/SamuelGuillemet/BomberGame.git
cd BomberGame
```

The folder must be called `BomberGame` so it matches the main tab `BomberGame.pde`.
The repository is large because of `data/` (about 250 MB).

## Run in the Processing IDE

1. Open Processing, then File > Open > `BomberGame.pde`.
2. Sketch > Import Library > Manage Libraries, install **Sound**. Install **Pathfinder** manually (it is not in the
   Library Manager): download `Path_Finder V1.0.1.zip` from
   [SourceForge](https://sourceforge.net/projects/pathfinder4processing/files/) and unzip it into the sketchbook
   `libraries/` folder (`~/sketchbook/libraries` on Linux, `Documents/Processing/libraries` on Windows/macOS).
3. Press **Run** (or `Ctrl+R`). The 590x420 window opens on the main menu.

## Run from the command line

Install `processing-java` (PDE: Tools > Install "processing-java" on macOS; on Linux/Windows it is in the Processing folder).

```bash
processing-java --sketch="$PWD" --run
```

## Build a standalone app

```bash
./scripts/export.sh
```

See [playable-version.md](playable-version.md).

## Working in a Codespace / dev container

The Processing IDE is a desktop application and needs a display, which a Codespace does not provide.
Edit in VS Code, and run or export on a machine with Processing installed, or use the CI workflow
for exporting.

## Debugging tips

- FPS overlay: pause menu > Show FPS.
- AI path debugging: in [GuideLine.pde](../GuideLine.pde) (case 2 of `menu()`), uncomment the block that calls
  `drawEdges()`, `drawNodes()`, `drawRoute()`.
- Use two instances on the same machine for network tests: host on one, join with `127.0.0.1` on the other.
- To reproduce a map, force `SeedUsed` before `randomSeed()` in `setup()`.

## Common problems

| Symptom | Likely cause / fix |
|---|---|
| `The package "pathfinder" does not exist` | Install the *Pathfinder* library |
| `The package "processing.sound" does not exist` | Install the *Sound* library |
| `Cannot find a file named ...` / images missing | The `data/` folder is incomplete (clone issue) |
| Sketch folder name mismatch dialog | Rename the folder to `BomberGame` |
| `ArrayIndexOutOfBounds` at start | `data/Settings.txt` must have 12 lines of `key=value` |
| No sound on Linux | Check the audio server; the Sound library needs a working output device |
| Pause with `Esc` closes the game | See [limitations.md](limitations.md) |
| Windows firewall prompt in network mode | Allow Java on private networks, port 5204 |

## Code conventions observed in the code base

- Variable and function names are a mix of English and French (`largeurCase`, `expHaut`, `Mooving.pde`).
- 4-space indentation in most files, 2-space in a few (`Player.pde`, `Tile.pde`).
- Each `.pde` file is a tab; Processing concatenates tabs alphabetically after the main one, so order does not matter
  for functions and classes but does matter for field initialisation order of globals.

## Contributing

1. Create a branch, keep changes focused.
2. Run the game in all three modes (1 vs 1, 1 vs IA, host / join) before opening a pull request.
3. Update the matching page of `docs/` when behaviour, controls, settings or the protocol change.
