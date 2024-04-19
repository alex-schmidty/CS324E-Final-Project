public class Player {
  public Timer gunTimer;
  public float speed  = 5;
  public PVector pos;
  public float pwidth;
  public boolean isMovingLeft = false,
                 isMovingRight = false,
                 isMovingUp = false,
                 isMovingDown = false,
                 isShooting = false,
                 isDead = false;
                 
  public int numUpdates = 0;
  Sprite sprite;
  
  public Player()
  {
    pos = new PVector( width/2, height-90);
    pwidth = 50;
    numUpdates = 0;
    gunTimer = new Timer(400);
    gunTimer.startTimer();
    this.sprite = new Sprite("Player", pos, 200, 1.0, new PVector(-50, 50));
  }
  public void reset()
  {
    isDead = false;
    pos = new PVector( width/2, height-90);
    pwidth = 50;
    numUpdates = 0;
    gunTimer = new Timer(400);
    gunTimer.startTimer();
    this.sprite.shouldRemove = true;
    this.sprite = new Sprite("Player", pos, 200, 1.0, new PVector(-50, 50));
  }
  public void update()
  {
    numUpdates +=1;
    // move functionality
    if (isMovingLeft && pos.x > 2*pwidth) { this.pos.x -= speed; }
    if (isMovingRight && pos.x < width -pwidth) { this.pos.x += speed; }
    if (isMovingUp && pos.y > pwidth) { this.pos.y -= speed; }
    if (isMovingDown && pos.y < height-pwidth) { this.pos.y += speed; }
    if (isShooting && gunTimer.activated())
    {
      PVector bulDir = new PVector(mouseX- pos.x, mouseY - pos.y);
      bulDir = PVector.mult(bulDir.normalize(), 20);
      bullets.add(new Bullet(pos.x, pos.y, bulDir.x, bulDir.y));
    }
    
    this.sprite.pos.set(pos.x, pos.y);
    
  }
}
