class TextInput {
  constructor(x = 0, y = 0, w = 99, h = 32, t = 25, rx = 0, ry = 0) {
    this.pos = createVector(x, y);
    this.Width = w;
    this.Height = h;

    this.Background = 0;
    this.BackgroundSelected = 25;

    this.Text = '';
    this.TextLength = 0;
    this.textSize = t;

    this.selected = false;

    this.tr = [rx, ry];
  }

  Draw() {
    if (this.Text !== '') {
      noStroke();
      if (this.TextLength === 0) this.Text = '';
    } else {
      stroke('#FF0000');
    }

    fill(this.selected ? this.BackgroundSelected : this.Background);
    rect(this.pos.x, this.pos.y, this.Width, this.Height);

    if (this.selected) {
      stroke(255);
      const aX = this.pos.x + textWidth(this.Text) + 2;
      const aY = this.pos.y + 2;
      line(aX, aY, aX, aY + this.Height - 6);
    }

    fill(255);
    text(this.Text, this.pos.x + 1, this.pos.y + this.textSize);
  }

  // Returns true when Enter is pressed.
  KeyPressed(k, kc) {
    if (this.selected) {
      if (kc === BACKSPACE) {
        this.backspace();
      } else if (kc === 32) {
        this.addText(' ');
      } else if (kc === ENTER) {
        return true;
      } else if (k.length === 1) {
        const code = k.charCodeAt(0);
        if (code >= 32 && code <= 122) this.addText(k);
      }
    }
    return false;
  }

  addText(ch) {
    push();
    textFont(FONT_OVERLAY, this.textSize);
    const fits = textWidth(this.Text + ch) < this.Width;
    pop();
    if (fits) {
      this.Text += ch;
      this.TextLength++;
    }
  }

  backspace() {
    if (this.TextLength > 0) {
      this.Text = this.Text.substring(0, this.TextLength - 1);
      this.TextLength--;
    }
  }

  overBox(x, y) {
    const aX = x - this.tr[0];
    const aY = y - this.tr[1];
    return aX >= this.pos.x && aX <= this.pos.x + this.Width &&
      aY >= this.pos.y && aY <= this.pos.y + this.Height;
  }

  Pressed(x, y) {
    this.selected = this.overBox(x, y);
  }
}

function drawSlider(xPos, yPos, sWidth, sHeight, hueVal, actif) {
  let pos = map(hueVal, 0, 255, 0, sWidth);

  for (let i = 0; i < sWidth; i++) {
    stroke(map(i, 0, sWidth, 0, 255), 255, 255);
    line(xPos + i, yPos, xPos + i, yPos + sHeight);
  }
  if (mouseIsPressed && MouseX > int(xPos) && MouseX < int(xPos + sWidth) &&
    MouseY > int(yPos) && MouseY < int(yPos + sHeight) && !paused && actif) {
    pos = MouseX - xPos;
  }
  stroke(100);
  hueVal = map(pos, 0, sWidth, 0, 255);
  fill(hueVal, 255, 255);
  rect(pos + xPos - 3, yPos - 3, 6, sHeight + 6);
  return hueVal;
}
