class Settings {
  public PImage settingsBackground;
  public int imgX, imgY; 
  public int checkboxSize = 30; // Size of the checkboxes
  public boolean soundEnabled = true;
  public boolean soundEffectsEnabled = true;
  public boolean prevMousePressed = false; // Flag to track previous mouse button state
  public int exitButtonX;
  public float exitButtonY;
  public int soundEffectsCheckboxX;
  public float soundEffectsCheckboxY;
  public int soundCheckboxX;
  public float soundCheckboxY;
  
  Settings() {
    settingsBackground = loadImage("./settings.png");
    settingsBackground.resize(1200, 0);
    
    imgX = width/2 - settingsBackground.width / 2;
    imgY = height/2 - settingsBackground.height / 2;
    
    exitButtonX = width/2 - 50;
    exitButtonY = imgY + settingsBackground.height - 100;
    
    soundCheckboxX = width/2 + (settingsBackground.width / 6) - checkboxSize/2 - 50;
    soundCheckboxY = imgY + 150;
    
    soundEffectsCheckboxX = width/2 + (settingsBackground.width / 6) - checkboxSize/2 - 50;
    soundEffectsCheckboxY = imgY + 230;
  }

  void display() {
    image(settingsBackground, imgX, imgY);
    
    textSize(60);
    fill(255);
    text("Settings", width/2, imgY + 60);
    
    textAlign(LEFT, CENTER); 
    text("Sound", width/2 - 200, soundCheckboxY + 10); 
    text("Sound Effects", width/2 - 200, soundEffectsCheckboxY + 10); 
    
    //exit button 
    textAlign(CENTER, CENTER);
    if (mouseX > exitButtonX && mouseX < exitButtonX + 100 &&
        mouseY > exitButtonY && mouseY < exitButtonY + 50) {
      fill(255, 0, 0); 
    } else {
      fill(255);
    }

    text("Exit", width/2, exitButtonY + 25);
    
    if (mousePressed && !prevMousePressed && mouseX > exitButtonX && mouseX < exitButtonX + 100 &&
        mouseY > exitButtonY && mouseY < exitButtonY + 50) {
      gsm.displaySettings = false; 
    }
    
    displayCheckboxes();
    checkboxClicks();
    updatePrevMouseState();
  }
  
  void displayCheckboxes() {
    stroke(255);
    noFill();
    rect(soundCheckboxX, soundCheckboxY, checkboxSize, checkboxSize);
    if (soundEnabled) {
      fill(0, 255, 0); 
      rect(soundCheckboxX + 5, soundCheckboxY + 5, checkboxSize - 10, checkboxSize - 10);
    }
    
    stroke(255);
    noFill();
    rect(soundEffectsCheckboxX, soundEffectsCheckboxY, checkboxSize, checkboxSize);
    if (soundEffectsEnabled) {
      fill(0, 255, 0); 
      rect(soundEffectsCheckboxX + 5, soundEffectsCheckboxY + 5, checkboxSize - 10, checkboxSize - 10);
    }
  }
  
  void checkboxClicks() {
    
    // sound
    if (mousePressed && !prevMousePressed && mouseX > soundCheckboxX && mouseX < soundCheckboxX + checkboxSize &&
        mouseY > soundCheckboxY && mouseY < soundCheckboxY + checkboxSize) {
      soundEnabled = !soundEnabled; 
      print(soundEnabled);
    }
    
    //sound effects
    if (mousePressed && !prevMousePressed && mouseX > soundEffectsCheckboxX && mouseX < soundEffectsCheckboxX + checkboxSize &&
        mouseY > soundEffectsCheckboxY && mouseY < soundEffectsCheckboxY + checkboxSize) {
      soundEffectsEnabled = !soundEffectsEnabled; 
    }
  }
  
  void updatePrevMouseState() {
    prevMousePressed = mousePressed;
  }

}
