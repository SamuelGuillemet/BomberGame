class PlayerIA {
  constructor(aPlayer) {
    this.player = aPlayer;
    this.nextTile = [0, 0];
    this.currentTile = [0, 0];
    this.ready = false;
    this.c = 5;
    this.mode = 1; // 1 attack, 2 defence
  }

  show() {
    const r = rNodes;
    if (r.length > 1) this.nextTile = [r[1].col, r[1].row];
    const p = this.player.getPosition();
    this.currentTile = [p[1], p[0]];

    if (!this.ready) {
      this.c--;
      if (this.c <= 0) this.ready = true;
    } else {
      this.move();
      this.c = 3;
      this.ready = false;
    }
    this.mode = tiles[this.currentTile[1]][this.currentTile[0]].dangerous ? 2 : 1;
  }

  step() {
    const [nx, ny] = this.nextTile;
    const [cx, cy] = this.currentTile;
    if (nx - cx === 1) Player2.move(largeurCase, 0);
    if (nx - cx === -1) Player2.move(-largeurCase, 0);
    if (ny - cy === 1) Player2.move(0, largeurCase);
    if (ny - cy === -1) Player2.move(0, -largeurCase);
  }

  move() {
    const next = () => tiles[this.nextTile[1]][this.nextTile[0]];
    switch (this.mode) {
      case 1: {
        startNode = getNodeAt(Player2.pos.x + 15, Player2.pos.y + 15, 10);
        endNode = getNodeAt(Player1.pos.x + 15, Player1.pos.y + 15, 10);
        usePathFinder();

        const p1 = Player1.getPosition();
        const t = next();
        if (t.dirt || t.death || (this.nextTile[1] === p1[0] && this.nextTile[0] === p1[1])) {
          Player2.PosBomb();
        } else if (t.safe) {
          this.step();
        } else if (t.expl || t.onGoingDanger) {
          this.findPUp(this.currentTile);
        }
        break;
      }
      case 2:
        this.searchSafePlace(this.currentTile);
        if (!next().death) this.step();
        break;
    }
  }

  searchSafePlace([X, Y]) {
    let TileTest = [tiles[Y][X]];
    let safeTile = null;
    const p1 = Player1.getPosition();
    const walkable = (x, y) => {
      const t = tiles[y][x];
      return !t.expl && !t.death && !t.bomb && !t.wall && !t.dirt && !(y === p1[0] && x === p1[1]);
    };

    for (let nb = 0; nb < 10 && !safeTile; nb++) {
      const TileTestBis = [];
      for (const t of TileTest) {
        const aX = t.i;
        const aY = t.j;
        if (tiles[aY][aX].safe) {
          safeTile = tiles[aY][aX];
          break;
        }
        if (walkable(aX + 1, aY)) TileTestBis.push(tiles[aY][aX + 1]);
        if (walkable(aX - 1, aY)) TileTestBis.push(tiles[aY][aX - 1]);
        if (walkable(aX, aY + 1)) TileTestBis.push(tiles[aY + 1][aX]);
        if (walkable(aX, aY - 1)) TileTestBis.push(tiles[aY - 1][aX]);
      }
      TileTest = TileTestBis;
    }

    startNode = getNodeAt(Player2.pos.x + 15, Player2.pos.y + 15, 5);
    if (safeTile) {
      endNode = getNodeAt(safeTile.i * largeurCase + 15, safeTile.j * largeurCase + 15, 5);
      usePathFinder();
    }
  }

  findPUp([X, Y]) {
    for (let x = -1; x <= 1; x++) {
      for (let y = -1; y <= 1; y++) {
        if (x === 0 || y === 0) {
          const t = tiles[Y + y][X + x];
          if (t.safe && t.powerUp()) Player2.move(x * largeurCase, y * largeurCase);
        }
      }
    }
  }
}
