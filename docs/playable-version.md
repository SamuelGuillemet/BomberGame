# Playable version

Processing Java sketches cannot run in a browser, so "playable" means a standalone desktop application
(Java is bundled in it) or running the sketch from the Processing IDE. Three options, from easiest to most flexible.

## Option 1: download a release build

When a version tag is pushed (`git tag v1.0.0 && git push origin v1.0.0`), the workflow
[.github/workflows/release.yml](../.github/workflows/release.yml) builds the Linux application and attaches
`BomberGame-linux.zip` to the GitHub Release. Players then:

1. Open the repository **Releases** page and download the zip.
2. Unzip it and run `BomberGame-linux/BomberGame` (Linux).

Notes for maintainers:

- The job installs the latest Processing 4, the *Sound* library (v2.4.0 from GitHub) and *Pathfinder* V1.0.1
  (from [SourceForge](https://sourceforge.net/projects/pathfinder4processing/)).
- `Actions` > `Build playable version` > `Run workflow` builds a test artifact without creating a release.
- The same steps were reproduced locally and produced a working `BomberGame-linux.zip` (about 500 MB).
- Windows and macOS builds are not produced by CI; use option 3 on those systems.

## Option 2: run from the Processing IDE

1. Install [Processing 4](https://processing.org/download).
2. Install the *Sound* library (Sketch > Import Library > Manage Libraries) and *Pathfinder*, which is not in the
   Library Manager: download it from [SourceForge](https://sourceforge.net/projects/pathfinder4processing/)
   and unzip it into your sketchbook `libraries/` folder.
3. Open `BomberGame.pde` (the folder must be named `BomberGame`) and press **Run**.

Details and troubleshooting: [dev-setup.md](dev-setup.md).

## Option 3: build the application yourself

```bash
./scripts/export.sh
```

It exports the app for the **current OS** with `processing-java` and writes `dist/BomberGame-<os>.zip`.
Alternative in the IDE: File > Export Application.

## Distribution notes

- The package contains the whole `data/` folder (about 250 MB, mostly uncompressed WAV music), so the zip is large.
  GitHub release assets are limited to 2 GiB each; the repository files themselves must stay below 100 MB each.
- The first run may show a Java or OS security warning for unsigned applications (macOS Gatekeeper, Windows SmartScreen).
- Network play needs TCP port 5204 reachable between machines (firewall, router).
- A browser port lives in [p5js/](../p5js/index.html): serve the folder over HTTP (for example
  `python3 -m http.server` inside `p5js/`) and open it. It supports 1 vs 1 and 1 vs IA on one machine;
  music and network play are not included, and settings are stored in the browser `localStorage`.
