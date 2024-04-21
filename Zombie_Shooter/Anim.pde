class Anim extends Sprite{
  Anim(String frameLoader, PVector pos, int animSpeed, float size){
    super(frameLoader, pos, animSpeed, size);
  }
  
  void update(){
    if (this.timer.activated()){
      this.currentImage = (currentImage + 1);
      if(this.currentImage > numImages - 1){
        this.shouldRemove = true;
      }
      this.timer.reset();
    }
  }
}
