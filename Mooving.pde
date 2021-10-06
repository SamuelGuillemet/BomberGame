void keyPressed() {
    switch(state) {
        case 0:
            if (waitingClient) {
                if (IPinput.KeyPressed(key,(int)keyCode)) {
                    IPinput.selected = false;
                }
                if (nameinput.KeyPressed(key,(int)keyCode)) {
                    nameinput.selected = false;
                }
            }
            break;
        case 1:
            if (!paused) {
                if (oPlayer1.input.KeyPressed(key,(int)keyCode)) {
                    oPlayer1.input.selected = false;
                }
                if (oPlayer2.input.KeyPressed(key,(int)keyCode)) {
                    oPlayer2.input.selected = false;
                }
            }
            break;
        case 2:
            if (!paused) {
                if (!networkON | waitingServer) {
                    if (key == 'd' || key == 'D') Player1.move(new PVector(largeurCase, 0));
                    if (key == 'q' || key == 'Q') Player1.move(new PVector( -largeurCase, 0));
                    if (key == 'z' || key == 'Z') Player1.move(new PVector(0, -largeurCase));
                    if (key == 's' || key == 'S') Player1.move(new PVector(0, largeurCase));
                    if (key == '') Player1.PosBomb();
                }
                
                if ((!networkON | waitingClient) && !IAPlaying) {
                    if (keyCode == RIGHT) Player2.move(new PVector(largeurCase, 0));
                    if (keyCode == LEFT) Player2.move(new PVector( -largeurCase, 0));
                    if (keyCode == UP) Player2.move(new PVector(0, -largeurCase));
                    if (keyCode == DOWN) Player2.move(new PVector(0, largeurCase));
                    if (key == '0') Player2.PosBomb();
                }
                
                if (waitingClient) {
                    if (keyCode == RIGHT) client.write("-10-1-");
                    if (keyCode == LEFT) client.write("-10-2-");
                    if (keyCode == UP) client.write("-10-3-");
                    if (keyCode == DOWN) client.write("-10-4-");
                    if (key == '0') client.write("-10-5-");
                }
                
                if (waitingServer) {
                    if (key == 'd' || key == 'D') server.write("-9-1-");
                    if (key == 'q' || key == 'Q') server.write("-9-2-");
                    if (key == 'z' || key == 'Z') server.write("-9-3-");
                    if (key == 's' || key == 'S') server.write("-9-4-");
                    if (key == '') server.write("-9-5-");
                }
            }
            break;
    }
    
    if ((key == '²' || keyCode == ESC)) {
        paused = !paused;
        if (sounds) Sclick.play();
    }
}

void mousePressed() {
    if (state == 1 && !paused) {
        if (!networkON | waitingServer) oPlayer1.input.Pressed(MouseX, MouseY);
        if (!networkON | waitingClient) oPlayer2.input.Pressed(MouseX, MouseY);
    }
    if (state == 0 && waitingClient) {
        IPinput.Pressed(MouseX, MouseY);
        nameinput.Pressed(MouseX, MouseY);
    }
}

boolean IsPressed(int x1, int x2, int y1, int y2) {
    if (mousePressed && MouseX > x1 && MouseX < x2 && MouseY > y1 && MouseY < y2) {
        if (sounds && !Sclick.isPlaying()) Sclick.play();
        return true;
    }
    return false;
}
