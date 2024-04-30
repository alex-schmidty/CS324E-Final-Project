class Anim extends Sprite{
  Anim(String frameLoader, PVector pos, int animSpeed, float size,  boolean isFacingLeft){
    super(frameLoader, pos, animSpeed, size);
    this.isFacingLeft = isFacingLeft;
  }
  
  void update(){
    if (this.timer.activated()){
      this.currentImage = (currentImage + 1);
      if(this.currentImage > imgDict.get(this.spriteName).size() - 1){
        this.shouldRemove = true;
      }
      this.timer.startTimer();
    }
  }
}
