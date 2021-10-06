float r = 0;
float sliderPos;

void Pause() {
    if (paused) {
        timePaused = millis() - temp;
        filter(BLUR, 2);
        
        push();                                                        //Tile Description
        translate( -100, -30);
        noStroke();
        fill(#606060, 230);
        rect(10, 5, 570, 407, 10);
        textAlign(CENTER);
        textFont(overlay, 35);
        fill(#699B68);
        text("Game paused.", 295, 70);
        textAlign(LEFT);
        fill(255);
        textSize(18);
        image(IfeetBomb, 30, 210);
        text("You can walk over bombs for 10 sec.", 70, 231);
        image(Iinvincibility, 30, 250);
        text("You are invincible for 10 sec.", 70, 271);
        image(Ideath, 30, 290);
        text("You will die if you walk on it.", 70, 311);
        image(Ibombeup, 30, 330);
        text("You can place more than 1 bomb at time.", 70, 351);
        image(Iflame, 30, 370);
        text("Your explosions are going farther.", 70, 391);
        pop();
        
        
        push();                                                        //Restart
        translate(455, 360);
        fill(#A8101A);
        text("Restart", -25 - textWidth("Restart"), 12);
        if (restart) {
            rotate(r);
            r += 0.15;
            if (r >= 1.90) {
                restart = false;
                r = 0;
            }
        }
        noFill();
        strokeWeight(3);
        stroke(#A8101A);
        arc(0, 0, 25, 25, -HALF_PI, PI);
        beginShape();
        vertex( -12, -3);
        vertex( -8, 1);
        vertex( -8, 2);
        vertex( -9, 2);
        vertex( -11, 0);
        vertex( -14, 0);
        vertex( -16, 2);
        vertex( -17, 2);
        vertex( -17, 1);
        vertex( -13, -3);
        endShape();
        int aMouseX = mouseX - 555; 
        int aMouseY = mouseY - 390;
        if (aMouseX >-  20 && aMouseX < 28 && aMouseY >-  13 && aMouseY < 13) {
            restart = true;
            if (mousePressed) {
                if (sounds) Sclick.play();
                
                if (waitingClient) {
                    client.stop();
                    client = null;
                }
                if (waitingServer) {
                    server.stop();
                    server = null;
                }
                savePara();
                settings();
                setup();
                paused = false;
                timePaused = millis();
                waitingServer = false;
                waitingClient = false;
                startNC = false;
                startNS = false;
                IAPlaying = false;
            }
        }
        pop();
        
        
        push();                                                        //Sounds
        textFont(win, 20);
        translate(445, 275);
        fill(255);
        text("Sounds :", -8 - textWidth("Sounds :"), 17);
        int bMouseX = mouseX - 545; 
        int bMouseY = mouseY - 305;
        if (bMouseX > 0 && bMouseX < 20 && bMouseY > 0 && bMouseY < 20) {
            fill(#A5A5A5);
            if (mousePressed) {
                Sclick.play();
                sounds = sounds;
                delay(100);
            }
        } else {
            fill(#CECECE);
        }
        strokeWeight(3);
        stroke(0);
        rect(0, 0, 20, 20);
        if (sounds) {
            fill(#B60000);
            stroke(#B60000);
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
        
        
        push();                                                        //Music
        textFont(win, 20);
        translate(445, 235);
        fill(255);
        text("Music :", -8 - textWidth("Music :"), 17);
        int cMouseX = mouseX - 545; 
        int cMouseY = mouseY - 265;
        if (cMouseX > 0 && cMouseX < 20 && cMouseY > 0 && cMouseY < 20) {
            fill(#A5A5A5);
            if (mousePressed) {
                if (sounds) Sclick.play();
                music = !music;
                delay(100);
            }
        } else {
            fill(#CECECE);
        }
        strokeWeight(3);
        stroke(0);
        rect(0, 0, 20, 20);
        if (music) {
            fill(#B60000);
            stroke(#B60000);
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
        
        
        push();                                                        //Show FPS
        translate(445, 195);
        fill(255);
        textFont(win, 20);
        text("Show FPS :", -8 - textWidth("Show FPS :"), 17);
        int dMouseX = mouseX - 545; 
        int dMouseY = mouseY - 225;
        if (dMouseX > 0 && dMouseX < 20 && dMouseY > 0 && dMouseY < 20) {
            fill(#A5A5A5);
            if (mousePressed) {
                if (sounds) Sclick.play();
                showFPS = !showFPS;
                delay(100);
            }
        } else {
            fill(#CECECE);
        }
        strokeWeight(3);
        stroke(0);
        rect(0, 0, 20, 20);
        if (showFPS) {
            fill(#B60000);
            stroke(#B60000);
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
        
        
        push();                                                        //Difficuty Slider
        translate(95, 150);
        fill(150);
        noStroke();
        rect(0, 0, 180, 10, 5);
        
        fill(10);
        ellipse(sliderPos, 5, 14, 14);
        textFont(win, 12);
        text(int(difficulty), 185, 9);
        
        textAlign(CENTER);
        fill(#008200);
        text("Easy", 155, -5);
        fill(#FF8200);
        text("Medium", 90, -5);
        fill(#CD1800);
        text("Difficult", 25, -5);
        textSize(20);
        fill(255);
        text("Difficulty :", 95, -30);
        
        int MouseX = mouseX - 195; 
        int MouseY = mouseY - 180;
        if (mousePressed && MouseX > 0 && MouseX < 180 && MouseY >-  2 && MouseY < 12) {
            sliderPos = MouseX;
        }
        
        difficulty = map(sliderPos, 0, 180, 995, 2006);
        pop();
    }
}
