import 'dart:math';

class EasyBot {
  int makeMove(List<String> board, String symbol) {
    int move = Random().nextInt(9);
    while (board[move] != '') {
      move = Random().nextInt(9);
    }
    return move;
  }
}
