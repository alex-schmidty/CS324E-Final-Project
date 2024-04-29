import java.util.HashMap;

ArrayList<Sprite> allSprites = new ArrayList<Sprite>();
HashMap<String, ArrayList<PImage>> imgDict = new HashMap<String, ArrayList<PImage>>();

String[][] spriteInfo = {{"Zombie1" + separator + "Zombie1Walk", "Zombie1"}, 
                         {"Zombie1" + separator + "Zombie1Run", "Zombie1"}, 
                         {"Zombie1" + separator + "Zombie1_Dead", "Zombie1"},
                         {"Zombie2" + separator + "Zombie2Walk", "Zombie2"},
                         {"Zombie2" + separator + "Zombie2Run", "Zombie2"},
                         {"Zombie2" + separator + "Zombie2_Dead", "Zombie2"},
                         {"Zombie3" + separator + "Zombie3Walk", "Zombie3"},
                         {"Zombie3" + separator + "Zombie3Run", "Zombie3"},
                         {"Zombie3" + separator + "Zombie3_Dead", "Zombie3"},
                         {"PlayerIdle", "data"},
                         {"PlayerRun", "data"},
                         {"PlayerShoot", "data"},
                         {"PlayerDie", "data"}};

void loadAllSprites()
{
  for(int i =0; i< spriteInfo.length; i++)
  {
    String frameLoader = spriteInfo[i][0];
    String loc = spriteInfo[i][1];
    ArrayList<PImage> images = new ArrayList<PImage>();
    String[] lines = loadStrings(frameLoader + ".txt");
    if(!imgDict.containsKey(frameLoader))
    {
      for (int j = 0; j < lines.length; j++)
      {
        String line = lines[j];
        images.add(loadImage(loc + separator +line + ".png"));
        imgDict.put(frameLoader, images);
      }
    }
  }
}

class Sprite{
  int numImages, currentImage;
  //ArrayList<PImage> images;
  String spriteName;
  String loc;
  Timer timer;
  float size;
  boolean shouldRemove, isFacingLeft;
  PVector shift, pos;

  Sprite(String frameLoader, String loc, PVector pos, int animSpeed, float size){
    allSprites.add(this);
    this.spriteName = frameLoader;
    this.loc = loc;
    //loadImages(frameLoader, loc);
    //this.numImages = this.images.size();
    this.currentImage = 0;
    this.pos = pos;
    this.timer = new Timer(animSpeed);
    this.timer.startTimer();
    this.size = size;
    this.shouldRemove = false;
    this.isFacingLeft = false;
    //numImages = imgDict.get(this.spriteName).size();
  }
  
  //void loadImages(String frameLoader, String loc)
  //{
  //  String[] lines = loadStrings(frameLoader + ".txt");
  //  if(!imgDict.containsKey(frameLoader))
  //  {
  //    ArrayList<PImage> images = new ArrayList<PImage>();
  //    for (int i = 0; i < lines.length; i++)
  //    {
  //      String line = lines[i];
  //      images.add(loadImage(loc + separator +line + ".png"));
  //      imgDict.put(frameLoader, images);
  //    }
  //  }
  //  numImages = lines.length;
  //}
  
  void display()
  {
    pushMatrix();
    PImage img = imgDict.get(this.spriteName).get(currentImage);
    if(isFacingLeft)
    {      
      translate(this.pos.x + size*img.width/2, this.pos.y - size*img.height/2);
      scale(- this.size, this.size); 
    }
    else
    {
      translate(this.pos.x - size*img.width/2, this.pos.y - size*img.height/2);
      scale(this.size);
    }
    image(img, 0, 0);
    popMatrix();
  }
  
  void update()
  {
    if (this.timer.activated()){
      this.currentImage = (currentImage + 1) % imgDict.get(this.spriteName).size();
      this.timer.startTimer();
    }
  }
}

void displaySprites()
{
  for(int i = 0; i < allSprites.size(); i++)
  {
      allSprites.get(i).display();
  }
}
void updateSprites()
{
  for(int i = 0; i<allSprites.size(); i++)
  {
     allSprites.get(i).update();
     if(allSprites.get(i).shouldRemove){ allSprites.remove(i--); }
  }
}
