enum PlayerAnimState
{
  IDLE, RUNNING, SHOOTING;
}

public class Player {
  public Timer gunTimer;
  public float runSpeed  = 7;
  public float speedWhileShoot = 3;
  public PVector pos;
  public float pwidth = 40;
  public float pheight = 70;
  public boolean isMoving = false,
                 isMovingLeft = false,
                 isMovingRight = false,
                 isMovingUp = false,
                 isMovingDown = false,
                 isShooting = false,
                 isDead = false;
  public Timer invincibleTimer;// startTimer when invincible pause when vincible
  public int lives = 3;                 
  public int numUpdates = 0;
  Sprite sprite;
  public PlayerAnimState animState;
  
  public Player()
  {
    pos = new PVector( width/2, height-90);
    numUpdates = 0;
    gunTimer = new Timer(300);
    gunTimer.startTimer();
    this.sprite = new Sprite("PlayerIdle", pos, 200, 1.3);
    animState = PlayerAnimState.IDLE;
    invincibleTimer = new Timer(1000);
  }
  public void reset()
  {
    isDead = false;
    this.lives = 3;
    invincibleTimer.pauseTimer();
    pos = new PVector( width/2, height-90);
    pwidth = 50;
    numUpdates = 0;
    gunTimer = new Timer(400);
    gunTimer.startTimer();
    this.sprite.shouldRemove = true;
    this.sprite = new Sprite("PlayerIdle", pos, 100, 1.3);
    
  }
  public void switchSprite()
  {
    if ((this.isMovingLeft || this.isMovingRight || this.isMovingUp || this.isMovingDown) && !isShooting)
    {
      if(animState != PlayerAnimState.RUNNING)
      {
        animState = PlayerAnimState.RUNNING;
        this.sprite.shouldRemove = true;
        this.sprite = new Sprite("PlayerRun", pos, 100, 1.3);
      }
    }
    else if(isShooting)
    {
      if(animState != PlayerAnimState.SHOOTING)
      {
        animState = PlayerAnimState.SHOOTING;
        this.sprite.shouldRemove = true;
        this.sprite = new Sprite("PlayerShoot", pos, 100, 1.3);
      }
    }
    else
    {
       if(animState != PlayerAnimState.IDLE)
      {
        animState = PlayerAnimState.IDLE;
        this.sprite.shouldRemove = true;
        this.sprite = new Sprite("PlayerIdle", pos, 100, 1.3);
      }
    }
    if(isMovingLeft)
    {
      sprite.isFacingLeft = true;
    }
  }
  
  public void update()
  {
    float speed = 0;
    if(isShooting)
    {
       speed = speedWhileShoot;
       if(gunTimer.activated())
       {
          PVector bulDir = new PVector(mouseX- pos.x, mouseY - pos.y);
          bullets.add(new Bullet(pos.x, pos.y, bulDir.x, bulDir.y));
          if (settings.soundEffectsEnabled) {
            shootSound.play(); 
          }
       }
    }
    else
    {
      speed = runSpeed;
    }
    //playerType(type);
    numUpdates +=1;
    // move functionality
    if (isMovingLeft && pos.x > pwidth) { this.pos.x -= speed; }
    if (isMovingRight && pos.x < width -pwidth) { this.pos.x += speed; }
    if (isMovingUp && pos.y > pwidth) { this.pos.y -= speed;  }
    if (isMovingDown && pos.y < height-pwidth) { this.pos.y += speed;  }
    
    if(invincibleTimer.activated())
    {
      invincibleTimer.pauseTimer();
    }
  }
  public void takeDamage()
  {
    if(!invincibleTimer.running)
    {
      invincibleTimer.startTimer();
      lives-=1;
      if (settings.soundEffectsEnabled) {
        chompSound.play();
      }
    }
    if(lives<=0)
    {
      isDead = true;
      sprite.shouldRemove = true;
      if (settings.soundEffectsEnabled) {
        playerDeath.play();
      }
      new Anim("PlayerDie", player.pos.copy(), 150, 1.2, sprite.isFacingLeft);
    }
  }
}
