class Tile {
  boolean wall;
  boolean dirt;
  boolean grass;

  boolean bomb;

  boolean expHaut;
  boolean expGauche;
  boolean expCentre;
  boolean expDroite;
  boolean expBas;
  boolean vertical;
  boolean horizontal;

  boolean expl;

  boolean flame;
  boolean invincibility;
  boolean death;
  boolean bombeup;
  boolean bombfeet;

  boolean PUpOff = true;
  boolean clear;

  PVector pos;

  int i;
  int j;

  boolean dangerous = false;
  boolean onGoingDanger = false;
  boolean safe;


  Tile(float x, float y) {
    pos = new PVector(x, y);
    i = (int) pos.x / largeurCase;
    j = (int) pos.y / largeurCase;
  }

  Tile() {}

  void show() {
    if (grass) image(Igrass, pos.x, pos.y, largeurCase, largeurCase); //0
    if (expCentre) image(IexpCentre, pos.x, pos.y, largeurCase, largeurCase); //3
    if (invincibility) image(Iinvincibility, pos.x, pos.y, largeurCase, largeurCase); //6
    if (death) image(Ideath, pos.x, pos.y, largeurCase, largeurCase); //7
    if (bombeup) image(Ibombeup, pos.x, pos.y, largeurCase, largeurCase); //8
    if (flame) image(Iflame, pos.x, pos.y, largeurCase, largeurCase); //9
    if (bombfeet) image(IfeetBomb, pos.x, pos.y, largeurCase, largeurCase);
    if (expBas) image(IexpBas, pos.x, pos.y, largeurCase, largeurCase); //10
    if (expHaut) image(IexpHaut, pos.x, pos.y, largeurCase, largeurCase); //11
    if (expDroite) image(IexpDroite, pos.x, pos.y, largeurCase, largeurCase); //12
    if (expGauche) image(IexpGauche, pos.x, pos.y, largeurCase, largeurCase); //4
    if (vertical) image(Ivertical, pos.x, pos.y, largeurCase, largeurCase); //14
    if (horizontal) image(Ihorizontal, pos.x, pos.y, largeurCase, largeurCase); //15
    if (bomb) image(Ibomb, pos.x + 3, pos.y + 3, largeurCase - 6, largeurCase - 6); //5
    if (dirt) image(Idirt, pos.x, pos.y, largeurCase, largeurCase); //1
    if (wall) image(Iwall, pos.x, pos.y, largeurCase, largeurCase); //2

    expl();
    dangerous = (expl | death | bomb | onGoingDanger) ? true : false;
    safe = ((grass | powerUp()) & !dangerous) ? true : false;
  }

  void rank() {
    switch (map[j][i]) {
      case 0:
        tiles[j][i].grass = true;
        break;
      case 2:
        tiles[j][i].wall = true;
        break;
      case 3:
        tiles[j][i].clear = true;
        tiles[j][i].grass = true;
        break;
    }
  }

  void dirt() {
    if (random(1) > 0.2 && IsDirt && !wall && !clear) {
      dirt = true;
      if (random(10) >= 5 && PowerUp) {
        switch (int(random(5))) {
          case 0:
            flame = true;
            break;
          case 1:
            death = true;
            break;
          case 2:
            bombfeet = true;
            break;
          case 3:
            bombeup = true;
            break;
          case 4:
            invincibility = true;
            break;
        }
      }
    }
  }


  void reset() {
    dirt = false;
    grass = true;
    bomb = false;
    expHaut = false;
    expGauche = false;
    expCentre = false;
    expDroite = false;
    expBas = false;
    vertical = false;
    horizontal = false;
    onGoingDanger = false;
  }

  void resetPowerUp() {
    flame = false;
    invincibility = false;
    death = false;
    bombeup = false;
    bombfeet = false;
  }

  void expl() {
    expl = false;
    if (expHaut || expGauche || expCentre || expDroite || expBas || vertical || horizontal) expl = true;
  }

  boolean powerUp() {
    if (flame || invincibility || bombeup || bombfeet) return true;
    return false;
  }
}