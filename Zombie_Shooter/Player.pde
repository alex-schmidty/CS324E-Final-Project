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
  public int type = 1;
  Sprite sprite;
  //Sprite  idleSprite = new Sprite("PlayerIdle", this.pos, 100, 1.3);
  //Sprite  runSprite = new Sprite("PlayerRun", this.pos, 100, 1.3);
  //Sprite  shootSprite = new Sprite("PlayerShoot", this.pos, 100, 1.3);
  public Player()
  {
    pos = new PVector( width/2, height-90);
    pwidth = 50;
    numUpdates = 0;
    gunTimer = new Timer(400);
    gunTimer.startTimer();
    this.sprite = new Sprite("PlayerIdle", pos, 200, 1.3);
  }
  public void reset()
  {
    isDead = false;
    pos = new PVector( width/2, height-90);
    pwidth = 50;
    numUpdates = 0;
    gunTimer = new Timer(400);
    gunTimer.startTimer();
    //playerType(1);
    this.sprite.shouldRemove = true;
    this.sprite = new Sprite("PlayerIdle", pos, 100, 1.3);
  }
  public void update()
  {
    //playerType(type);
    numUpdates +=1;
    // move functionality
    if (isMovingLeft && pos.x > pwidth) { this.pos.x -= speed; 
        type = 2;}
    if (isMovingRight && pos.x < width -pwidth) { this.pos.x += speed; 
        type = 2;}
    if (isMovingUp && pos.y > pwidth) { this.pos.y -= speed;  
        type = 2;}
    if (isMovingDown && pos.y < height-pwidth) { this.pos.y += speed;  
        type = 2;}
    if (isShooting && gunTimer.activated())
    {
      PVector bulDir = new PVector(mouseX- pos.x, mouseY - pos.y);
      bulDir = PVector.mult(bulDir.normalize(), 20);
      bullets.add(new Bullet(pos.x, pos.y, bulDir.x, bulDir.y));
      type = 3;
    }
    
    this.sprite.pos.set(pos.x, pos.y);
    
  }
  //private void playerType(int type){
  //  if(type == 1){
  //    this.sprite = idleSprite;
  //  } else if(type == 2){
  //    this.sprite = idleSprite;
  //  } else if(type == 3){
  //    this.sprite = idleSprite;
  //  }
  //}
}
