import 'package:tic_tac_toe/utils/utils.dart';

class HardBot {
  String botSymbol = '';
  String opponentSymbol = '';

  int makeMove(List<String> board, String symbol) {
    botSymbol = symbol;
    opponentSymbol = symbol == 'X' ? 'O' : 'X';

    int bestMove = -1;
    int bestScore = -1000;

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = botSymbol;

        int score = minimax(board, 0, false);

        board[i] = '';

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  int minimax(List<String> board, int depth, bool isMaximizing) {
    if (Utils.isWinner(board, botSymbol, [])) {
      return 10 - depth;
    }
    if (Utils.isWinner(board, opponentSymbol, [])) {
      return depth - 10;
    }
    if (_isBoardFull(board)) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = botSymbol;
          int score = minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = score > bestScore ? score : bestScore;
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = opponentSymbol;
          int score = minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = score < bestScore ? score : bestScore;
        }
      }
      return bestScore;
    }
  }

  bool _isBoardFull(List<String> board) {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        return false;
      }
    }
    return true;
  }
}
