import processing.net.*;
import processing.sound.*;
import pathfinder.*;

float temp;
int state;
int MouseX;
int MouseY;

boolean paused = false;
float timePaused = 0;

int largeurCase = 30;
int map[][] = { //[ligne][colonne]
    {
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2
    } ,
    {
        2,
        3,
        3,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        2
    } ,
    {
        2,
        3,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2
    } ,
    {
        2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        2
    } ,
    {
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2
    } ,
    {
        2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        2
    } ,
    {
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2
    } ,
    {
        2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        2
    } ,
    {
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2
    } ,
    {
        2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        2
    } ,
    {
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        0,
        2,
        3,
        2
    } ,
    {
        2,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        3,
        3,
        2
    } ,
    {
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2,
        2
    } ,
};
Tile[][] tiles = new Tile[map.length][map.length];
ArrayList < Tile > TilePool = new ArrayList < Tile > ();

Player Player1;
Player Player2;
ArrayList < Player > PlayerPool = new ArrayList < Player > ();

boolean IsDirt = true;
boolean PowerUp = true;

float difficulty = 1500;
boolean sounds = true;
boolean music = true;
boolean restart = false;
boolean showFPS = true;

Overlay oPlayer1;
Overlay oPlayer2;

String[] para = new String[12];

Server server;
Client client;

boolean waitingServer = false;
boolean waitingClient = false;

int SeedUsed;

Graph graph;
GraphNode[] gNodes, rNodes;
GraphEdge[] gEdges, exploredEdges;
IGraphSearch pathFinder;
GraphNode startNode, endNode;

PlayerIA IA;

boolean IAPlaying;

void settings() {
    size(590, 420);
    initImg();
    
    Player1 = new Player(Iperso1);
    Player2 = new Player(Iperso2);
    
    oPlayer1 = new Overlay(Player1, -100);
    oPlayer2 = new Overlay(Player2, 390);
    
    state = 0;
    
    String lines[] = loadStrings("Settings.txt");
    
    for (int i = 0; i < lines.length; i++) {
        para[i] = split(lines[i], '=')[1];
    }
    
    difficulty = float(para[0]);
    sounds = boolean(para[1]);
    music = boolean(para[2]);
    showFPS = boolean(para[3]);
    Player1.Color = int(para[4]);
    Player2.Color = int(para[5]);
    oPlayer1.input.Text = para[6];
    Player1.name = para[6];
    oPlayer2.input.Text = para[7];
    Player2.name = para[7];
    oPlayer1.input.TextLength = int(para[8]);
    oPlayer2.input.TextLength = int(para[9]);
    IPinput.Text = para[10];
    IPinput.TextLength = int(para[11]);
    
    sliderPos = map(difficulty, 1000, 2000, 0, 180);
}

void setup() {
    TilePool.clear();
    PlayerPool.clear();
    
    if (!networkON | waitingServer) SeedUsed = floor(random(1000000000));
    randomSeed(SeedUsed);
    if (waitingServer) server.write("-14-" + SeedUsed + "-");
    
    frameRate(30);
    colorMode(HSB);
    
    for (int i = 0; i < map.length; i++) {
        for (int j = 0; j < map.length; j++) {
            tiles[j][i] = new Tile(largeurCase * i, largeurCase * j);
            tiles[j][i].rank();
            tiles[j][i].dirt();
            TilePool.add(tiles[j][i]);
        }
    }
    
    Player1.init(largeurCase, largeurCase);
    Player2.init(int(11 * largeurCase), int(11 * largeurCase));
    PlayerPool.add(Player1);
    PlayerPool.add(Player2);
    
    graph = new Graph();
    makeGraph(graph);
    gNodes = graph.getNodeArray();
    startNode = graph.getNodeAt(Player2.pos.x + 15, Player2.pos.y + 15, 0, 10);
    endNode = graph.getNodeAt(Player1.pos.x + 15, Player1.pos.y + 15, 0, 10);
    graph.compact();
    gEdges = graph.getAllEdgeArray();
    pathFinder = makePathFinder(graph);
    usePathFinder(pathFinder);
    
    IA = new PlayerIA(Player2);
}


void draw() {
    clear();
    translate(100, 30);
    if (!paused) temp = millis() - timePaused;
    menu();
    
    MouseX = mouseX - 100;
    MouseY = mouseY - 30;
    
    if (int(temp) % 10 >= 8) {
        if (!playing() && music) {
            int p = int(random(0, 7.99));
            if (!playing()) Music.get(p).play();
        }
    }
    if (playing() && !music) {
        for (int k = 0; k < Music.size(); k++) {
            Music.get(k).stop();
        }
    }
}

String MsConversion(int MS) {
    int seconds = (MS / 1000) % 60;
    int minutes = (MS / (1000 * 60)) % 60;
    
    return minutes + ": " + seconds;
}