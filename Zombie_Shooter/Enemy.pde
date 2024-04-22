public class Enemy
{
  public PVector pos;
  public float ewidth = 50;
  public float eheight = 100;
  public PVector vel;
  public float speed;
  public boolean hitBullet = false;
  public boolean hitPlayer = false;
  public boolean isDead = false;
  public Sprite sprite;
  public Enemy(float x, float y, int type)
  {
    this.pos = new PVector(x,y);
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
      player.isDead = true;
      player.sprite.shouldRemove = true;
      new Anim("Explosion", player.pos.copy(), 100, .6);
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
        && b.pos.y<=pos.y+eheight/2 && b.pos.y>= pos.y-eheight/2 )
      {
        killcount +=1;
        b.shouldRemove = true;
        this.sprite.shouldRemove = true;
        new Anim("Explosion", this.pos.copy(), 100, .6);
        hitBullet =true;
        break;
      }
      }
    }
    
  }
  
  private void enemyType(int type){
    if(type == 1){
      this.sprite = new Sprite("Zombie1Walk", this.pos, 100, .3);
      speed = 2;
    } else if(type == 2){
      this.sprite = new Sprite("Zombie1", this.pos, 100, .3);
      speed = 4;
    }
  }
  
  public boolean collidingWithPlayer()
  {
    PVector[] ePoints = {new PVector(pos.x-ewidth/2, pos.y - eheight/2),
                         new PVector(pos.x+ewidth/2, pos.y - eheight/2), 
                         new PVector(pos.x-ewidth/2, pos.y + eheight/2), 
                         new PVector(pos.x+ewidth/2, pos.y + eheight/2)};
    PVector[] pPoints = {new PVector(player.pos.x-player.pwidth/2, player.pos.y-player.pwidth/2),
                         new PVector(player.pos.x+player.pwidth/2, player.pos.y-player.pwidth/2), 
                         new PVector(player.pos.x-player.pwidth/2, player.pos.y+player.pwidth/2),
                         new PVector(player.pos.x+player.pwidth/2, player.pos.y+player.pwidth/2)};
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
  //ArrayList<Float> xpos = new ArrayList<Float>();
  //xpos.add(0.0);
  //float middle = width/2;
  //xpos.add(middle);
  //float end = width;
  //xpos.add(end);
  //ArrayList<Float> ypos = new ArrayList<Float>();
  //ypos.add(0.0);
  //float middley = width/2;
  //ypos.add(middley);
  //float endy = width;
  //ypos.add(endy);
  
  //for(int i=0; i<num; i++)
  //{
  //  int randomxpos = int(random(3));
  //  int randomypos = int(random(3));
  //  Enemy e= new Enemy(xpos.get(randomxpos), ypos.get(randomypos), ceil(random(2)));
  //  e.vel = new PVector(0,random(.8,2.3));
  //  enemies.add(e);
  //}
  for(int i=0; i<num; i++)
  {
    float x = random(-100, width+100);
    float y = 0;
    if( x<= 0 || x>=width)
    {
      y = random(-100, height+100);
    }
    else
    {
      if((int)random(2) == 1)
      {
        y = random(-100,0); 
      }
      else
      {
        y = random(height,height+100);
      }
      
    }
    
    enemies.add(new Enemy(x,y, ceil(random(2))));
  }
}
