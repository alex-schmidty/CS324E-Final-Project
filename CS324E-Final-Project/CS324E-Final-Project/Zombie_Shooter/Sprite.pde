ArrayList<Sprite> allSprites = new ArrayList<Sprite>();

class Sprite{
  int numImages, currentImage;
  ArrayList<PImage> images;
  Timer timer;
  float size;
  boolean shouldRemove, isFacingLeft;
  PVector shift, pos;

  Sprite(String frameLoader, PVector pos, int animSpeed, Float size, PVector shift){
    allSprites.add(this);
    this.images = new ArrayList<PImage>();
    loadImages(frameLoader);
    this.numImages = this.images.size();
    this.currentImage = 0;
    this.pos = pos;
    this.timer = new Timer(animSpeed);
    this.timer.reset();
    this.size = size;
    this.shouldRemove = false;
    this.shift = shift;
    this.isFacingLeft = isFacingLeft;
  }
  
  void loadImages(String frameLoader){
    String[] lines = loadStrings(frameLoader + ".txt");
    for (int i = 0; i < lines.length; i++){
      String line = lines[i];
      this.images.add(loadImage(line + ".png"));
    }
  }
  
  void display(){
    pushMatrix();
    translate(this.pos.x + shift.x, this.pos.y - shift.y);
    if(isFacingLeft)
      scale(- this.size, this.size);
    else
      scale(this.size, this.size);
    image(this.images.get(this.currentImage), 0, 0);
    popMatrix();
  }
  
  void update(){
    //this.timer.update();
    if (this.timer.activated()){
      this.currentImage = (currentImage + 1) % numImages;
      this.timer.reset();
    }
  }
}

void handleSprites(){
  for(Sprite sprite: allSprites){
    sprite.display();
    sprite.update();
  }
  for(int i = 0; i<allSprites.size(); i++){
      if(allSprites.get(i).shouldRemove){
        allSprites.remove(i--);
      }
    }
}
