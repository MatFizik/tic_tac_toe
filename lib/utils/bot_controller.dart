import 'package:tic_tac_toe/utils/bots/easy_bot.dart';
import 'package:tic_tac_toe/utils/bots/hard_bot.dart';
import 'package:tic_tac_toe/utils/bots/medium_bot.dart';

class BotController {
  int makeMove(List<String> board, String symbol, BotLevel level) {
    switch (level) {
      case BotLevel.easy:
        return EasyBot().makeMove(board, symbol);
      case BotLevel.medium:
        return MediumBot().makeMove(board, symbol);
      case BotLevel.hard:
        return HardBot().makeMove(board, symbol);
    }
  }
}

enum BotLevel { easy, medium, hard }
