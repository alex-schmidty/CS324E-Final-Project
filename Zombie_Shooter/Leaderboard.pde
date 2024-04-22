class Leaderboard {

  private ArrayList<LeaderboardEntry> entries;

  Leaderboard() {
    entries = new ArrayList<LeaderboardEntry>();
  }

  void loadFromFile(String filename) {
    String[] lines = loadStrings(filename);
    if (lines != null) {
      for (String line : lines) {
        String[] parts = line.split(",");
        String name = parts[0].trim();
        int score = Integer.parseInt(parts[1].trim());
        entries.add(new LeaderboardEntry(name, score));
      }
    }
  }

  void saveToFile(String filename) {
    String[] lines = new String[entries.size()];
    for (int i = 0; i < entries.size(); i++) {
      LeaderboardEntry entry = entries.get(i);
      lines[i] = entry.getName() + "," + entry.getScore();
    }
    saveStrings(filename, lines);
  }

  void addEntry(String name, int score) {
    entries.add(new LeaderboardEntry(name, score));
  }

  void display() {
    // Sort the entries by score in descending order
    entries.sort((a, b) -> Integer.compare(b.getScore(), a.getScore()));

    rectMode(CENTER);
    fill(5);
    stroke(0, 255, 0);
    rect(width/2, height/2, width/1.5, height/1.5);

    textSize(60);
    fill(255);
    text("Leaderboard", width/2, height/2 - height/4);

    textSize(30);
    int numEntries = min(entries.size(), 10);

    for (int i = 0; i < numEntries; i++) {
      LeaderboardEntry entry = entries.get(i);
      text((i + 1) + ". " + entry.getName() + ": " + entry.getScore(), width/2, (height/2 - 150) + i * 40);
      if (entry.getName() == playerName) {
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
