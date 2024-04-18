class Anim extends Sprite{
  Anim(String frameLoader, PVector pos, int animSpeed, Float size, PVector shift){
    super(frameLoader, pos, animSpeed, size, shift);
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
