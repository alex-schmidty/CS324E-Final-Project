// Game States
public enum GameState
{
  START, PLAYING, WON, LOST;
}
public class GameStateManager extends Thread
{

  public GameState state;
  public PImage logo;
  public PImage headstone;
  public PImage heart;
  public int round = 1;
  public int difficulty;
  public boolean pKeyPressed = false; // add a flag to check if p has already been pressed in the current frame
  private boolean displayLeaderboard = false;
  private boolean displaySettings = false; 
  public boolean top10;

  public GameStateManager()
  {
    this.state= GameState.START;
    logo = loadImage("./ZOMBIE-ATTACK.png");
    headstone = loadImage("./headstoneMain.png");
    heart = loadImage("./heart.png");
  }
  public void displayGame()
  {
    image(bb, 0, 0);
    //display everything
    for(int i = 0; i< bullets.size(); i++)
    {
      bullets.get(i).display();
    }
    displaySprites();
    switch(state)
    {
    case START:
      displayStart();

      if (displayLeaderboard) {
        leaderboard.display();
      }
      if (displaySettings) {
        settings.display();
      }
      break;
    case PLAYING:
      fill(255);
      textSize(25);
      textAlign(CENTER, BOTTOM);
      text("Round " +round, width/2, height-15);
      textAlign(RIGHT, BOTTOM);
      text("Kill Count:  " + killcount, width-100, height -15);
      textAlign(LEFT, BOTTOM);
      fill(230, 40, 40);
      reticle.createRet();
      drawHearts(player.lives);
      int heartWidth = 10;
      int heartHeight = 10;
      float startX = player.pos.x - (player.lives*heartWidth+10)/2;
      float startY = player.pos.y - player.pheight;
      for (int i = 0; i < player.lives; i++) 
      {
        image(heart, startX + i * (heartWidth + 5), startY, heartWidth, heartHeight);
      }
      break;

    case WON:
      displayEndMessage("YOU WIN!");
      break;
    case LOST:
      displayEndMessage("GAME OVER!");
      break;
    }
  }
  public void updateGame()
  {
    switch(state)
    {
    case START:
    if (settings.soundEnabled) {
      if (!lobbySound.isPlaying()) {
        lobbySound.loop();
      }
    }
    else if (!settings.soundEnabled) {
      lobbySound.stop(); 
    }

      if (mousePressed)
      { if (settings.soundEffectsEnabled) {
          if (!buttonClick.isPlaying()) {
            buttonClick.play();
          }
      }
        if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height/2 + 75 && mouseY < height/2 + 125 && !displaySettings) {
          displayLeaderboard = true;
        } else if (mouseX > 15 && mouseY < height && mouseX < 100 && mouseY > height - 40 && !displayLeaderboard) {
          displaySettings = true; 
        } else if (mouseX > 15 && mouseY > 15 && mouseX < 65 && mouseY < 45) {
          exit();
        } else if (!displayLeaderboard && !displaySettings) {
          for (int i = 1; i <= 5; i++)
          {
            int padding = 50; // Adjust padding as needed
            int x = width/2 + (i-3)*padding + padding/2 - 25; // add padding around the numbers
            if (mouseX > x - padding/2 &&
              mouseX < x + padding/2 &&
              mouseY > height/2 - padding/2 &&
              mouseY < height/2 + padding/2)
            {
              state = GameState.PLAYING;
              difficulty = i;
              player.pos.x = width/2;
              player.pos.y = height/2;
              timer.startTimer();
              createEnemies(difficulty*3);
              break;
            }
          }
        }
      }
      break;

    case PLAYING:
    if (settings.soundEnabled) {
      if (lobbySound.isPlaying() && !paused) {
        lobbySound.stop();
      }
        if (!gameSound.isPlaying() && !paused) {
          gameSound.jump(8);
        }
      }

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
        
        if (settings.soundEnabled) {
          if (gameSound.isPlaying()) {
            gameSound.pause();
            lobbySound.play();
          }
        }
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
            state = GameState.LOST;
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
              state=GameState.WON;
            }
          }
        }
      }
      break;
    case WON: // treats WON and LOST the same
    case LOST:
      gameSound.stop();
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
    leaderboard.addEntry(playerName, killcount, difficulty);
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
    state = GameState.START;
    round = 0;
    top10 = false;
  }

  public void displayEndMessage(String message) {
    fill(255);
    textSize(75);
    textAlign(CENTER, CENTER);
    text(message, width/2, height/2- 50);
    textSize(30);
    text("Press R to reset or Q to quit", width/2, height/2 + 50);
    if (leaderboard.top10()) {
      text("Congratulations! You made it to the leaderboard " + playerName, width/2, height/2 + 100);
    }
  }

  public void displayStart() {
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255, 0, 0);
    text("Quit", 40, 30);
    if (mouseX > 15 && mouseY > 15 && mouseX < 65 && mouseY < 45) {
      rect(15, 15, 50, 30);
      fill(0);
      text("Quit", 40, 30);
    }

    fill(255, 0, 0);
    text("Settings", 58, height - 25); // Display "Settings" in the left bottom corner
    if (mouseX > 15 && mouseY < height && mouseX < 100 && mouseY > height - 40) { // Check if mouse is over the "Settings" text
      rect(15, height - 40, 85, 30); // Highlight when hovering
      fill(0); // Change text color to black when highlighted
      text("Settings", 58, height - 25);
      fill(255); // Restore text color
    }

    headstone.resize(500, 0);

    int imgX = width/2 - headstone.width / 2;
    int imgY = height/2 - headstone.height / 2 - 15;

    image(headstone, imgX, imgY);
    image(logo, width/2 - logo.width/2, 15);
    
    textSize(38);
    fill(170, 255, 255);
    text("Select", width/2, height/2 - 100);
    text("difficulty", width/2, height/2 - 62);


    int padding = 50; // Adjust padding as needed
    textSize(30);

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
        fill(170, 255, 255);
        ;
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
      rect(width/2, height/2+245, 300, 200);
      fill(255);
      textAlign(CENTER);
      textSize(25);
      text("Move Up:    'W' or UP arrow key   ", width/2, height/2+180);
      text("Move Left:  'A' or LEFT arrow key ", width/2, height/2+210);
      text("Move Down:  'S' or DOWN arrow key ", width/2, height/2+240);
      text("Move Right: 'D' or RIGHT arrow key", width/2, height/2+270);
      text("Shoot:   point and click mouse    ", width/2, height/2+300);
      text("Pause:         Press 'P'           ", width/2, height/2+330);
      fill(255);
    }
  } // end of displayStart

  public void drawHearts(int numHearts) {
    int heartWidth = 30;
    int heartHeight = 30;
    int startX = 10;
    int startY = height - 40;
    for (int i = 0; i < numHearts; i++) {
      image(heart, startX + i * (heartWidth + 5), startY, heartWidth, heartHeight);
    }
  }// end of drawHearts()
  public void run()
  {
      try
      {
        while(true)
        {
          updateGame();
          this.sleep(10);
        }
      }
      catch(Exception e)
      {
        println(e.toString());
      }
    
  }
}
