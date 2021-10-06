boolean startNC = false;
boolean startNS = false;

String clientName = "";

boolean clientReady = false; 

boolean networkON = waitingServer | waitingClient;

TextInput IPinput = new TextInput(50, 75, 270, 25, 20, 20, 75);
TextInput nameinput = new TextInput(15, 150, 175, 25, 20, 20, 75);


void network_Waiting() {

  networkON = waitingServer | waitingClient;

  if (waitingServer && state == 0) {
    filter(BLUR, 2);

    push();                                                                  //Text Host a Game + IP
    translate(10, 75);
    noStroke();
    fill(#606060, 230);
    rect(0, 0, 370, 207, 10);
    stroke(#D50004);
    line(350, 5, 365, 20);
    line(350, 20, 365, 5);
    fill(255);
    textAlign(CENTER);
    textFont(menu, 25);
    text("Host a game", 185, 25);

    text(Server.ip(), 185, 80);
    pop();

    if (IsPressed(360, 375, 80, 95)) {                                        //Quit
      waitingServer = false;
      server.stop();
    }

    textFont(menu, 22);
    fill(#B7B7B7);
    if (clientName != "") text(clientName + " has connected.", 20, 260);

    push();                                                                  //Start button
    textFont(win, 20);
    translate(330, 233);
    fill(255);
    text("Start :", -8-textWidth("Start :"), 20);
    scale(1.5);

    int bMouseX = mouseX - 428; 
    int bMouseY = mouseY - 260;

    if (bMouseX > 0 && bMouseX<35 && bMouseY>0 && bMouseY<35) {
      fill(#A5A5A5);
      if (mousePressed && !startNS && clientName != "") {
        if (sounds) Sclick.play();
        startNS = true;
        delay(100);
        server.write("-1-0-");
        server.write("-14-" + SeedUsed + "-");
        state++;
      }
    } else {
      fill(#CECECE);
    }
    strokeWeight(3);
    stroke(0);
    rect(0, 0, 20, 20);
    if (startNS) {
      fill(#0AA300);
      stroke(#0AA300);
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
    pop();
  }



  if (waitingClient) {
    if (state == 0) {
      filter(BLUR, 2);

      push();                                                                  //Text Join a game
      translate(10, 75);
      noStroke();
      fill(#606060, 230);
      rect(0, 0, 370, 207, 10);
      stroke(#D50004);
      line(350, 5, 365, 20);
      line(350, 20, 365, 5);
      fill(255);
      textAlign(CENTER);
      textFont(menu, 20);
      text("Join a game", 185, 25);
      text("Enter the IP server :", 185, 68);


      textAlign(LEFT);
      text("Enter your name :", 18, 143);
      noStroke();
      IPinput.Draw();
      noStroke();
      nameinput.Draw();

      push();                                                                  //Start button
      textFont(win, 20);
      translate(320, 157);
      fill(255);
      text("Start :", -8-textWidth("Start :"), 20);
      scale(1.5);
      int bMouseX = mouseX - 428; 
      int bMouseY = mouseY - 260;
      if (bMouseX > 0 && bMouseX<35 && bMouseY>0 && bMouseY<35) {
        fill(#A5A5A5);
        if (mousePressed && !startNC && nameinput.Text != "") {
          if (sounds) Sclick.play();
          startNC = true;
          if (client == null) client = new Client(this, IPinput.Text, 5204);
          if (client.active()) {
            client.write("-13-" + nameinput.Text + "-");
            client.write("-17-" + nameinput.TextLength + "-");
            oPlayer2.input.Text = nameinput.Text;
            oPlayer2.input.TextLength = nameinput.TextLength;
          }
          delay(100);
        }
      } else {
        fill(#CECECE);
      }
      strokeWeight(3);
      stroke(0);
      rect(0, 0, 20, 20);
      if (startNC) {
        fill(#0AA300);
        stroke(#0AA300);
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
      pop();

      pop();

      if (IsPressed(360, 375, 80, 95)) {                                          //Quit
        waitingClient = false;
        startNC = false;
        if (client != null) {
          client.stop();
          client = null;
        }
      }
    } else {
      Client client = server.available();
      if (client != null) {
        decrypt(client.readString());
      }
    }
  }
}

void disconnectEvent(Client client) {
  clientName = "";
  if (state != 0) {
    settings();
    setup();
    paused = false;
    timePaused = millis();
    waitingServer = false;
    server = null;
    client = null;
    startNS = false;
    startNC = false;
    clientReady = false;
  }
}

void clientEvent(Client client) {
  decrypt(client.readString());
}


void decrypt(String line) {
  for (int i = 0; i<split(line, '-').length/3; i++) {
    int statement = int(split(line, '-')[1 + 3*i]);
    String instruction = split(line, '-')[2 + 3*i];

    switch(statement) {
    case 1:
      state++;
      clientReady = false;
      break;
    case 2:
      oPlayer1.input.Text = instruction;
      break;
    case 3:
      oPlayer1.input.TextLength = int(instruction);
      break;
    case 4:
      Player1.Color = int(instruction);
      break;
    case 5:
      oPlayer2.input.Text = instruction;
      break;
    case 6:
      oPlayer2.input.TextLength = int(instruction);
      break;
    case 7:
      Player2.Color = int(instruction);
      break;
    case 8:
      clientReady = !clientReady;
      break;
    case 9:
      switch(int(instruction)) {
      case 1:
        Player1.move(new PVector(largeurCase, 0));
        break;
      case 2:
        Player1.move(new PVector(-largeurCase, 0));
        break;
      case 3:
        Player1.move(new PVector(0, -largeurCase));
        break;
      case 4:
        Player1.move(new PVector(0, largeurCase));
        break;
      case 5:
        Player1.PosBomb();
        break;
      }
      break;
    case 10:
      switch(int(instruction)) {
      case 1:
        Player2.move(new PVector(largeurCase, 0));
        break;
      case 2:
        Player2.move(new PVector(-largeurCase, 0));
        break;
      case 3:
        Player2.move(new PVector(0, -largeurCase));
        break;
      case 4:
        Player2.move(new PVector(0, largeurCase));
        break;
      case 5:
        Player2.PosBomb();
        break;
      }
      break;
    case 11:
      difficulty = float(instruction);
      sliderPos =  map(difficulty, 1000, 2000, 0, 180);
      break;
    case 12:
      paused = !paused;
      delay(100);
      break;
    case 13:
      clientName = instruction;
      oPlayer2.input.Text = instruction;
      break;
    case 14:
      SeedUsed = int(instruction);
      break;
    case 15:
      if (PlayerPool.get(int(instruction)) != null) {
        if (PlayerPool.get(int(instruction)).dead == true) {
          PlayerPool.remove(int(instruction));
          if (waitingServer) server.write("-15-" + instruction + "-");
          if (waitingClient) client.write("-15-" + instruction + "-");
        }
      }
      break;
    case 17:
      oPlayer2.input.TextLength = int(instruction);
      break;
    }
  }
}
