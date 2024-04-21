public class GameStateManager
{
  public State state;
  public PImage logo;
  public GameStateManager()
  {
    this.state= State.START;
    logo = loadImage("./zlogo.gif");
  }
  public void displayGame()
  {
    background(0);
    switch(state)
    {
    case START:
      textAlign(CENTER, CENTER);
      textSize(50);
      fill(255);
      image(logo, width/2 - logo.width/2, 15);
      //text("Zombie Attack", width/2, height/2 - 50);


      //fill(200);
      //textSize(25);
      //text("Click SPACE to begin", width/2, height/2 + 50);
      textAlign(CENTER, CENTER);
      textSize(24);
      fill(170, 255, 255);
      text("Select Starting Level:", width/2, height/2 - 100);

      // Display difficulty options
      for (int i = 1; i <= 5; i++) {
        if (
          mouseX > width/2 + (i-3)*50 &&
          mouseX < width/2 + (i-2)*50 &&
          mouseY > height/2 - 50 &&
          mouseY < height/2 + 50) {
          fill(0, 255, 0); // Highlight the selected difficulty
        } else {
          fill(255);
        }
        text(i, width/2 + (i-3)*50, height/2);
      }





      if (killcntmax != 0)
      {
        fill(255, 0, 0);
        textSize(20);
        text("Kill Count High Score: " + killcntmax, width/2, height/2 + 150);
      }
      fill(70, 70, 175);
      text("Hold 'C' to see controls", width/2, height-205);
      if (keyPressed && key == 'c' || key =='C' )
      {
        rectMode(CENTER);
        rect(width/2, height-205, 300, 175);
        fill(0);
        textAlign(RIGHT);
        textSize(20);
        text("Move Left: 'A' or left arrow key", width/2+105, height-270);
        text("Move Right: 'D' or right arrow key", width/2+130, height-200);
        text("Shoot: SPACE bar", width/2, height-130);
        fill(255);
      }
      break;
    case PLAYING:
      fill(255);
      textSize(25);
      text("Round " +constrain(round, 0, 5), width/2, height-15);
      if (killcount != 0)
      {
        textSize(17);
        text("Kill Count:  " + killcount, width-100, height -15);
      }
      break;
    case WON:
      textSize(50);
      textAlign(CENTER, CENTER);
      text("YOU WIN!", width/2, height/2- 50);
      textSize(20);
      text("Press R to reset or Q to quit", width/2, height/2 + 50);
      break;
    case LOST:
      textSize(50);
      textAlign(CENTER, CENTER);
      text("YOU LOSE!", width/2, height/2- 50);
      textSize(20);
      text("Press R to reset or Q to quit", width/2, height/2 + 50);
      break;
    }
    //display everything
    for (Bullet bullet : bullets)
    {
      bullet.display();
    }
    handleSprites();
  }
  public void updateGame()
  {
    switch(state)
    {
    case START:
      if (mousePressed) {
        for (int i = 1; i <= 5; i++) {
          if (mouseX > width/2 + (i-3)*50 &&
            mouseX < width/2 + (i-2)*50 &&
            mouseY > height/2 - 50 &&
            mouseY < height/2 + 50) {

            createEnemies(2);
            state = State.PLAYING;
            round = i;
            timer.startTimer();
            println(i);
          } // end of if
        } // end of for loop
      }

      break;

    case PLAYING:
      // update player
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
      if (player.isDead && round <6)
      {
        timer.pauseTimer();
        state = State.LOST;
      }

      // advance to next round
      if (enemies.size() ==  0)
      {
        round +=1;
        if (round < 6 && round > 1) {
          createEnemies(round*2);
        }

        //win condition
        if (round > 5)
        {
          timer.pauseTimer();
          state=State.WON;
        }
      }
      break;

    case WON: // treats WON and LOST the same
    case LOST:
      if (keyPressed && key == 'r'|| key =='R') {
        resetGame();
      }
      if (keyPressed && key == 'q'|| key =='Q') {
        exit();
      }
      break;
    }
  }

  public void resetGame()
  {
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
  }

  public void mousePressed() {
    if (state == State.START) {
      // Check if the user clicked on a difficulty option
      for (int i = 1; i <= 5; i++) {
        if (mouseX > width/2 + (i-3)*50 &&
          mouseX < width/2 + (i-2)*50 &&
          mouseY > height/2 - 50 &&
          mouseY < height/2 + 50) {
          //selectedDifficulty = i;
          //gameRunning = true; // Start the game
          ////gameManager.startGame(selectedDifficulty); // Start the game with the selected difficulty
          //break;
        } // end of if
      } // end of for loop
    }
  }
}

