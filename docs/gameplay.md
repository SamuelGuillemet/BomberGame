# Gameplay (functional documentation)

## Goal

Be the last player alive. Each round won gives **1 point**; the score is shown in the side panel and
is kept when you replay from the victory screen.

## Screens

The game is a four-step flow (internal `state` variable, see [architecture.md](architecture.md)).

| # | Screen | What you do |
|---|---|---|
| 0 | Main menu | Choose `1 Vs 1`, `1 Vs IA`, `Host a game`, `Join a game` or `Exit` |
| 1 | Character selection | Click above a character to edit its name, drag the hue slider to choose its helmet colour, click the top-centre button (`Go`) to start |
| 2 | Game | Play. Pause button (top right), time displayed at the top |
| 3 | Victory | Shows the winner. Click the button to go back to the selection screen for a new round |

### Side panels (during the game)

Each player has a panel (left: player 1, right: player 2) showing:

- name (editable on the selection screen only)
- invincibility and bomb-walking timers (pie chart that empties over 10 s, red crossed circle when inactive)
- one bomb icon per available bomb (up to 3 per row)
- flame level (1 to 3 flame icons and the matching explosion preview)
- score

## Game modes

| Mode | Description |
|---|---|
| 1 vs 1 | Two humans on the same keyboard |
| 1 vs IA | Player 1 is human; player 2 is the computer (see [ai.md](ai.md)). Its name is fixed to `IA` |
| Host a game | Starts a TCP server on port 5204 and shows the host IP. The host plays player 1 |
| Join a game | Enter the host IP and your name; you play player 2 (see [network-protocol.md](network-protocol.md)) |

## Controls

| Action | Player 1 | Player 2 |
|---|---|---|
| Up / Left / Down / Right | `Z` / `Q` / `S` / `D` | Arrow keys |
| Place a bomb | `Space` | `0` |
| Pause / resume | `²` or `Esc` | same |

- Keys are bound to the **AZERTY** layout (`Z`, `Q`, `S`, `D` for up, left, down, right) and `²` is the key
  left of `1` on French keyboards. On QWERTY keyboards use the pause button with the mouse.
- Movement is **tile by tile**: one key press moves one tile (no key repeat handling, no acceleration).
- In 1 vs IA only player 1 keys are active.

## The map

- 13x13 tiles of 30 px (board of 390x390 px, drawn at offset 100,30 in the 590x420 window).
- Indestructible walls on the border and on every other row/column intersection (classic Bomberman pattern).
- Destructible **dirt** blocks are generated randomly (80 % chance on each free tile).
- The two spawn corners are always kept clear: player 1 top-left (tile 1,1), player 2 bottom-right (tile 11,11).
- Each dirt block hides a power-up with a 50 % chance. The map is generated from a random seed
  (shared between machines in network mode).

## Bombs and explosions

- A bomb is placed on the player's current tile. A player can have as many bombs on the map as their
  bomb capacity (starts at 1).
- The fuse is the **difficulty** value, between about 1000 and 2000 ms (default 1500 ms). The shorter
  the fuse, the harder the game.
- The blast extends in four directions up to `flame` tiles (1 to 3) and stops at walls. It **passes through**
  dirt blocks (destroying all of them on its path, which reveals the power-ups they hide), destroys power-ups
  that were already visible, and kills any non-invincible player on a burning tile, **including the owner**.
- The explosion is displayed for 500 ms.
- A bomb touched by another explosion explodes immediately (chain reaction).
- Bombs are obstacles for both players unless the *bomb walking* power-up is active.
- Players cannot walk through each other.

## Power-ups

Power-ups are revealed when the dirt block covering them is destroyed, and picked up by walking on them.

| Icon asset | Name | Effect |
|---|---|---|
| `FlameUp.jpg` | Flame up | +1 blast range, maximum 3 |
| `BombUp.jpg` | Bomb up | +1 simultaneous bomb, no maximum |
| `Invincibility.jpg` | Invincibility | Immune to explosions for 10 s |
| `FootBomb.jpg` | Bomb walking | Can walk over bombs for 10 s |
| `PowerFULL.jpg` | Death skull | Kills the player stepping on it. Invincible players destroy it instead |

All timed effects last 300 frames (10 s at 30 FPS) and are reset to defaults at each new round
(1 bomb, flame 1, no effects).

## Pause menu

Open with the pause button (top-right), `²` or `Esc`.

| Option | Effect |
|---|---|
| Show FPS | Displays the frame rate in the top-left corner |
| Music | Enables or disables the 8 background tracks (random order) |
| Sounds | Intended to toggle sound effects (see [limitations.md](limitations.md)) |
| Difficulty slider | Bomb fuse from about 1000 ms (difficult) to 2000 ms (easy) |
| Restart | Saves settings and returns to the main menu |

The pause screen also lists the power-up meanings. In network mode, pause is mirrored on both machines and
the host also sends the chosen difficulty.

## Characters and names

- Names are limited by the width of the text box; only characters with codes 32 to 122 are accepted
  (no accents).
- The helmet colour is chosen with a hue slider (0-255, HSB colour mode).
- Names, colours and preferred IP are saved to [`data/Settings.txt`](configuration.md).
