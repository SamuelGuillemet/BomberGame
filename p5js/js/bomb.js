const BLAST_DIRECTIONS = [
  { dx: 0, dy: 1, end: 'expBas', mid: 'vertical' },
  { dx: 0, dy: -1, end: 'expHaut', mid: 'vertical' },
  { dx: -1, dy: 0, end: 'expGauche', mid: 'horizontal' },
  { dx: 1, dy: 0, end: 'expDroite', mid: 'horizontal' },
];

function inGrid(x, y) {
  return x >= 0 && y >= 0 && x < levelMap.length && y < levelMap.length;
}

class Bomb {
  constructor(aPos, aFlame) {
    this.pos = createVector(aPos[1], aPos[0]);
    tiles[this.pos.y][this.pos.x].bomb = true;
    this.time = temp;
    this.off = false;
    this.explode = false;
    this.flame = aFlame;
    this.timeToExplosion = int(difficulty);
    this.TileExp = [];
  }

  explosion() {
    this.generateDanger();
    const center = tiles[this.pos.y][this.pos.x];
    if (center.expl && !this.explode) this.time = temp - this.timeToExplosion;
    if (temp >= this.time + this.timeToExplosion) {
      center.bomb = false;
      if (sounds && !this.explode) Sexpl.play();
      this.drawexplosion();
    }

    if (temp >= this.time + this.timeToExplosion + 500) {
      for (const t of this.TileExp) {
        t.reset();
        t.PUpOff = true;
      }
      this.off = true;
    }
  }

  drawexplosion() {
    for (const d of BLAST_DIRECTIONS) {
      for (let k = 1; k <= this.flame; k++) {
        const X = this.pos.x + d.dx * k;
        const Y = this.pos.y + d.dy * k;
        if (!inGrid(X, Y)) continue;
        const t = tiles[Y][X];
        if (!t.wall) {
          if (t.dirt) t.PUpOff = false;
          if (t.PUpOff) t.resetPowerUp();
          t.reset();
          t[d.mid] = true;
          this.TileExp.push(t);
        }
        if (t.wall || k === this.flame) {
          const a = (k === this.flame && !t.wall) ? 0 : 1;
          const e = tiles[Y - a * d.dy][X - a * d.dx];
          e.reset();
          e[d.end] = true;
          break;
        }
      }
    }
    const c = tiles[this.pos.y][this.pos.x];
    c.reset();
    c.expCentre = true;
    this.TileExp.push(c);
    this.explode = true;
  }

  generateDanger() {
    for (const d of BLAST_DIRECTIONS) {
      for (let k = 1; k <= this.flame; k++) {
        const X = this.pos.x + d.dx * k;
        const Y = this.pos.y + d.dy * k;
        if (!inGrid(X, Y)) continue;
        const t = tiles[Y][X];
        if (!t.wall) t.onGoingDanger = true;
        if (t.wall || k === this.flame) {
          const a = (k === this.flame && !t.wall) ? 0 : 1;
          tiles[Y - a * d.dy][X - a * d.dx].onGoingDanger = true;
          break;
        }
      }
    }
  }
}
