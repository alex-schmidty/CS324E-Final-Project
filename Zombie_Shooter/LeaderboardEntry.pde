class LeaderboardEntry {
  private String name;
  private int score;

  LeaderboardEntry(String name, int score) {
    this.name = name;
    this.score = score;
  }

  String getName() {
    return name;
  }

  int getScore() {
    return score;
  }
}
