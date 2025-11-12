class Utils {
  static bool isWinner(
      List<String> board, String symbol, List<int> winningCombination) {
    if (board[0] == symbol && board[1] == symbol && board[2] == symbol) {
      winningCombination.addAll([0, 1, 2]);
      return true;
    } else if (board[0] == symbol && board[4] == symbol && board[8] == symbol) {
      winningCombination.addAll([0, 4, 8]);
      return true;
    } else if (board[0] == symbol && board[3] == symbol && board[6] == symbol) {
      winningCombination.addAll([0, 3, 6]);
      return true;
    } else if (board[3] == symbol && board[4] == symbol && board[5] == symbol) {
      winningCombination.addAll([3, 4, 5]);
      return true;
    } else if (board[1] == symbol && board[4] == symbol && board[7] == symbol) {
      winningCombination.addAll([1, 4, 7]);
      return true;
    } else if (board[6] == symbol && board[7] == symbol && board[8] == symbol) {
      winningCombination.addAll([6, 7, 8]);
      return true;
    } else if (board[6] == symbol && board[4] == symbol && board[2] == symbol) {
      winningCombination.addAll([6, 4, 2]);
      return true;
    } else if (board[2] == symbol && board[5] == symbol && board[8] == symbol) {
      winningCombination.addAll([2, 5, 8]);
      return true;
    }
    return false;
  }
}
