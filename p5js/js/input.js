function keyPressed() {
  switch (state) {
    case 1:
      if (!paused) {
        if (oPlayer1.input.KeyPressed(key, keyCode)) oPlayer1.input.selected = false;
        if (oPlayer2.input.KeyPressed(key, keyCode)) oPlayer2.input.selected = false;
      }
      break;
    case 2:
      if (!paused) {
        const k = key.toLowerCase();
        if (k === 'd') Player1.move(largeurCase, 0);
        if (k === 'q') Player1.move(-largeurCase, 0);
        if (k === 'z') Player1.move(0, -largeurCase);
        if (k === 's') Player1.move(0, largeurCase);
        if (key === ' ') Player1.PosBomb();

        if (!IAPlaying) {
          if (keyCode === RIGHT_ARROW) Player2.move(largeurCase, 0);
          if (keyCode === LEFT_ARROW) Player2.move(-largeurCase, 0);
          if (keyCode === UP_ARROW) Player2.move(0, -largeurCase);
          if (keyCode === DOWN_ARROW) Player2.move(0, largeurCase);
          if (key === '0') Player2.PosBomb();
        }
      }
      break;
  }

  if (key === '²' || keyCode === ESCAPE) {
    paused = !paused;
    if (sounds) Sclick.play();
  }

  // Stop arrows, space and backspace from scrolling or navigating the page.
  if ([LEFT_ARROW, RIGHT_ARROW, UP_ARROW, DOWN_ARROW, BACKSPACE, 32].includes(keyCode)) return false;
}

function mousePressed() {
  clicked = true;
  if (state === 1 && !paused) {
    oPlayer1.input.Pressed(mouseX - 100, mouseY - 30);
    oPlayer2.input.Pressed(mouseX - 100, mouseY - 30);
  }
}

// Buttons react once per click (the Processing version used delay() to debounce).
function IsPressed(x1, x2, y1, y2) {
  if (clicked && MouseX > x1 && MouseX < x2 && MouseY > y1 && MouseY < y2) {
    if (sounds && !Sclick.isPlaying()) Sclick.play();
    return true;
  }
  return false;
}
