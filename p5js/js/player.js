class Player {
  constructor(aImg) {
    this.pos = createVector(0, 0);
    this.bombs = [];

    this.flame = 1;
    this.nbBomb = 1;
    this.invincibility = false;
    this.feetBomb = false;
    this.nbInv = 0;
    this.nbFeet = 0;

    this.img = aImg;
    this.dead = false;
    this.score = 0;

    this.Color = 0;
    this.ColorBis = 255;

    this.name = '';
  }

  show() {
    if (this.invincibility) {
      noStroke();
      fill(hexA('#44ABFF', 200));
      ellipse(this.pos.x + 15, this.pos.y + 17, 20, 20);
    }

    image(this.img, this.pos.x, this.pos.y);
    this.casque(this.Color, this.pos.x, this.pos.y);

    if (this.feetBomb) {
      stroke(0);
      fill('#CE6829');
      ellipse(this.pos.x + 20, this.pos.y + 28, 8, 8);
    }

    this.updateBombs();
    this.takePowerUp();
    this.IsDead();
  }

  move(dx, dy) {
    const target = createVector(this.pos.x + dx, this.pos.y + dy);
    if (this.collision(this.PixelToCase(target))) return;
    this.pos.add(dx, dy);
  }

  PixelToCase(v) {
    return [round((v.y - 15) / largeurCase), round((v.x - 15) / largeurCase)];
  }

  collision([i, j]) {
    const t = tiles[i][j];
    if (t.wall || t.dirt) return true;
    if (t.bomb && !this.feetBomb) return true;
    for (const p of PlayerPool) {
      const pp = p.getPosition();
      if (pp[0] === i && pp[1] === j) return true;
    }
    return false;
  }

  getPosition() {
    return this.PixelToCase(this.pos);
  }

  PosBomb() {
    if (this.bombs.length < this.nbBomb) {
      this.bombs.push(new Bomb(this.getPosition(), this.flame));
      if (sounds) SbombPos.play();
    }
  }

  updateBombs() {
    for (let i = 0; i < this.bombs.length; i++) {
      this.bombs[i].explosion();
      if (this.bombs[i].off) this.bombs.splice(i, 1);
    }
  }

  IsDead() {
    if (this.invincibility) return;
    const [Y, X] = this.PixelToCase(this.pos);
    const t = tiles[Y][X];
    if (t.death || t.wall || t.expl) {
      if (sounds) Sdeath.play();
      this.dead = true;
    } else {
      this.dead = false;
    }
  }

  takePowerUp() {
    const [Y, X] = this.PixelToCase(this.pos);
    const t = tiles[Y][X];

    if (t.flame) {
      t.flame = false;
      if (sounds) SpowerUp.play();
      this.flame = min(this.flame + 1, 3);
    }

    if (t.bombeup) {
      t.bombeup = false;
      if (sounds) SpowerUp.play();
      this.nbBomb++;
    }

    if (t.invincibility) {
      t.invincibility = false;
      if (sounds) SpowerUp.play();
      this.invincibility = true;
      this.nbInv = 0;
    }

    if (t.bombfeet) {
      t.bombfeet = false;
      if (sounds) SpowerUp.play();
      this.feetBomb = true;
      this.nbFeet = 0;
    }

    if (t.death && this.invincibility) {
      t.death = false;
      this.invincibility = false;
    }

    if (this.invincibility) {
      this.nbInv++;
      if (this.nbInv > 300) {
        this.invincibility = false;
        this.nbInv = 0;
      }
    }

    if (this.feetBomb) {
      this.nbFeet++;
      if (this.nbFeet > 300) {
        this.feetBomb = false;
        this.nbFeet = 0;
      }
    }
  }

  casque(aColor, x, y) {
    push();
    translate(x + 5, y);

    strokeCap(PROJECT);
    rectMode(CORNERS);
    fill(aColor, this.ColorBis, 255);
    stroke(aColor, this.ColorBis, 255);

    rect(7, 5, 12, 5);
    rect(5, 6, 14, 7);
    rect(4, 7, 4, 13);
    rect(15, 7, 15, 13);
    rect(9, 17, 10, 19);
    point(8, 19);
    point(8, 20);
    point(11, 19);
    point(11, 20);
    point(5, 8);
    point(5, 14);
    point(14, 8);
    point(14, 14);

    pop();
  }

  init(aX, aY) {
    this.pos = createVector(aX, aY);

    this.invincibility = false;
    this.feetBomb = false;
    this.nbInv = 0;
    this.nbFeet = 0;

    this.flame = 1;
    this.nbBomb = 1;

    this.bombs = [];
    this.dead = false;
  }
}
