class TextInput {
  PVector pos = new PVector(0, 0);
  int Width = 99;
  int Height = 32;

  color Background = 0;
  color BackgroundSelected = 25;

  String Text = "";
  int TextLength = 0;
  int textSize = 25;

  boolean selected = false;

  int[] tr = {0, 0};


  TextInput() {
  }

  TextInput(int x, int y, int w, int h, int t, int rx, int ry) {
    pos.x = x;
    pos.y = y;
    Width = w;
    Height = h;
    textSize = t;
    tr[0] = rx;
    tr[1] = ry;
  }

  void Draw() {
    if (Text != "") {
      noStroke();
      if (TextLength == 0) Text = "";
    } else { 
      stroke(#FF0000);
    }

    if (selected) {
      fill(BackgroundSelected);
    } else {
      fill(Background);
    }

    rect(pos.x, pos.y, Width, Height);

    if (selected) {
      stroke(255);
      float aX = pos.x + textWidth(Text) + 2;
      float aY = pos.y + 2;
      line(aX, aY, aX, aY + Height - 6);
    }

    fill(255);
    text(Text, pos.x + 1, pos.y + textSize);
  }

  boolean KeyPressed(char KEY, int KEYCODE) {
    if (selected) {
      if (KEYCODE == (int)BACKSPACE) {
        BACKSPACE();
      } else if (KEYCODE == 32) {
        addText(' ');
      } else if (KEYCODE == (int)ENTER) {
        return true;
      } else {
        if (KEY >= 32 && KEY <= 122) {
          addText(KEY);
        }
      }
    }
    return false;
  }

  void addText(char text) {
    if (textWidth(Text + text) < Width) {
      Text += text;
      TextLength++;
    }
  }

  void BACKSPACE() {
    if (TextLength > 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
    }
  }

  boolean overBox(int x, int y) {
    int aX = x - tr[0];
    int aY = y - tr[1];
    if (aX >= pos.x && aX <= pos.x + Width) {
      if (aY >= pos.y && aY <= pos.y + Height) {
        return true;
      }
    }

    return false;
  }

  void Pressed(int x, int y) {
    if (overBox(x, y)) {
      selected = true;
    } else {
      selected = false;
    }
  }
}

float drawSlider(float xPos, float yPos, float sWidth, float sHeight, float hueVal, boolean actif) {
  float sliderPos=map(hueVal, 0.0, 255.0, 0.0, sWidth);

  for (int i=0; i<sWidth; i++) { 
    hueVal=map(i, 0.0, sWidth, 0.0, 255.0);  
    stroke(hueVal, 255, 255);
    line(xPos+i, yPos, xPos+i, yPos+sHeight);
  }
  if (mousePressed && MouseX > int(xPos) && MouseX < int((xPos+sWidth)) && MouseY > int(yPos) && MouseY < int(yPos+sHeight) && !paused && actif) {
    sliderPos=MouseX-xPos;
  }
  stroke(100);
  hueVal=map(sliderPos, 0.0, sWidth, 0.0, 255.0);
  fill(hueVal, 255, 255);
  rect(sliderPos+xPos-3, yPos-3, 6, sHeight+6);
  return hueVal;
}
