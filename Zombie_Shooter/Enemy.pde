public class Enemy
{
  public static final float ZOMBIE_SCALE = .27;
  public PVector pos;
  public float ewidth = 50;
  public float eheight = 100;
  public PVector vel;
  public float speed;
  public boolean hitBullet = false;
  public boolean hitPlayer = false;
  public boolean isDead = false;
  public Sprite sprite;
  public int type;
  public Enemy(float x, float y, int type)
  {
    this.pos = new PVector(x,y);
    this.type = type;
    enemyType(type);
    this.vel = new PVector(1,0);
  }
  
  public void update()
  {
        
    vel = PVector.sub(player.pos, this.pos);
    vel = PVector.mult(vel.normalize(), speed);
    if(player.pos.x< pos.x) {sprite.isFacingLeft = true; }
    else {sprite.isFacingLeft = false;}
    if(collidingWithPlayer())
    { 
      player.takeDamage();
    }
    if(!isDead)
    {
      pos.add(vel);
      if(pos.x< 50 || pos.x >width - 50){
        vel.x *=-1;
    }
      for(Bullet b: bullets)
      {
        if(b.pos.x<=pos.x+ewidth/2 && b.pos.x>= pos.x-ewidth/2
          && b.pos.y<=pos.y+eheight/2 && b.pos.y>= pos.y-eheight/2 && !b.shouldRemove)
        {
          if (settings.soundEffectsEnabled) {
            zombieSound.play();
          }
          killcount +=1;
          b.shouldRemove = true;
          this.sprite.shouldRemove = true;
          if(type ==1)
            new Anim("Zombie1" + separator + "Zombie1_Dead", this.pos.copy(), 100, ZOMBIE_SCALE, sprite.isFacingLeft);
          else if(type ==2)
            new Anim("Zombie2" + separator + "Zombie2_Dead", this.pos.copy(), 100, ZOMBIE_SCALE, sprite.isFacingLeft);
           else if(type ==3)
            new Anim("Zombie3" + separator + "Zombie3_Dead", this.pos.copy(), 100, ZOMBIE_SCALE, sprite.isFacingLeft);
          hitBullet =true;
          break;
        }
      }
    }
    
  }
  
  private void enemyType(int type)
  {  
    if(type == 1)
    {
      if(random(2)>1)
      {
        this.sprite = new Sprite("Zombie1" + separator + "Zombie1Walk",  this.pos, 100, ZOMBIE_SCALE);
        speed = 2;
      }
      else
      {
        this.sprite = new Sprite("Zombie1" + separator + "Zombie1Run", this.pos, 100, ZOMBIE_SCALE);
        speed = 4;
      }
      
    } else if(type == 2){
      if(random(2)>1)
      {
        this.sprite = new Sprite("Zombie2" + separator + "Zombie2Walk", this.pos, 100, ZOMBIE_SCALE);
        speed = 2;
      }
      else
      {
        this.sprite = new Sprite("Zombie2" + separator + "Zombie2Run", this.pos, 100, ZOMBIE_SCALE);
        speed = 4;
      }
    } else if(type == 3){
      if(random(2)>1)
      {
        this.sprite = new Sprite("Zombie3" + separator + "Zombie3Walk", this.pos, 100, ZOMBIE_SCALE);
        speed = 2;
      }
      else
      {
        this.sprite = new Sprite("Zombie3" + separator + "Zombie3Run", this.pos, 100, ZOMBIE_SCALE);
        speed = 4;
      }
    }
  }
  
  public boolean collidingWithPlayer()
  {
    PVector[] ePoints = {new PVector(pos.x-ewidth/2, pos.y - eheight/2),
                         new PVector(pos.x+ewidth/2, pos.y - eheight/2), 
                         new PVector(pos.x-ewidth/2, pos.y + eheight/2), 
                         new PVector(pos.x+ewidth/2, pos.y + eheight/2)};
    PVector[] pPoints = {new PVector(player.pos.x-player.pwidth/2, player.pos.y-player.pheight/2),
                         new PVector(player.pos.x+player.pwidth/2, player.pos.y-player.pheight/2), 
                         new PVector(player.pos.x-player.pwidth/2, player.pos.y+player.pheight/2),
                         new PVector(player.pos.x+player.pwidth/2, player.pos.y+player.pheight/2)};
    //check if enemy points inside player
    for(int i =0; i<ePoints.length; i++)
    {
      if(ePoints[i].x >= pPoints[0].x && ePoints[i].x<=pPoints[1].x
      && ePoints[i].y >= pPoints[0].y && ePoints[i].y<=pPoints[2].y)
      return true;
    }
    // check if player points inside enemy
    for(int i =0; i<pPoints.length; i++)
    {
      if(pPoints[i].x >= ePoints[0].x && pPoints[i].x<=ePoints[1].x
      && pPoints[i].y >= ePoints[0].y && pPoints[i].y<=ePoints[2].y)
        return true;
    }
    return false;
  }
}

void createEnemies(int num){

  for(int i=0; i<num; i++)
  {
    float x = 0;
    float y = 0;
    int side = ceil(random(4));
    int PADDING = 200;
    switch(side)
    {
      case 1: // top
         x = random(-PADDING, width+PADDING);
         y = random(-PADDING,0); 
      break;
      case 2: // bottom
         x = random(-PADDING, width+PADDING);
         y = random(height,height+PADDING);
      break;
      case 3: // left
         x = random(-PADDING, 0);
         y = random(-PADDING, height+PADDING);
      break;
      case 4: // right
         x = random(width, width+PADDING);
         y = random(-PADDING, height+PADDING);
      break;
    }
    enemies.add(new Enemy(x,y, ceil(random(3))));
  }
}
