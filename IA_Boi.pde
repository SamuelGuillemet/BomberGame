class PlayerIA {
    Player player;
    GraphNode[] r;
    
    int nextTile[] = new int[2];
    int currentTile[] = new int[2];
    
    boolean ready = false;
    
    int c = 5;
    
    int mode = 1;                            //Mode 1 attack //Mode 2 defence
    
    
    PlayerIA(Player aPlayer) {
        player = aPlayer;
    }
    
    voidshow() {
        r = rNodes;
        if (r.length > 1) nextTile = coordToTile(r[1].xf(), r[1].yf());
        currentTile[1] = player.getPosition()[0];
        currentTile[0] = player.getPosition()[1];
        
        if (!ready) {
            c--;
            if (c <= 0) ready = true;
        } else {
            move();
            c = 3;
            ready = false;
        }
        mode = (tiles[currentTile[1]][currentTile[0]].dangerous) ? 2 : 1;
    }
    
    void move() {
        switch(mode) {
            case 1:
                startNode = graph.getNodeAt(Player2.pos.x + 15, Player2.pos.y + 15, 0, 10);
                endNode = graph.getNodeAt(Player1.pos.x + 15, Player1.pos.y + 15, 0, 10);
                usePathFinder(pathFinder);
                
                if (tiles[nextTile[1]][nextTile[0]].dirt || tiles[nextTile[1]][nextTile[0]].death || (nextTile[1] == Player1.getPosition()[0] && nextTile[0] == Player1.getPosition()[1])) {
                    Player2.PosBomb();
                } else if (tiles[nextTile[1]][nextTile[0]].safe) {
                    if (nextTile[0] - currentTile[0] == 1) Player2.move(new PVector(largeurCase, 0));
                    if (nextTile[0] - currentTile[0] == -1) Player2.move(new PVector( -largeurCase, 0));
                    if (nextTile[1] - currentTile[1] == 1) Player2.move(new PVector(0, largeurCase));
                    if (nextTile[1] - currentTile[1] == -1) Player2.move(new PVector(0, -largeurCase));
                } else if (tiles[nextTile[1]][nextTile[0]].expl || tiles[nextTile[1]][nextTile[0]].onGoingDanger) {
                    findPUp(currentTile);
                }
                break;
            case 2:
                searchSafePlace(currentTile);
                if (!tiles[nextTile[1]][nextTile[0]].death) {
                    if (nextTile[0] - currentTile[0] == 1) Player2.move(new PVector(largeurCase, 0));
                    if (nextTile[0] - currentTile[0] == -1) Player2.move(new PVector( -largeurCase, 0));
                    if (nextTile[1] - currentTile[1] == 1) Player2.move(new PVector(0, largeurCase));
                    if (nextTile[1] - currentTile[1] == -1) Player2.move(new PVector(0, -largeurCase));
                }
                break;
        }
    }
    
    int[] coordToTile(float aX, float aY) {
        int x = int(aX / largeurCase);
        int y = int(aY / largeurCase);
        int r[] = {x, y};
        return r;
    }
    
    void searchSafePlace(int[] pos) {
        int X = pos[0];
        int Y = pos[1];
        ArrayList<Tile> TileTest = new ArrayList<Tile>();
        ArrayList<Tile> TileTestBis = new ArrayList<Tile>();
        boolean safePlaceFound = false;
        TilesafeTile = new Tile();
        TileTest.clear();
        TileTest.add(tiles[Y][X]);
        
        int nb = 0;
        
        while(!safePlaceFound) {
            nb++;
            if (nb > 10) {
                break;
            }
            TileTestBis.clear();
            for (intk = 0; k < TileTest.size(); k++) {
                int aX = TileTest.get(k).i;
                int aY = TileTest.get(k).j;
                if (tiles[aY][aX].safe) {
                    safeTile = null;
                    safeTile = tiles[aY][aX];
                    safePlaceFound = true;
                    break;
                }
                if (!tiles[aY][aX + 1].expl && !tiles[aY][aX + 1].death && !tiles[aY][aX + 1].bomb && !tiles[aY][aX + 1].wall && !tiles[aY][aX + 1].dirt && !(aY == Player1.getPosition()[0] && aX + 1 == Player1.getPosition()[1])) TileTestBis.add(tiles[aY][aX + 1]);
                if (!tiles[aY][aX - 1].expl && !tiles[aY][aX - 1].death && !tiles[aY][aX - 1].bomb && !tiles[aY][aX - 1].wall && !tiles[aY][aX - 1].dirt && !(aY == Player1.getPosition()[0] && aX - 1 == Player1.getPosition()[1])) TileTestBis.add(tiles[aY][aX - 1]);
                if (!tiles[aY + 1][aX].expl && !tiles[aY + 1][aX].death && !tiles[aY + 1][aX].bomb && !tiles[aY + 1][aX].wall && !tiles[aY + 1][aX].dirt && !(aY + 1 == Player1.getPosition()[0] && aX == Player1.getPosition()[1])) TileTestBis.add(tiles[aY + 1][aX]);
                if (!tiles[aY - 1][aX].expl && !tiles[aY - 1][aX].death && !tiles[aY - 1][aX].bomb && !tiles[aY - 1][aX].wall && !tiles[aY - 1][aX].dirt && !(aY - 1 == Player1.getPosition()[0] && aX == Player1.getPosition()[1])) TileTestBis.add(tiles[aY - 1][aX]);
            }
            TileTest.clear();
            for (intk = 0; k < TileTestBis.size(); k++) {
                TileTest.add(TileTestBis.get(k));
            }
        }
        startNode = graph.getNodeAt(Player2.pos.x + 15, Player2.pos.y + 15, 0, 5);
        if (safePlaceFound == true) {
            endNode =  graph.getNodeAt(safeTile.i * largeurCase + 15, safeTile.j * largeurCase + 15, 0, 5);
            usePathFinder(pathFinder);
        }
    }
    
    void findPUp(int[] pos) {
        int X = pos[0];
        int Y = pos[1];
        
        for (intx =-  1; x <=  1; x++) {
            for (inty =-  1; y <=  1; y++) {
                if (x ==  x + y || y == x + y) {
                    if (tiles[Y + y][X + x].safe && tiles[Y + y][X + x].powerUp()) {
                        Player2.move(new PVector(x * largeurCase, y * largeurCase));
                    }
                }
            }
        }
    }
}
