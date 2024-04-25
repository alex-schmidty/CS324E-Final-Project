public class Timer
{
  boolean running;
  float lastCheck;
  float activationTime;
  
  public Timer(float activationTime)
  {
    this.activationTime = activationTime;
    lastCheck = millis();
  }
  public void startTimer(){ running = true; lastCheck = millis(); }
  
  public void pauseTimer(){ running = false; lastCheck = millis(); }
  
  public boolean activated()
  {
    if (running)
    {
      float millis = millis();
      if(millis - lastCheck >= activationTime)
      {
        lastCheck = millis;
        return true;
      }
      else return false;
    }
    else return false;
  }
  
}
