class Player {
  PVector pos;

  ArrayList<Bomb> bomb = new ArrayList<Bomb>();

  int flame;
  int nbBomb;
  boolean invincibility = false;
  boolean feetBomb = false;
  int nbInv = 0;
  int nbFeet = 0;

  PImage img;
  boolean dead = false;
  int score = 0;

  float Color;
  float ColorBis = 255;

  String name = "";

  Player(PImage aImg) {
    img = aImg;
  }

  void show() {
    if (invincibility) {
      noStroke();
      fill(#44ABFF, 200);
      ellipse(pos.x+15, pos.y+17, 20, 20);
    }

    image(img, pos.x, pos.y);
    casque(Color, pos.x, pos.y);

    if (feetBomb) {
      stroke(0);
      fill(#CE6829);
      ellipse(pos.x + 20, pos.y + 28, 8, 8);
    }

    bomb();
    takePowerUp();
    IsDead();
  }

  void move(PVector dep) {
    PVector postest = pos.copy();
    if (collision(PixelToCase(postest.add(dep)))) return;
    pos.add(dep);
  }


  int[] PixelToCase(PVector test) {
    int[] Case = {round((test.y-15)/largeurCase), round((test.x-15)/largeurCase)};
    return Case;
  }

  boolean collision(int Case[]) {
    int i = Case[0];
    int j = Case[1];
    if (tiles[i][j].wall || tiles[i][j].dirt) return true;
    if (tiles[i][j].bomb && !feetBomb) return true;
    for (int k =0; k<PlayerPool.size(); k++) {
      if (PlayerPool.get(k).getPosition()[0] == Case[0] && PlayerPool.get(k).getPosition()[1] == Case[1]) return true;
    }
    return false;
  }

  int[] getPosition() {
    int[] position = {PixelToCase(pos)[0], PixelToCase(pos)[1]};
    return position;
  }

  void PosBomb() {
    if (bomb.size() < nbBomb) {
      bomb.add(new Bomb(getPosition(), flame));
      if (sounds) SbombPos.play();
    }
  }

  void bomb() {
    for (int i = 0; i <bomb.size(); i++) {
      bomb.get(i).explosion();
      if (bomb.get(i).off) bomb.remove(i);
    }
  }

  void IsDead() {
    if (invincibility) return;
    int X = PixelToCase(pos)[1];
    int Y = PixelToCase(pos)[0];

    if (tiles[Y][X].death || tiles[Y][X].wall || tiles[Y][X].expl) {
      if (sounds) Sdeath.play();
      dead = true;
    } else {
      dead = false;
    }
  }

  void takePowerUp() {
    int X = PixelToCase(pos)[1];
    int Y = PixelToCase(pos)[0];

    if (tiles[Y][X].flame) {
      tiles[Y][X].flame = false;
      if (sounds) SpowerUp.play();
      flame++;
      if (flame >= 3) flame = 3;
    }

    if (tiles[Y][X].bombeup) {
      tiles[Y][X].bombeup = false;
      if (sounds) SpowerUp.play();
      nbBomb++;
    }

    if (tiles[Y][X].invincibility) {
      tiles[Y][X].invincibility = false;
      if (sounds) SpowerUp.play();
      invincibility = true;
      nbInv = 0;
    }

    if (tiles[Y][X].bombfeet) {
      tiles[Y][X].bombfeet = false;
      if (sounds) SpowerUp.play();
      feetBomb = true;
      nbFeet = 0;
    }

    if (tiles[Y][X].death) {

      if (invincibility) {
        tiles[Y][X].death = false;
        invincibility = false;
      }
    }

    if (invincibility) {
      nbInv++;
      if (nbInv > 300) {
        invincibility = false;
        nbInv = 0;
      }
    }

    if (feetBomb) {
      nbFeet++;
      if (nbFeet > 300) {
        feetBomb = false;
        nbFeet = 0;
      }
    }
  }

  void casque(float aColor, float x, float y) {
    push();
    translate(x + 5, y);

    strokeCap(PROJECT);
    rectMode(CORNERS);
    fill(aColor, ColorBis, 255);
    stroke(aColor, ColorBis, 255);

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

  void init(float aX, float aY) {
    pos = new PVector(aX, aY);

    invincibility = false;
    feetBomb = false;
    nbInv = 0;
    nbFeet = 0;

    flame = 1;
    nbBomb = 1;

    bomb.clear();
    dead = false;
  }
}
