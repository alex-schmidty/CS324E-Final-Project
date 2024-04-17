public class Bullet
{
  //public static final float _SPEED = 20;
  public static final float _RADIUS = 5;
  public PVector pos;
  public PVector vel;
  public boolean shouldRemove = false;
  public Bullet(float x, float y, float vx, float vy)
  {
    this.pos = new PVector(x,y);
    this.vel = new PVector(vx,vy);
  }
  public void update()
  {
    pos.add(vel);
    if (pos.y < 0 || pos.y> height || pos.x<0 || pos.x>width){ shouldRemove = true;}
  }
  public void display()
  {
    ellipseMode(RADIUS);
    noStroke();
    fill(255);
    ellipse(pos.x, pos.y, _RADIUS, _RADIUS);
  }
}
