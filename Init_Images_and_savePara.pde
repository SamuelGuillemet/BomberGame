PImage Ibomb;
PImage Iwall;
PImage Idirt;
PImage Igrass;
PImage IexpHaut;
PImage IexpGauche;
PImage IexpCentre;
PImage IexpDroite;
PImage IexpBas;
PImage Iflame;
PImage Iinvincibility;
PImage Ideath;
PImage Ibombeup;
PImage Ivertical;
PImage Ihorizontal;
PImage IfeetBomb;

PImage Iheader;
PImage IenterMenu;
PImage IselectPerso;
PImage Iwin;
PImage Iperso1;
PImage Iperso2;

PFont overlay;
PFont win;
PFont menu;


SoundFile Sdeath;
SoundFile SpowerUp;
SoundFile SbombPos;
SoundFile Sexpl;
SoundFile Sclick;

SoundFile Music1;
SoundFile Music2;
SoundFile Music3;
SoundFile Music4;
SoundFile Music5;
SoundFile Music6;
SoundFile Music7;
SoundFile Music8;

ArrayList < SoundFile > Music = new ArrayList < SoundFile > ();


void initImg() {
    Iwall = loadImage("blocdur.jpg");
    Idirt = loadImage("blocmou.jpg");
    Igrass = loadImage("blocGrass.jpg");
    
    Ibomb = loadImage("Bomb1.jpg");
    IexpHaut = loadImage("Haut.png");
    IexpGauche = loadImage("Gauche.png");
    IexpCentre = loadImage("ExplCentre.png");
    IexpDroite = loadImage("Droite.png");
    IexpBas = loadImage("Bas.png");
    Ihorizontal = loadImage("Horizontal.png");
    Ivertical = loadImage("Vertical.png");
    
    Iflame = loadImage("FlameUp.jpg");
    Iinvincibility = loadImage("Invincibility.jpg");
    Ideath = loadImage("PowerFULL.jpg");
    Ibombeup = loadImage("BombUp.jpg");
    IfeetBomb = loadImage("FootBomb.jpg");
    
    Iheader = loadImage("Header.png");
    IenterMenu = loadImage("Menu.png");
    IselectPerso = loadImage("SelectionPersonnageVide.png");
    Iwin = loadImage("GameOver.png");
    Iperso1 = loadImage("Perso.png");
    Iperso2 = loadImage("Perso.png");
    
    
    overlay = loadFont("SWIsop3-42.vlw");
    win = loadFont("ProcessingSansPro-Semibold-25.vlw");
    menu = loadFont("TrebuchetMS-48.vlw");
    
    for (int k = 0; k < Music.size(); k++) {
        Music.get(k).stop();
    }
    
    Music1 = null;
    Music2 = null;
    Music3 = null;
    Music4 = null;
    Music5 = null;
    Music6 = null;
    Music7 = null;
    Music8 = null;
    
    Sdeath = new SoundFile(this, "Death.wav");
    SpowerUp = new SoundFile(this, "PowerUp.wav");
    SbombPos = new SoundFile(this, "BombPos.wav");
    Sexpl = new SoundFile(this, "Expl.wav");
    Sclick = new SoundFile(this, "Click.wav");
    
    Music1 = new SoundFile(this, "Music1.wav");
    Music2 = new SoundFile(this, "Music2.wav");
    Music3 = new SoundFile(this, "Music3.wav");
    Music4 = new SoundFile(this, "Music4.wav");
    Music5 = new SoundFile(this, "Music5.wav");
    Music6 = new SoundFile(this, "Music6.wav");
    Music7 = new SoundFile(this, "Music7.wav");
    Music8 = new SoundFile(this, "Music8.wav");
    
    
    Music.clear();
    
    Music.add(Music1);
    Music.add(Music2);
    Music.add(Music3);
    Music.add(Music4);
    Music.add(Music5);
    Music.add(Music6);
    Music.add(Music7);
    Music.add(Music8);
    
    for (int k = 0; k < Music.size(); k++) {
        Music.get(k).amp(0.1);
    }
    
    Sexpl.amp(0.3);
}

void savePara() {
    para[0] = str(difficulty);
    para[1] = str(sounds);
    para[2] = str(music);
    para[3] = str(showFPS);
    para[4] = str(Player1.Color);
    if (!IAPlaying) para[5] = str(Player2.Color);
    para[6] = Player1.name;
    if (!IAPlaying) para[7] = Player2.name;
    para[8] = str(oPlayer1.input.TextLength);
    if (!IAPlaying) para[9] = str(oPlayer2.input.TextLength);
    para[10] = IPinput.Text;
    para[11] = str(IPinput.TextLength);
    
    String lines[] = loadStrings("Settings.txt");
    for (int i = 0; i < lines.length; i++) {
        if (para[i] != null) lines[i] = split(lines[i], '=')[0] + "=" + para[i];
    }
    saveStrings("/data/Settings.txt", lines);
}

boolean playing() {
    for (int k = 0; k < Music.size(); k++) {
        if (Music.get(k).isPlaying()) return true;
    }
    return false;
}
