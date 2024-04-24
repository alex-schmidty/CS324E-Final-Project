class LeaderboardEntry {
  private String name;
  private int score;
  private int difficulty; 

  LeaderboardEntry(String name, int score, int difficulty) {
    this.name = name;
    this.score = score;
    this.difficulty = difficulty; 
  }

  String getName() {
    return name;
  }

  int getScore() {
    return score;
  }
  
  int getDifficulty() {
    return difficulty; 
  }
}
