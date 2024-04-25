class Reticle {
  Player player;
  float pWidth = 50 , pHeight = 100;
  
  Reticle(Player player){
    this.player = player;
  }
  
  void createRet(){
        float playerY = player.pos.y;
        float playerX = player.pos.x;
        float angle = atan2(mouseY - playerY, mouseX - playerX);
        float arrowX = playerX + cos(angle) * (pWidth / 2 + 30);
        float arrowY = playerY + sin(angle) * (pHeight / 2 + 30);        
        
        stroke(255, 0, 0);
        strokeWeight(3);
        float lineAngle1 = angle + 7*PI/6;
        float lineEndX1 = arrowX + cos(lineAngle1) * 10;
        float lineEndY1 = arrowY + sin(lineAngle1) * 10;
        line(arrowX, arrowY, lineEndX1, lineEndY1);
        
        float lineAngle2 = angle + 5*PI/6; 
        float lineEndX2 = arrowX + cos(lineAngle2) * 10;
        float lineEndY2 = arrowY + sin(lineAngle2) * 10;
        line(arrowX, arrowY, lineEndX2, lineEndY2);      
  }
}
