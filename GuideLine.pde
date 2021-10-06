void menu() {
  image(Iheader, -100, -30);

  if (state != 0) {
    oPlayer1.show(); 
    oPlayer2.show();

    push();                                      //Time
    textAlign(CENTER);
    fill(255);
    textFont(overlay, 25);
    text(MsConversion(int(temp)), 195, -5 );
    pop();
  }

  switch(state) {
  case 0:
    image(IenterMenu, -100, -30);
    image(Iheader, -100, 360);

    push();
    textAlign(CENTER);

    fill(#737373);
    textFont(menu, 30);
    text("Play :", 195, 210);
    text("Exit", 195, 330);

    fill(#FFC300);
    textSize(22);
    text("1 Vs 1", 195, 250);
    text("1 Vs IA", 195, 280);
    textAlign(RIGHT);
    text("Host a game", 480, 330);
    text("Join a game", 480, 360);
    pop();

    if (!networkON && !paused) {
      if (IsPressed(168, 209, 235, 251)) {        //1 Vs 1
        state++;
      }
      if (IsPressed(166, 224, 260, 276)) {        //1 Vs IA
        IAPlaying = true;
        oPlayer2.input.Text = "IA";
        oPlayer2.input.TextLength = 2;
        Player2.Color = 0;
        Player2.ColorBis = 0;
        state++;
      }

      if (IsPressed(169, 218, 300, 330)) {        //Exit
        exit();
      }

      if (IsPressed(359, 480, 312, 335)) {        //Host a game
        waitingServer = true;
        if (server == null) server = new Server(this, 5204);
      }

      if (IsPressed(360, 482, 341, 365)) {        //Join a game
        waitingClient = true;
      }
    }

    network_Waiting();
    break;
  case 1:
    fill(Player1.Color, 255, 255);
    rect(38, 110, 130, 165);
    fill(Player2.Color, Player2.ColorBis, 255);
    rect(232, 110, 130, 165);

    image(IselectPerso, 0, 0);

    Player1.Color = drawSlider(25, 287, 150, 30.0, Player1.Color, (!networkON | waitingServer));
    if (!IAPlaying) Player2.Color = drawSlider(215, 287, 150, 30.0, Player2.Color, (!networkON | waitingClient));

    fill(255);
    textFont(overlay, 28);
    textAlign(CENTER);
    text(Player1.name, 100, 90);
    text(Player2.name, 290, 90);
    textAlign(LEFT);

    if (networkON) {
      push();
      int Color = 0;
      String text = "Not Ready";
      if (clientReady) {
        Color = 80;
        text = "Ready";
      }
      Player1.casque(Color, 235, -30);
      translate(240, -30);
      image(loadImage("Perso.png"), -5, 0);
      fill(Color, 255, 255);
      textFont(menu, 15);
      text(text, 25, 22);
      pop();
    }

    if (IsPressed(160, 227, 19, 61) && !paused) {                                                              //Go
      delay(100);
      savePara();
      oPlayer1.input.selected = false;
      oPlayer1.input.selected = false;

      if (Player1.name == "" && oPlayer1.input.TextLength == 0 && (!networkON | waitingServer)) {
        oPlayer1.input.TextLength = 1;
        oPlayer1.input.Text = "Player 1";
      }
      if (Player2.name == "" && oPlayer2.input.TextLength == 0 && (!networkON | waitingClient)) {
        oPlayer2.input.TextLength = 1;
        oPlayer2.input.Text = "Player 2";
      }

      if (waitingClient) {
        client.write("-5-" + oPlayer2.input.Text + "-");
        client.write("-6-" + oPlayer2.input.TextLength + "-");
        client.write("-7-" + Player2.Color + "-");
        client.write("-8-0-");
        clientReady = !clientReady;
        setup();
      }

      if ((!networkON | (waitingServer && clientReady))) {
        if (waitingServer) {
          server.write("-2-" + oPlayer1.input.Text + "-");
          server.write("-3-" + oPlayer1.input.TextLength + "-");
          server.write("-4-" + Player1.Color + "-");
          server.write("-1-0-");
          clientReady = false;
        }
        state++;
      }
    }
    break;
  case 2:
    clientReady = false;
    for (int i = 0; i<TilePool.size(); i++) {
      TilePool.get(i).show();
    }
    for (int i =0; i<PlayerPool.size(); i++) {
      PlayerPool.get(i).show();
      if (PlayerPool.get(i).dead) {
        if (!networkON) {
          PlayerPool.remove(i);
        } else {
          if (waitingServer) server.write("-15-" + i + "-");
          if (waitingClient) client.write("-15-" + i + "-");
        }
      }
    }

    if (PlayerPool.size() == 1) {
      PlayerPool.get(0).score += 1;
      state++;
    }

    if (IAPlaying && !paused) IA.show();
    /*
    drawEdges(gEdges, color(240, 192, 240, 160), 1.0f);
     drawEdges(exploredEdges, color(0, 0, 255), 1.8f);
     drawNodes();
     drawRoute(rNodes, color(200, 0, 0), 5.0f);
     */

    break;
  case 3:
    image(Iwin, 0, 0);

    push();
    fill(#FFB138);
    textFont(win, 25);
    textAlign(CENTER);
    text(PlayerPool.get(0).name + " gagne le match !", 195, 225);
    pop();

    if (IsPressed(131, 262, 314, 344)) {
      setup();
      state = 1;
    }
    break;
  }

  Pause();

  if (showFPS) {
    push();
    fill(255);
    translate(-100, -30);
    textFont(menu, 15);
    text(int(frameRate), 5, 20);
    pop();
  }

  push();                                      //Pause button
  translate(460, -28);
  ellipseMode(CORNER);
  fill(#808080);
  stroke(0);
  strokeWeight(1);
  ellipse(0, 0, 25, 25);

  noStroke();
  fill(#FFB83F);
  rect(7, 4, 4, 17);
  rect(15, 4, 4, 17);

  boolean selected = false;
  if (IsPressed(460, 485, -28, -3) && !selected) {
    savePara();
    paused = !paused;
    selected = true;
    delay(100);
    selected = false;
    if (waitingServer) server.write("-12-0-");
    if (waitingClient) client.write("-12-0-");
    if (waitingServer) server.write("-11-" + int(difficulty) + "-");
  }
  pop();
}
