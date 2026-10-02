class Tile {
  constructor(x = 0, y = 0) {
    this.wall = false;
    this.dirt = false;
    this.grass = false;

    this.bomb = false;

    this.expHaut = false;
    this.expGauche = false;
    this.expCentre = false;
    this.expDroite = false;
    this.expBas = false;
    this.vertical = false;
    this.horizontal = false;

    this.expl = false;

    this.flame = false;
    this.invincibility = false;
    this.death = false;
    this.bombeup = false;
    this.bombfeet = false;

    this.PUpOff = true;
    this.clear = false;

    this.pos = createVector(x, y);
    this.i = floor(x / largeurCase);
    this.j = floor(y / largeurCase);

    this.dangerous = false;
    this.onGoingDanger = false;
    this.safe = false;
  }

  show() {
    const x = this.pos.x;
    const y = this.pos.y;
    const s = largeurCase;
    if (this.grass) image(Igrass, x, y, s, s);
    if (this.expCentre) image(IexpCentre, x, y, s, s);
    if (this.invincibility) image(Iinvincibility, x, y, s, s);
    if (this.death) image(Ideath, x, y, s, s);
    if (this.bombeup) image(Ibombeup, x, y, s, s);
    if (this.flame) image(Iflame, x, y, s, s);
    if (this.bombfeet) image(IfeetBomb, x, y, s, s);
    if (this.expBas) image(IexpBas, x, y, s, s);
    if (this.expHaut) image(IexpHaut, x, y, s, s);
    if (this.expDroite) image(IexpDroite, x, y, s, s);
    if (this.expGauche) image(IexpGauche, x, y, s, s);
    if (this.vertical) image(Ivertical, x, y, s, s);
    if (this.horizontal) image(Ihorizontal, x, y, s, s);
    if (this.bomb) image(Ibomb, x + 3, y + 3, s - 6, s - 6);
    if (this.dirt) image(Idirt, x, y, s, s);
    if (this.wall) image(Iwall, x, y, s, s);

    this.updateExpl();
    this.dangerous = this.expl || this.death || this.bomb || this.onGoingDanger;
    this.safe = (this.grass || this.powerUp()) && !this.dangerous;
  }

  rank() {
    switch (levelMap[this.j][this.i]) {
      case 0:
        this.grass = true;
        break;
      case 2:
        this.wall = true;
        break;
      case 3:
        this.clear = true;
        this.grass = true;
        break;
    }
  }

  placeDirt() {
    if (random(1) > 0.2 && IsDirt && !this.wall && !this.clear) {
      this.dirt = true;
      if (random(10) >= 5 && PowerUp) {
        switch (int(random(5))) {
          case 0:
            this.flame = true;
            break;
          case 1:
            this.death = true;
            break;
          case 2:
            this.bombfeet = true;
            break;
          case 3:
            this.bombeup = true;
            break;
          case 4:
            this.invincibility = true;
            break;
        }
      }
    }
  }

  reset() {
    this.dirt = false;
    this.grass = true;
    this.bomb = false;
    this.expHaut = false;
    this.expGauche = false;
    this.expCentre = false;
    this.expDroite = false;
    this.expBas = false;
    this.vertical = false;
    this.horizontal = false;
    this.onGoingDanger = false;
  }

  resetPowerUp() {
    this.flame = false;
    this.invincibility = false;
    this.death = false;
    this.bombeup = false;
    this.bombfeet = false;
  }

  updateExpl() {
    this.expl = this.expHaut || this.expGauche || this.expCentre || this.expDroite ||
      this.expBas || this.vertical || this.horizontal;
  }

  powerUp() {
    return this.flame || this.invincibility || this.bombeup || this.bombfeet;
  }
}
