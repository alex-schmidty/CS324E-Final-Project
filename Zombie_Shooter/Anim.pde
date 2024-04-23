class Anim extends Sprite{
  Anim(String frameLoader, String loc,  PVector pos, int animSpeed, float size){
    super(frameLoader, loc, pos, animSpeed, size);
  }
  
  void update(){
    if (this.timer.activated()){
      this.currentImage = (currentImage + 1);
      if(this.currentImage > numImages - 1){
        this.shouldRemove = true;
      }
      this.timer.startTimer();
    }
  }
}
