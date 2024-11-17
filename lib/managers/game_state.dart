class GameState {
  bool isGameStarted = false;
  bool isGameOver = false;
  int score = 0;
  double worldOffset = 0;

  void reset() {
    isGameStarted = false;
    isGameOver = false;
    score = 0;
    worldOffset = 0;
  }

  void incrementScore(double amount) {
    score += (amount / 100).ceil();
  }
}
