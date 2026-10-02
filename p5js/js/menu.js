let restartAngle = 0;
let sliderPos = 0;

function menu() {
  image(Iheader, -100, -30);

  if (state !== 0) {
    oPlayer1.show();
    oPlayer2.show();

    push();
    textAlign(CENTER);
    fill(255);
    textFont(FONT_OVERLAY, 25);
    text(MsConversion(int(temp)), 195, -5);
    pop();
  }

  switch (state) {
    case 0:
      image(IenterMenu, -100, -30);
      image(Iheader, -100, 360);

      push();
      textAlign(CENTER);
      fill('#737373');
      textFont(FONT_MENU, 30);
      text('Play :', 195, 210);

      fill('#FFC300');
      textSize(22);
      text('1 Vs 1', 195, 250);
      text('1 Vs IA', 195, 280);
      pop();

      if (!paused) {
        if (IsPressed(168, 209, 235, 251)) {
          state++;
        }
        if (IsPressed(166, 224, 260, 276)) {
          IAPlaying = true;
          oPlayer2.input.Text = 'IA';
          oPlayer2.input.TextLength = 2;
          Player2.Color = 0;
          Player2.ColorBis = 0;
          state++;
        }
      }
      break;

    case 1:
      fill(Player1.Color, 255, 255);
      rect(38, 110, 130, 165);
      fill(Player2.Color, Player2.ColorBis, 255);
      rect(232, 110, 130, 165);

      image(IselectPerso, 0, 0);

      Player1.Color = drawSlider(25, 287, 150, 30, Player1.Color, true);
      if (!IAPlaying) Player2.Color = drawSlider(215, 287, 150, 30, Player2.Color, true);

      fill(255);
      textFont(FONT_OVERLAY, 28);
      textAlign(CENTER);
      text(Player1.name, 100, 90);
      text(Player2.name, 290, 90);
      textAlign(LEFT);

      if (IsPressed(160, 227, 19, 61) && !paused) {
        savePara();
        oPlayer1.input.selected = false;
        oPlayer2.input.selected = false;

        if (Player1.name === '' && oPlayer1.input.TextLength === 0) {
          oPlayer1.input.Text = 'Player 1';
          oPlayer1.input.TextLength = oPlayer1.input.Text.length;
        }
        if (Player2.name === '' && oPlayer2.input.TextLength === 0) {
          oPlayer2.input.Text = 'Player 2';
          oPlayer2.input.TextLength = oPlayer2.input.Text.length;
        }
        state++;
      }
      break;

    case 2:
      for (const t of TilePool) t.show();
      for (let i = 0; i < PlayerPool.length; i++) {
        PlayerPool[i].show();
        if (PlayerPool[i].dead) PlayerPool.splice(i, 1);
      }

      if (PlayerPool.length === 1) {
        PlayerPool[0].score += 1;
        state++;
      }

      if (IAPlaying && !paused) IA.show();
      break;

    case 3:
      image(Iwin, 0, 0);

      push();
      fill('#FFB138');
      textFont(FONT_WIN, 25);
      textAlign(CENTER);
      text(PlayerPool[0].name + ' gagne le match !', 195, 225);
      pop();

      if (IsPressed(131, 262, 314, 344)) {
        newGame();
        state = 1;
      }
      break;
  }

  Pause();

  if (showFPS) {
    push();
    fill(255);
    translate(-100, -30);
    textFont(FONT_MENU, 15);
    text(int(frameRate()), 5, 20);
    pop();
  }

  push(); // Pause button
  translate(460, -28);
  ellipseMode(CORNER);
  fill('#808080');
  stroke(0);
  strokeWeight(1);
  ellipse(0, 0, 25, 25);

  noStroke();
  fill('#FFB83F');
  rect(7, 4, 4, 17);
  rect(15, 4, 4, 17);

  if (IsPressed(460, 485, -28, -3)) {
    savePara();
    paused = !paused;
  }
  pop();
}

function drawCheckbox(checked, tickColor) {
  strokeWeight(3);
  stroke(0);
  rect(0, 0, 20, 20);
  if (checked) {
    fill(tickColor);
    stroke(tickColor);
    strokeWeight(1.5);
    beginShape();
    vertex(2, 7);
    vertex(3, 7);
    vertex(8, 12);
    vertex(18, 2);
    vertex(19, 2);
    vertex(19, 6);
    vertex(9, 16);
    vertex(7, 16);
    vertex(2, 11);
    endShape(CLOSE);
  }
}

