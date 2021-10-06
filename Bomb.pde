class Bomb {
    PVector pos;
    float time;
    int flame;
    int timeToExplosion;
    
    boolean off;
    boolean explode = false;
    
    ArrayList < Tile > TileExp = new ArrayList < Tile > ();
    
    
    Bomb(int[] aPos, int aFlame) {
        pos = new PVector(aPos[1], aPos[0]);
        tiles[(int) pos.y][(int) pos.x].bomb = true;
        time = temp;
        off = false;
        flame = aFlame;
        timeToExplosion = int(difficulty);
    }
    
    voidexplosion() {
        generateDanger();
        if (tiles[(int) pos.y][(int) pos.x].expl == true && !explode) time -= time + timeToExplosion - temp;
        if (temp >= time + timeToExplosion) {
            tiles[(int) pos.y][(int) pos.x].bomb = false;
            if (sounds && !explode) Sexpl.play();
            drawexplosion();
        }
        
        if (temp >= time + timeToExplosion + 500) {
            for (int k = 0; k < TileExp.size(); k++) {
                TileExp.get(k).reset();
                TileExp.get(k).PUpOff = true;
            }
            off = true;
        }
    }
    
    void drawexplosion() {
        
        for (intk = 1; k <= flame; k++) {
            int Y = (int) pos.y + k;
            int X = (int) pos.x;
            if (Y < map.length) {
                if (!tiles[Y][X].wall) {
                    if (tiles[Y][X].dirt) tiles[Y][X].PUpOff = false;
                    if (tiles[Y][X].PUpOff) tiles[Y][X].resetPowerUp();
                    tiles[Y][X].reset();
                    tiles[Y][X].vertical = true;
                    TileExp.add(tiles[Y][X]);
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = 1;
                    if (k == flame && !tiles[Y][X].wall) a = 0;
                    tiles[Y - a][X].reset();
                    tiles[Y - a][X].expBas = true;
                    break;
                }
            }
        }
        
        for (intk = 1; k <= flame; k++) {
            int Y = (int) pos.y - k;
            int X = (int) pos.x;
            if (Y >= 0) {
                if (!tiles[Y][X].wall) {
                    if (tiles[Y][X].dirt) tiles[Y][X].PUpOff = false;
                    if (tiles[Y][X].PUpOff) tiles[Y][X].resetPowerUp();
                    tiles[Y][X].reset();
                    tiles[Y][X].vertical = true;
                    TileExp.add(tiles[Y][X]);
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = 1;
                    if (k == flame && !tiles[Y][X].wall) a = 0;
                    tiles[Y + a][X].reset();
                    tiles[Y + a][X].expHaut = true;
                    break;
                }
            }
        }
        
        for (intk = 1; k <= flame; k++) {
            int Y = (int) pos.y;
            int X = (int) pos.x - k;
            if (X >= 0) {
                if (!tiles[Y][X].wall) {
                    if (tiles[Y][X].dirt) tiles[Y][X].PUpOff = false;
                    if (tiles[Y][X].PUpOff) tiles[Y][X].resetPowerUp();
                    tiles[Y][X].reset();
                    tiles[Y][X].horizontal = true;
                    TileExp.add(tiles[Y][X]);
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = 1;
                    if (k == flame && !tiles[Y][X].wall) a = 0;
                    tiles[Y][X + a].reset();
                    tiles[Y][X + a].expGauche = true;
                    break;
                }
            }
        }
        
        for (intk = 1; k <= flame; k++) {
            int Y = (int) pos.y;
            int X = (int) pos.x + k;
            if (X < map.length) {
                if (!tiles[Y][X].wall) {
                    if (tiles[Y][X].dirt) tiles[Y][X].PUpOff = false;
                    if (tiles[Y][X].PUpOff) tiles[Y][X].resetPowerUp();
                    tiles[Y][X].reset();
                    tiles[Y][X].horizontal = true;
                    TileExp.add(tiles[Y][X]);
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = 1;
                    if (k == flame && !tiles[Y][X].wall) a = 0;
                    tiles[Y][X - a].reset();
                    tiles[Y][X - a].expDroite = true;
                    break;
                }
            }
        }
        int Xc = (int) pos.x;
        int Yc = (int) pos.y;
        tiles[Yc][Xc].reset();
        tiles[Yc][Xc].expCentre = true;
        TileExp.add(tiles[Yc][Xc]);
        explode = true;
    }
    
    void generateDanger() {
        for (int k = 1; k <= flame; k++) {
            int Y = (int) pos.y + k;
            int X = (int) pos.x;
            if (Y < map.length) {
                if (!tiles[Y][X].wall) {
                    tiles[Y][X].onGoingDanger = true;
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = (k ==  flame && !tiles[Y][X].wall) ? 0 : 1;
                    tiles[Y - a][X].onGoingDanger = true;
                    break;
                }
            }
        }
        
        for (int k = 1; k <= flame; k++) {
            int Y = (int) pos.y - k;
            int X = (int) pos.x;
            if (Y >= 0) {
                if (!tiles[Y][X].wall) {
                    tiles[Y][X].onGoingDanger = true;
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = (k ==  flame && !tiles[Y][X].wall) ? 0 : 1;
                    tiles[Y + a][X].onGoingDanger = true;
                    break;
                }
            }
        }
        
        for (int k = 1; k <= flame; k++) {
            int Y = (int) pos.y;
            int X = (int) pos.x - k;
            if (X >= 0) {
                if (!tiles[Y][X].wall) {
                    tiles[Y][X].onGoingDanger = true;
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = (k ==  flame && !tiles[Y][X].wall) ? 0 : 1;
                    tiles[Y][X + a].onGoingDanger = true;
                    break;
                }
            }
        }
        
        for (int k = 1; k <= flame; k++) {
            int Y = (int) pos.y;
            int X = (int) pos.x + k;
            if (X < map.length) {
                if (!tiles[Y][X].wall) {
                    tiles[Y][X].onGoingDanger = true;
                }
                if (tiles[Y][X].wall || k == flame) {
                    int a = (k ==  flame && !tiles[Y][X].wall) ? 0 : 1;
                    tiles[Y][X - a].onGoingDanger = true;
                    break;
                }
            }
        }
    }
}