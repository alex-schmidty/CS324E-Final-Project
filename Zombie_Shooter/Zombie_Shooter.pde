import processing.sound.*;
import g4p_controls.*;

// adding sound 
SoundFile shootSound;
SoundFile zombieSound; 

// gui buttons 
GTextField nameInput;
GButton saveButton;
GButton skipButton;

// Game States
public enum State
{
  START, PLAYING, WON, LOST;   
}

// variables that all classes need
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
boolean playing  = false;
int killcount = 0;
int killcntmax = 0;
Player player;
Reticle reticle;
Timer timer; // all classes run on the same timer that way we can start and stop the whole thing
GameStateManager gsm;
boolean paused = false;
Leaderboard leaderboard;
String playerName;
PGraphics bb; // background buffer


void setup() {
  fullScreen();
  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();
  player = new Player();
  reticle = new Reticle(player);
  timer = new Timer(1);
  gsm = new GameStateManager();
  shootSound = new SoundFile(this, "./shootSound.mp3");
  zombieSound = new SoundFile(this, "./zombieSound.mp3");
  leaderboard = new Leaderboard();
  leaderboard.loadFromFile("leaderboard.txt");
  playerName = "Player" + leaderboard.getLeaderboardSize(); // Generate a default name  
  createBackground();
}

void draw()
{
  gsm.displayGame(); 
  gsm.updateGame();
  drawEdge();
  if (paused) {
      rect(0, 0, width, height);
      fill(255, 0, 0);
      textSize(50);
      text("Paused", width/2, height/2);
      fill(255);
      textSize(25);
      text("Press P to resume", width/2, height/15 + 30);
    }
    playerName = "Player" + leaderboard.getLeaderboardSize(); // Generate a default name
}

void keyPressed() 
{
   // player controls
  if (key == 'a' || key == 'A' || keyCode == LEFT) {player.isMovingLeft = true; player.sprite.isFacingLeft = true;}
  else if (key == 'd' || key == 'D' || keyCode == RIGHT) {player.isMovingRight = true;  player.sprite.isFacingLeft = false;}
  else if (key == 'w' || key == 'W' || keyCode == UP) {player.isMovingUp = true; }
  else if (key == 's' || key == 'S' || keyCode == DOWN) {player.isMovingDown = true;}
  
  // Simulate adding a player to the leaderboard when a key is pressed (for testing purposes)
  if (key == 'l') {
    String playerName = "Player " + leaderboard.getLeaderboardSize(); // Generate a default name
    int playerScore = (int) random(100); // Generate a random score
    leaderboard.addEntry(playerName, playerScore);
    leaderboard.saveToFile("leaderboard.txt");
  }
  
  
}
void keyReleased() {
  if (key == 'a' || key == 'A' || keyCode == LEFT){player.isMovingLeft = false;}
  else if (key == 'd' || key == 'D' || keyCode == RIGHT) {player.isMovingRight = false;}
  else if (key == 'w' || key == 'W' || keyCode == UP) {player.isMovingUp = false; }
  else if (key == 's' || key == 'S' || keyCode == DOWN) {player.isMovingDown = false;}
  else if (key == ' ' ) {player.isShooting = false;}
}
void mousePressed()
{
    {player.isShooting = true;}
}
void mouseReleased()
{
    {player.isShooting = false;}
}

void drawEdge(){
  rectMode(CORNER);
  stroke(255,155,72);
  fill(0,0,0,0);
  strokeWeight(4);
  rect(2, 2, width - 4, height - 4);
  strokeWeight(1);
  stroke(0);
  fill(0);
}
void createBackground()
{
  PImage grass = loadImage("grass_tile.png");
  bb = createGraphics(width, height);
  bb.beginDraw();
  bb.pushMatrix();
  bb.scale(.2);
  for(int i = 0; i<9; i++)
  {
    for(int j = 0; j<5; j++)
    {
      bb.image(grass, i*grass.width, j*grass.height);
    }
  }
  bb.popMatrix();
  bb.endDraw();
  
  
}
