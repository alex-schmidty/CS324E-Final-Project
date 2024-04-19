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
int round = 0;
Player player;
Timer timer; // all classes run on the same timer that way we can start and stop the whole thing
GameStateManager gsm;

void setup() {
  size(800, 800);
  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();
  player = new Player();
  timer = new Timer(1);
  gsm = new GameStateManager();
}

void draw()
{
  gsm.updateGame();
  gsm.displayGame();  
  drawEdge();
}

void keyPressed() 
{
   // player controls
  if (key == 'a' || key == 'A' || keyCode == LEFT) {player.isMovingLeft = true; player.sprite.isFacingLeft = true;}
  else if (key == 'd' || key == 'D' || keyCode == RIGHT) {player.isMovingRight = true;  player.sprite.isFacingLeft = false;}
  else if (key == 'w' || key == 'W' || keyCode == UP) {player.isMovingUp = true; }
  else if (key == 's' || key == 'S' || keyCode == DOWN) {player.isMovingDown = true;}
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
