class Overlay {
  constructor(aPlayer, aTranslate) {
    this.player = aPlayer;
    this.translate = aTranslate;
    this.input = new TextInput();
    this.input.tr[0] = aTranslate;
  }

  show() {
    const P = this.player;
    push();
    translate(this.translate, 0);

    textFont(FONT_OVERLAY, 25);
    this.input.Draw();
    if (!this.input.selected) P.name = this.input.Text;

    image(Iinvincibility, 10, 50, 20, 20);
    this.timer(P.invincibility, P.nbInv, 60);

    image(IfeetBomb, 10, 90, 20, 20);
    this.timer(P.feetBomb, P.nbFeet, 100);

    for (let k = 0; k < P.nbBomb; k++) {
      const row = min(floor(k / 3), 2);
      image(Ibombeup, 10 + (k - row * 3) * 30, 160 + row * 25, 20, 20);
    }

    image(IexpCentre, 10, 280, 20, 20);
    for (let k = 0; k < P.flame; k++) {
      image(Iflame, 10 + k * 30, 250, 20, 20);
    }
    for (let k = 0; k < P.flame - 1; k++) image(Ihorizontal, 30 + k * 20, 280, 20, 20);
    if (P.flame > 0) image(IexpDroite, 10 + P.flame * 20, 280, 20, 20);

    textFont(FONT_OVERLAY, 25);
    text('Score :', 5, 340);
    textFont(FONT_WIN, 25);
    text(P.score, 40, 370);

    pop();
  }

  timer(active, count, y) {
    if (active) {
      stroke(125);
      fill('#FFFFFF');
      arc(50, y, 17, 17, 0, TWO_PI - count * (TWO_PI / 300), PIE);
    } else {
      noFill();
      stroke('#FF0000');
      ellipse(50, y, 17, 17);
      line(44, y + 6, 55, y - 6);
    }
  }
}