// Returns the new value of a pause-menu checkbox drawn at the current origin.
function pauseCheckbox(label, value, rawX, rawY) {
  fill(255);
  textFont(FONT_WIN, 20);
  text(label, -8 - textWidth(label), 17);
  const bX = mouseX - rawX;
  const bY = mouseY - rawY;
  if (bX > 0 && bX < 20 && bY > 0 && bY < 20) {
    fill('#A5A5A5');
    if (clicked) {
      if (sounds) Sclick.play();
      value = !value;
    }
  } else {
    fill('#CECECE');
  }
  drawCheckbox(value, '#B60000');
  return value;
}

function Pause() {
  if (!paused) return;
  timePaused = millis() - temp;
  // p5's WebGL-backed filter() resets the transform, so keep it isolated.
  push();
  filter(BLUR, 2);
  pop();

  push(); // Tile description
  translate(-100, -30);
  noStroke();
  fill(hexA('#606060', 230));
  rect(10, 5, 570, 407, 10);
  textAlign(CENTER);
  textFont(FONT_OVERLAY, 35);
  fill('#699B68');
  text('Game paused.', 295, 70);
  textAlign(LEFT);
  fill(255);
  textSize(18);
  image(IfeetBomb, 30, 210);
  text('You can walk over bombs for 10 sec.', 70, 231);
  image(Iinvincibility, 30, 250);
  text('You are invincible for 10 sec.', 70, 271);
  image(Ideath, 30, 290);
  text('You will die if you walk on it.', 70, 311);
  image(Ibombeup, 30, 330);
  text('You can place more than 1 bomb at time.', 70, 351);
  image(Iflame, 30, 370);
  text('Your explosions are going farther.', 70, 391);
  pop();

  push(); // Restart
  translate(455, 360);
  fill('#A8101A');
  text('Restart', -25 - textWidth('Restart'), 12);
  if (restart) {
    rotate(restartAngle);
    restartAngle += 0.15;
    if (restartAngle >= 1.9) {
      restart = false;
      restartAngle = 0;
    }
  }
  noFill();
  strokeWeight(3);
  stroke('#A8101A');
  arc(0, 0, 25, 25, -HALF_PI, PI);
  beginShape();
  vertex(-12, -3);
  vertex(-8, 1);
  vertex(-8, 2);
  vertex(-9, 2);
  vertex(-11, 0);
  vertex(-14, 0);
  vertex(-16, 2);
  vertex(-17, 2);
  vertex(-17, 1);
  vertex(-13, -3);
  endShape();
  const aX = mouseX - 555;
  const aY = mouseY - 390;
  pop();
  if (aX > -20 && aX < 28 && aY > -13 && aY < 13) {
    restart = true;
    if (clicked) {
      if (sounds) Sclick.play();
      savePara();
      loadSettings();
      newGame();
      paused = false;
      timePaused = millis();
      IAPlaying = false;
      return;
    }
  }

  push();
  translate(445, 275);
  sounds = pauseCheckbox('Sounds :', sounds, 545, 305);
  pop();

  push();
  translate(445, 235);
  showFPS = pauseCheckbox('Show FPS :', showFPS, 545, 265);
  pop();

  push(); // Difficulty slider
  translate(95, 150);
  fill(150);
  noStroke();
  rect(0, 0, 180, 10, 5);

  fill(10);
  ellipse(sliderPos, 5, 14, 14);
  textFont(FONT_WIN, 12);
  text(int(difficulty), 185, 9);

  textAlign(CENTER);
  fill('#008200');
  text('Easy', 155, -5);
  fill('#FF8200');
  text('Medium', 90, -5);
  fill('#CD1800');
  text('Difficult', 25, -5);
  textSize(20);
  fill(255);
  text('Difficulty :', 95, -30);

  const sX = mouseX - 195;
  const sY = mouseY - 180;
  if (mouseIsPressed && sX > 0 && sX < 180 && sY > -2 && sY < 12) {
    sliderPos = sX;
  }

  difficulty = map(sliderPos, 0, 180, 995, 2006);
  pop();
}
