// Port of the Processing sketch BomberGame (music and network play are not included).
let temp = 0;
let state = 0;
let MouseX = 0;
let MouseY = 0;
let clicked = false;

let paused = false;
let timePaused = 0;

const largeurCase = 30;
// [row][column]: 0 grass, 2 wall, 3 grass kept clear of dirt (spawn areas)
const levelMap = [
  [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
  [2, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
  [2, 3, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2],
  [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
  [2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2],
  [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
  [2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2],
  [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
  [2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2],
  [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
  [2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 3, 2],
  [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 2],
  [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
];
let tiles = [];
let TilePool = [];

let Player1;
let Player2;
let PlayerPool = [];

const IsDirt = true;
const PowerUp = true;

let difficulty = 1500;
let sounds = true;
let restart = false;
let showFPS = true;

let oPlayer1;
let oPlayer2;

let IA;
let IAPlaying = false;

function setup() {
  createCanvas(590, 420).parent('game');
  frameRate(30);
  colorMode(HSB, 255);
  loadSettings();
  newGame();
}

// Equivalent of the Processing settings(): fresh players, overlays and saved preferences.
function loadSettings() {
  Player1 = new Player(Iperso1);
  Player2 = new Player(Iperso2);

  oPlayer1 = new Overlay(Player1, -100);
  oPlayer2 = new Overlay(Player2, 390);

  state = 0;

  const s = readSettings();
  difficulty = s.difficulty;
  sounds = s.sounds;
  showFPS = s.showFPS;
  Player1.Color = s.p1Color;
  Player2.Color = s.p2Color;
  oPlayer1.input.Text = Player1.name = s.p1Name;
  oPlayer2.input.Text = Player2.name = s.p2Name;
  oPlayer1.input.TextLength = s.p1Name.length;
  oPlayer2.input.TextLength = s.p2Name.length;

  sliderPos = map(difficulty, 1000, 2000, 0, 180);
}

// Equivalent of the Processing setup(): new random board and players back at spawn.
function newGame() {
  TilePool = [];
  PlayerPool = [];

  randomSeed(floor(random(1000000000)));

  tiles = levelMap.map(() => []);
  for (let i = 0; i < levelMap.length; i++) {
    for (let j = 0; j < levelMap.length; j++) {
      const t = new Tile(largeurCase * i, largeurCase * j);
      tiles[j][i] = t;
      t.rank();
      t.placeDirt();
      TilePool.push(t);
    }
  }

  Player1.init(largeurCase, largeurCase);
  Player2.init(11 * largeurCase, 11 * largeurCase);
  PlayerPool.push(Player1, Player2);

  makeGraph();
  startNode = getNodeAt(Player2.pos.x + 15, Player2.pos.y + 15, 10);
  endNode = getNodeAt(Player1.pos.x + 15, Player1.pos.y + 15, 10);
  usePathFinder();

  IA = new PlayerIA(Player2);
}

function draw() {
  background(0);
  translate(100, 30);
  if (!paused) temp = millis() - timePaused;
  MouseX = mouseX - 100;
  MouseY = mouseY - 30;

  menu();

  clicked = false;
}

function MsConversion(ms) {
  const seconds = floor(ms / 1000) % 60;
  const minutes = floor(ms / 60000) % 60;
  return minutes + ': ' + seconds;
}
