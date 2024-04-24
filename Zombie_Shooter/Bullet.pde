public class Bullet
{
  public static final float SPEED = 40;
  public static final float _RADIUS = 4;
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
    vel.normalize();
    pos.add(vel.mult(SPEED));
    if (pos.y < 0 || pos.y> height || pos.x<0 || pos.x>width){ shouldRemove = true;}
  }
  public void display()
  {
    ellipseMode(RADIUS);
    noStroke();
    fill(230, 100, 40);
    ellipse(pos.x, pos.y, _RADIUS, _RADIUS);
  }
}
