class Leaderboard {

  private ArrayList<LeaderboardEntry> entries;
  public PImage leaderboardImg; 

  Leaderboard() {
    entries = new ArrayList<LeaderboardEntry>();
    leaderboardImg = loadImage("leaderboard.png"); 
  }

  void loadFromFile(String filename) {
    String[] lines = loadStrings(filename);
    if (lines != null) {
      for (String line : lines) {
        
        String[] parts = line.split(",");
        String name = parts[0].trim();
        int score = Integer.parseInt(parts[1].trim());
        int difficulty = Integer.parseInt(parts[2].trim());
        entries.add(new LeaderboardEntry(name, score, difficulty));
      }
    }
  }

  void saveToFile(String filename) {
    String[] lines = new String[entries.size()];
    for (int i = 0; i < entries.size(); i++) {
      LeaderboardEntry entry = entries.get(i);
      lines[i] = entry.getName() + "," + entry.getScore() + "," + entry.getDifficulty();
    }
    saveStrings(filename, lines);
  }

  void addEntry(String name, int score, int difficulty) {
    entries.add(new LeaderboardEntry(name, score, difficulty));
  }

  void display() {
    // Sort the entries by score in descending order
    entries.sort((a, b) -> Integer.compare(b.getScore(), a.getScore()));
    
    leaderboardImg.resize(1200, 0); 

    int imgX = width/2 - leaderboardImg.width / 2;
    int imgY = height/2 - leaderboardImg.height / 2;
    
    image(leaderboardImg,imgX, imgY); 

    textSize(60);
    fill(255);
    text("Leaderboard", width/2, height/2 - leaderboardImg.height*3/8);

    textSize(30);
    int numEntries = min(entries.size(), 10);
    
     // Display header for the leaderboard
    text("Rank", width/2 - 200, height/2 - 180); // Moved up by 100 pixels
    text("Name", width/2 - 50, height/2 - 180);  // Moved up by 100 pixels
    text("Score", width/2 + 150, height/2 - 180); // Moved up by 100 pixels
    text("Difficulty", width/2 + 250, height/2 - 180); // Moved up by 100 pixels
  
    for (int i = 0; i < numEntries; i++) {
      LeaderboardEntry entry = entries.get(i);
      // Display rank, name, and score for each entry
      text((i + 1) + ".", width/2 - 200, (height/2 - 150) + i * 40); // Moved up by 100 pixels
      text(entry.getName(), width/2 - 50, (height/2 - 150) + i * 40); // Moved up by 100 pixels
      text(entry.getScore(), width/2 + 150, (height/2 - 150) + i * 40); // Moved up by 100 pixels
      text(entry.getDifficulty(), width/2 + 250, (height/2 - 150) + i * 40); // Moved up by 100 pixels
      if (entry.getName().equals(playerName)) {
        gsm.top10 = true;
        print(true);
      }
    }

    // highlight exit
    if (mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 225 && mouseY < height/2 + 275) {
      fill(255, 0, 0); // Highlight when hovering
    } else {
      fill(255);
    }
    text("Exit", width/2, height/2 + 250);
    
    if (mousePressed && mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 225 && mouseY < height/2 + 275) {
      gsm.displayLeaderboard = false;
    }
          
  }


  int getLeaderboardSize() {
    return entries.size();
  }

  boolean top10() {
    if (entries.size() <= 9) {
      return true;
    } else if (entries.get(9).getScore() < killcount) {
      entries.sort((a, b) -> Integer.compare(b.getScore(), a.getScore()));
      return true;
    }
    return false;
  }
}
