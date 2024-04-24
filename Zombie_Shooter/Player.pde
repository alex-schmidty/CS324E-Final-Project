public class Player {
  public Timer gunTimer;
  public float speed  = 5;
  public PVector pos;
  public float pwidth = 50;
  public float pheight = 80;
  public boolean isMoving = false,
                 isMovingLeft = false,
                 isMovingRight = false,
                 isMovingUp = false,
                 isMovingDown = false,
                 isShooting = false,
                 isDead = false;
  public int lives = 3;                 
  public int numUpdates = 0;
  public int prevState = 0; // 0 for idle, 1 for moving, 2 for moving +shooting
  Sprite sprite;
  public Player()
  {
    pos = new PVector( width/2, height-90);
    numUpdates = 0;
    gunTimer = new Timer(300);
    gunTimer.startTimer();
    this.sprite = new Sprite("PlayerIdle", "data", pos, 200, 1.3);
  }
  public void reset()
  {
    isDead = false;
    this.lives = 3;
    pos = new PVector( width/2, height-90);
    pwidth = 50;
    numUpdates = 0;
    gunTimer = new Timer(400);
    gunTimer.startTimer();
    this.sprite.shouldRemove = true;
    this.sprite = new Sprite("PlayerIdle", "data", pos, 100, 1.3);
  }
  public void switchSprite(){
    if (!this.isMovingLeft && !this.isMovingRight && !this.isMovingUp && !this.isMovingDown){
      this.isMoving = false;
    }
    if (prevState != 1 && this.isMoving){ this.sprite.shouldRemove = true; 
        this.sprite = new Sprite("PlayerRun", "data", this.pos, 100, 1.3);
        prevState = 1;}
      if (this.isShooting){this.sprite.shouldRemove = true; 
        this.sprite = new Sprite("PlayerShoot", "data", this.pos, 100, 1.3);
        prevState = 2;
      }
    
      else if(prevState != 0 && !this.isMoving) { 
         this.sprite.shouldRemove = true; 
         this.sprite = new Sprite("PlayerIdle", "data", this.pos, 100, 1.3);
         prevState = 0;
      }
    }
  
  public void update()
  {
    //playerType(type);
    numUpdates +=1;
    // move functionality
    if (isMovingLeft && pos.x > pwidth) { this.pos.x -= speed; }
    if (isMovingRight && pos.x < width -pwidth) { this.pos.x += speed; }
    if (isMovingUp && pos.y > pwidth) { this.pos.y -= speed;  }
    if (isMovingDown && pos.y < height-pwidth) { this.pos.y += speed;  }
    if (isShooting && gunTimer.activated())
    {
      PVector bulDir = new PVector(mouseX- pos.x, mouseY - pos.y);
      bullets.add(new Bullet(pos.x, pos.y, bulDir.x, bulDir.y));

      shootSound.play(); 
      
    }
    
    this.sprite.pos.set(pos.x, pos.y);
    
  }
}
