class Overlay {
  Player Player;
  int translate;
  TextInput input ;

  Overlay(Player aPlayer, int aTranslate) {
    Player = aPlayer;
    translate = aTranslate;
    input = new TextInput();
    input.tr[0] = translate;
  }

  void show() {
    push();
    translate(translate, 0);
    
    textFont(overlay, 25);
    input.Draw();    
    if (!input.selected) Player.name = input.Text;

    image(Iinvincibility, 10, 50, 20, 20);
    if (Player.invincibility) {
      float stop = 2*PI - (Player.nbInv * (2*PI/300));
      stroke(125);
      fill(#FFFFFF);
      arc(50, 60, 17, 17, 0, stop, PIE);
    } else {
      noFill();
      stroke(#FF0000);
      ellipse(50, 60, 17, 17);
      line(44, 66, 55, 54);
    }

    image(IfeetBomb, 10, 90, 20, 20);
    if (Player.feetBomb) {
      float stop = 2*PI - (Player.nbFeet * (2*PI/300));
      stroke(125);
      fill(#FFFFFF);
      arc(50, 100, 17, 17, 0, stop, PIE);
    } else {
      noFill();
      stroke(#FF0000);
      ellipse(50, 100, 17, 17);
      line(44, 106, 55, 94);
    }

    for (int k=0; k < Player.nbBomb; k++) {
      if (k < 3) {
        image(Ibombeup, 10 + k*30, 160, 20, 20);
      } else if (k < 6) {
        image(Ibombeup, 10 + (k-3)*30, 185, 20, 20);
      } else {
        image(Ibombeup, 10 + (k-6)*30, 210, 20, 20);
      }
    }

    image(IexpCentre, 10, 280, 20, 20);
    for (int k=0; k < Player.flame; k++) {
      image(Iflame, 10 + k*30, 250, 20, 20);
      switch(k) {
      case 0:
        image(IexpDroite, 30, 280, 20, 20);
        break;
      case 1:
        image(Ihorizontal, 30, 280, 20, 20);
        image(IexpDroite, 50, 280, 20, 20);
        break;
      case 2:
        image(Ihorizontal, 30, 280, 20, 20);
        image(Ihorizontal, 50, 280, 20, 20);
        image(IexpDroite, 70, 280, 20, 20);
        break;
      }
    }
    textFont(overlay, 25);
    text("Score :", 5, 340);
    textFont(win, 25);
    text(Player.score, 40, 370);

    pop();
  }
}
