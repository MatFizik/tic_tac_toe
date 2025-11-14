import 'dart:math';

import 'package:tic_tac_toe/utils/utils.dart';

class MediumBot {
  int makeMove(List<String> board, String symbol) {
    if (_findWinningMove(board, symbol) != -1) {
      return _findWinningMove(board, symbol);
    } else {
      String opponentSymbol = symbol == 'X' ? 'O' : 'X';
      if (_findWinningMove(board, opponentSymbol) != -1) {
        return _findWinningMove(board, opponentSymbol);
      } else {
        int move = Random().nextInt(9);
        while (board[move] != '') {
          move = Random().nextInt(9);
        }
        return move;
      }
    }
  }

  int _findWinningMove(List<String> board, String symbol) {
    List<String> tempBoard = List.from(board);
    for (int i = 0; i < 9; i++) {
      if (tempBoard[i] == '') {
        tempBoard[i] = symbol;
        if (Utils.isWinner(tempBoard, symbol, [])) {
          tempBoard[i] = '';
          return i;
        }
        tempBoard[i] = '';
      }
    }

    return -1;
  }
}
