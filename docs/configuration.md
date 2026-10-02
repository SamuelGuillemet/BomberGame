# Configuration and assets

## `data/Settings.txt`

Plain `key=value` file, **one setting per line, in a fixed order**. The game reads it by line index
(`split(line, '=')[1]`), so do not reorder, add or remove lines.

| Line | Key | Type | Meaning | Example |
|---|---|---|---|---|
| 1 | `difficulty` | float | Bomb fuse in ms (slider range 1000-2000) | `1550.1896` |
| 2 | `sounds` | boolean | Sound effects on/off | `false` |
| 3 | `music` | boolean | Music on/off | `false` |
| 4 | `showFPS` | boolean | Show frame rate | `false` |
| 5 | `Player1.Color` | float | Helmet hue of player 1 (0-255) | `139.0` |
| 6 | `Player2.Color` | float | Helmet hue of player 2 (0-255) | `146.0` |
| 7 | `Player1.name` | string | Name of player 1 | `Sam` |
| 8 | `Player2.name` | string | Name of player 2 | `Samuel` |
| 9 | `Player1.length` | int | Number of characters in name 1 | `3` |
| 10 | `Player2.length` | int | Number of characters in name 2 | `6` |
| 11 | `IPprefered` | string | Last host IP typed in the join screen | `192.168.1.42` |
| 12 | `IPpreferedLength` | int | Length of that IP string | `12` |

Rules to respect when editing manually:

- `*.length` must equal the real length of the associated text; the text box clears itself if the length is `0`.
- The file is loaded in `settings()` and written by `savePara()` (when pressing Go, the pause button, or Restart).
- Values are not validated: a malformed file raises an exception at start-up.
- Settings are saved to an absolute path (see [limitations.md](limitations.md)), so persistence may not work in an exported app.

## Assets in `data/`

All assets are loaded in `initImg()` ([Init_Images_and_savePara.pde](../Init_Images_and_savePara.pde)).

### Images

| File | Use |
|---|---|
| `blocdur.jpg`, `blocmou.jpg`, `blocGrass.jpg` | Wall, dirt, ground tiles |
| `Bomb1.jpg` | Bomb |
| `ExplCentre.png`, `Haut.png`, `Bas.png`, `Gauche.png`, `Droite.png` | Explosion centre and tips |
| `Horizontal.png`, `Vertical.png` | Explosion body |
| `FlameUp.jpg`, `BombUp.jpg`, `Invincibility.jpg`, `FootBomb.jpg`, `PowerFULL.jpg` | Power-ups |
| `Header.png`, `Menu.png`, `SelectionPersonnageVide.png`, `GameOver.png` | Backgrounds of each screen |
| `Perso.png` | Character sprite (used for both players, helmet drawn on top in code) |

### Fonts

`SWIsop3-42.vlw` (overlay), `ProcessingSansPro-Semibold-25.vlw` (win/UI), `TrebuchetMS-48.vlw` (menu).
These are Processing bitmap fonts created with *Tools > Create Font*.

### Sounds

| File | Use |
|---|---|
| `Death.wav`, `PowerUp.wav`, `BombPos.wav`, `Expl.wav`, `Click.wav` | Sound effects |
| `Music1.wav` ... `Music8.wav` | Background music, picked randomly; volume 0.1 (explosion 0.3) |

The `data/` folder is about 250 MB, mostly because the music is stored as uncompressed WAV.
Converting to OGG/MP3 would shrink the download substantially (the Sound library reads MP3, WAV and AIFF).

## Constants in the code

| Name | File | Default | Meaning |
|---|---|---|---|
| `largeurCase` | [BomberGame.pde](../BomberGame.pde) | 30 | Tile size in pixels |
| `map` | same | 13x13 | Level layout: `0` ground, `2` wall, `3` guaranteed free tile at spawn |
| `IsDirt` | same | `true` | Generate dirt blocks |
| `PowerUp` | same | `true` | Generate power-ups |
| `difficulty` | same | 1500 | Fuse duration in ms |
| network port | [Mooving.pde](../Mooving.pde), [Network.pde](../Network.pde) | 5204 | TCP port |
| frame rate | `setup()` | 30 | All timers expressed in frames assume this |
