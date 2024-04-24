public class GameStateManager
{
  public State state;
  public PImage logo;
  public int round = 1;
  public int difficulty;
  public boolean pKeyPressed = false; // add a flag to check if p has already been pressed in the current frame
  private boolean displayLeaderboard = false;
  public boolean top10; 

  public GameStateManager()
  {
    this.state= State.START;
    logo = loadImage("./ZOMBIE-ATTACK.png");
  }
  public void displayGame()
  {
    image(bb,0,0);
    //display everything
    for (Bullet bullet : bullets)
    {
      bullet.display();
    }
    displaySprites();
    switch(state)
    {
    case START:
      textAlign(CENTER, CENTER);
      textSize(50);
      fill(255);
      image(logo, width/2 - logo.width/2, 15);
      textAlign(CENTER, CENTER);
      textSize(30);
      fill(255, 0, 0);
      text("Quit", 40, 30);
      if (mouseX > 15 && mouseY > 15 && mouseX < 65 && mouseY < 45) {
        rect(15, 15, 50, 30);
        fill(0);
        text("Quit", 40, 30);
      }
      fill(170, 255, 255);
      text("Select difficulty:", width/2, height/2 - 100);

      int padding = 50; // Adjust padding as needed

      // Display difficulty options
      for (int i = 1; i <= 5; i++)
      {
        int x = width/2 + (i-3)*padding + padding/2 - 25; // add padding around the numbers
        if (
          mouseX > x - padding/2 &&
          mouseX < x + padding/2 &&
          mouseY > height/2 - padding/2 &&
          mouseY < height/2 + padding/2) {
          fill(0, 255, 0); //highlight
        } else {
          fill(170, 255, 255);;
        }
        text(i, x, height/2); //display number
        fill(255);
      }
      
      // display leaderboard 
      if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height/2 + 75 && mouseY < height/2 + 125) {
        fill(0, 255, 0); // Highlight when hovering
      } else {
        fill(255);
      }
      text("Leaderboard", width/2, height/2 + 100);
      
      
      if (killcntmax != 0)
      {
        fill(255, 0, 0);
        textSize(30);
        text("Kill Count High Score: " + killcntmax, width/2, height/2 + 375);
      }
      fill(70, 70, 175);
      text("Hold 'C' to see controls", width/2, height/2 +200);
      if (keyPressed && key == 'c' || key =='C' )
      {
        rectMode(CENTER);
        rect(width/2, height/2+250, 300, 175);
        fill(0);
        textAlign(CENTER);
        textSize(25);
        text("Move Up: 'W' or UP arrow key", width/2, height/2+200);
        text("Move Left: 'A' or LEFT arrow key", width/2, height/2+230);
        text("Move Down: 'S' or DOWN arrow key", width/2, height/2+260);
        text("Move Right: 'D' or RIGHT arrow key", width/2, height/2+290);
        text("Shoot: Point and click mouse", width/2, height/2+320);
        fill(255);
      }
      
       if (displayLeaderboard) {
        leaderboard.display();
      }
      break;
    case PLAYING:
      fill(255);
      textSize(25);
      text("Round " +round, width/2, height-15);
      if (killcount != 0)
      {
        textSize(17);
        text("Kill Count:  " + killcount, width-100, height -15);
      }
      break;
    case WON:
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("YOU WIN!", width/2, height/2- 50);
      textSize(20);
      text("Press R to reset or Q to quit", width/2, height/2 + 50);
      if (leaderboard.top10()) {
        text("Congratulations! You made it to the leaderboard " + playerName, width/2, height/2 + 100);
      }
      break;
    case LOST:
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("GAME OVER!", width/2, height/2- 50);
      textSize(20);
      text("Press R to reset or Q to quit", width/2, height/2 + 50);
      if (leaderboard.top10()) {
        text("Congratulations! You made it to the leaderboard " + playerName, width/2, height/2 + 100);
      }
      break;
    }
    
  }
  public void updateGame()
  {
    switch(state)
    {
    case START:
      if (mousePressed)
      {
        if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height/2 + 75 && mouseY < height/2 + 125) {
          displayLeaderboard = true; 
        }
        // undisplays the leaderboard
        else if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 225 && mouseY < height/2 + 275){
          displayLeaderboard = false; 
        }
        else if (mouseX > 15 && mouseY > 15 && mouseX < 65 && mouseY < 45) {
          exit();
        }
        for (int i = 1; i <= 5; i++)
        {
          int padding = 50; // Adjust padding as needed
          int x = width/2 + (i-3)*padding + padding/2 - 25; // add padding around the numbers
          if (mouseX > x - padding/2 &&
            mouseX < x + padding/2 &&
            mouseY > height/2 - padding/2 &&
            mouseY < height/2 + padding/2)
          {
            state = State.PLAYING;
            difficulty = i;
            player.pos = new PVector(width/2, height/2);
            timer.startTimer();
            createEnemies(difficulty*3);
            break;
          }
        }
      }
      break;

    case PLAYING:

      // Check if the 'P' key is pressed and the pause toggle flag is false
      if (keyPressed && (key == 'p' || key == 'P') && !pKeyPressed) {
        // Toggle pause state
        paused = !paused;
        // Pause or start the timer accordingly
        if (paused) {
          timer.pauseTimer();
        } else {
          timer.startTimer();
        }
        // Update the flag to indicate that the key has been pressed in this frame
        pKeyPressed = true;
      }

      // Reset the flag when the key is released
      if (!keyPressed && (key == 'p' || key == 'P')) {
        pKeyPressed = false;
      }

      if (!paused) {
        if (timer.activated())
        {
          // update player
          player.switchSprite();
          player.update();
          reticle.createRet();
          // update bullets
          for (Bullet bullet : bullets) {
            bullet.update();
          }
          //update enemies
          for (Enemy enemy : enemies) {
            enemy.update();
          }
          // remove bullets
          for (int i = 0; i<bullets.size(); i++) {
            if (bullets.get(i).shouldRemove) {
              bullets.remove(i--);
            }
          }
          // remove enemies
          for (int i = 0; i<enemies.size(); i++) {
            if (enemies.get(i).hitBullet) {
              enemies.remove(i--);
            }
          }

          // Lose condition
          if (player.isDead)
          {
            timer.pauseTimer();
            state = State.LOST;
          }

          // advance to next round
          if (enemies.size() ==  0)
          {
            round +=1;
            createEnemies(round*difficulty*3);

            //win condition
            if (round > 30)
            {
              timer.pauseTimer();
              state=State.WON;
            }
          }
        }
      }
      break;
    case WON: // treats WON and LOST the same
    case LOST:
      if (keyPressed && key == 'r'|| key =='R') {
        resetGame();
      }
      if (keyPressed && key == 'q'|| key =='Q') {
        resetGame();
        exit();
      }
      break;
    }
    updateSprites();
  }

  public void resetGame()
  {
    leaderboard.addEntry(playerName, killcount);
    leaderboard.saveToFile("leaderboard.txt");
    
    player.reset();
    bullets.clear();
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.sprite.shouldRemove = true;
      enemies.remove(i);
    }
    killcntmax = max(killcount, killcntmax);
    killcount = 0;
    state = State.START;
    round = 0;
    top10 = false; 
  }
}
