let Ibomb, Iwall, Idirt, Igrass;
let IexpHaut, IexpGauche, IexpCentre, IexpDroite, IexpBas, Ivertical, Ihorizontal;
let Iflame, Iinvincibility, Ideath, Ibombeup, IfeetBomb;
let Iheader, IenterMenu, IselectPerso, Iwin, Iperso1, Iperso2;

let Sdeath, SpowerUp, SbombPos, Sexpl, Sclick;

// .vlw fonts cannot be used in the browser: system fonts are used instead
// (p5 quotes the name, so fallback lists are not possible).
const FONT_OVERLAY = 'Verdana';
const FONT_WIN = 'Arial';
const FONT_MENU = 'Trebuchet MS';

const SETTINGS_KEY = 'bombergame.settings';
const DEFAULT_SETTINGS = {
  difficulty: 1500,
  sounds: true,
  showFPS: false,
  p1Color: 139,
  p2Color: 146,
  p1Name: '',
  p2Name: '',
};

function preload() {
  Iwall = loadImage('assets/blocdur.jpg');
  Idirt = loadImage('assets/blocmou.jpg');
  Igrass = loadImage('assets/blocGrass.jpg');

  Ibomb = loadImage('assets/Bomb1.jpg');
  IexpHaut = loadImage('assets/Haut.png');
  IexpGauche = loadImage('assets/Gauche.png');
  IexpCentre = loadImage('assets/ExplCentre.png');
  IexpDroite = loadImage('assets/Droite.png');
  IexpBas = loadImage('assets/Bas.png');
  Ihorizontal = loadImage('assets/Horizontal.png');
  Ivertical = loadImage('assets/Vertical.png');

  Iflame = loadImage('assets/FlameUp.jpg');
  Iinvincibility = loadImage('assets/Invincibility.jpg');
  Ideath = loadImage('assets/PowerFULL.jpg');
  Ibombeup = loadImage('assets/BombUp.jpg');
  IfeetBomb = loadImage('assets/FootBomb.jpg');

  Iheader = loadImage('assets/Header.png');
  IenterMenu = loadImage('assets/Menu.png');
  IselectPerso = loadImage('assets/SelectionPersonnageVide.png');
  Iwin = loadImage('assets/GameOver.png');
  Iperso1 = loadImage('assets/Perso.png');
  Iperso2 = Iperso1;

  Sdeath = loadSfx('assets/Death.wav');
  SpowerUp = loadSfx('assets/PowerUp.wav');
  SbombPos = loadSfx('assets/BombPos.wav');
  Sexpl = loadSfx('assets/Expl.wav', 0.3);
  Sclick = loadSfx('assets/Click.wav');
}

function loadSfx(path, volume = 1) {
  const audio = new Audio(path);
  audio.preload = 'auto';
  audio.volume = volume;
  return {
    play() {
      audio.currentTime = 0;
      audio.play().catch(() => {});
    },
    isPlaying() {
      return !audio.paused && !audio.ended;
    },
  };
}

function readSettings() {
  let stored = {};
  try {
    stored = JSON.parse(localStorage.getItem(SETTINGS_KEY)) || {};
  } catch (e) {
    stored = {};
  }
  const s = { ...DEFAULT_SETTINGS };
  for (const k in DEFAULT_SETTINGS) {
    if (typeof stored[k] === typeof DEFAULT_SETTINGS[k]) s[k] = stored[k];
  }
  return s;
}

function savePara() {
  const s = readSettings();
  s.difficulty = difficulty;
  s.sounds = sounds;
  s.showFPS = showFPS;
  s.p1Color = Player1.Color;
  s.p1Name = Player1.name;
  if (!IAPlaying) {
    s.p2Color = Player2.Color;
    s.p2Name = Player2.name;
  }
  try {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(s));
  } catch (e) {
    // Storage unavailable (private mode): settings are simply not kept.
  }
}

function hexA(hex, alpha) {
  const c = color(hex);
  c.setAlpha(alpha);
  return c;
}
