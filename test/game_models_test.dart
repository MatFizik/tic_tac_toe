import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/models/game_settings.dart';
import 'package:tic_tac_toe/models/game_state.dart';
import 'package:tic_tac_toe/utils/bot_controller.dart';

void main() {
  group('GameSettings', () {
    test('создание с параметрами по умолчанию', () {
      final settings = GameSettings();

      expect(settings.boardSize, 9);
      expect(settings.botLevel, BotLevel.easy);
      expect(settings.playerSymbol, 'X');
      expect(settings.botSymbol, 'O');
      expect(settings.firstPlayer, 'X');
    });

    test('фабричный метод easy', () {
      final settings = GameSettings.easy();
      expect(settings.botLevel, BotLevel.easy);
      expect(settings.botMoveDelay, 500);
    });

    test('фабричный метод hard', () {
      final settings = GameSettings.hard();
      expect(settings.botLevel, BotLevel.hard);
      expect(settings.botMoveDelay, 1000);
    });

    test('copyWith изменяет только указанные поля', () {
      final original = GameSettings.easy();
      final modified = original.copyWith(botLevel: BotLevel.hard);

      expect(original.botLevel, BotLevel.easy);
      expect(modified.botLevel, BotLevel.hard);
      expect(modified.playerSymbol, original.playerSymbol);
    });
  });

  group('GameState', () {
    test('начальное состояние корректно', () {
      final state = GameState.initial();

      expect(state.board.length, 9);
      expect(state.board.every((cell) => cell == ''), true);
      expect(state.currentPlayer, 'X');
      expect(state.moveCount, 0);
      expect(state.status, GameStatus.notStarted);
    });

    test('copyWith создает новое состояние', () {
      final state = GameState.initial();
      final newBoard = ['X', '', '', '', '', '', '', '', ''];
      final newState = state.copyWith(
        board: newBoard,
        moveCount: 1,
        currentPlayer: 'O',
      );

      expect(newState.board[0], 'X');
      expect(newState.moveCount, 1);
      expect(newState.currentPlayer, 'O');
      expect(state.moveCount, 0); // оригинал не изменился
    });

    test('isGameOver возвращает true для завершенной игры', () {
      final state = GameState.initial().copyWith(
        status: GameStatus.finished,
      );
      expect(state.isGameOver, true);
    });

    test('isBoardFull работает корректно', () {
      final emptyState = GameState.initial();
      expect(emptyState.isBoardFull, false);

      final fullState = emptyState.copyWith(moveCount: 9);
      expect(fullState.isBoardFull, true);
    });
  });

  group('TicTacToeGame', () {
    test('создание игры инициализирует состояние', () {
      final game = TicTacToeGame();

      expect(game.state.board.length, 9);
      expect(game.getCurrentPlayer(), 'X');
      expect(game.moveCount, 0);
    });

    test('startGame изменяет статус на inProgress', () {
      final game = TicTacToeGame();
      game.startGame();

      expect(game.state.status, GameStatus.inProgress);
    });

    test('makeMove обновляет доску', () {
      final game = TicTacToeGame();
      game.startGame();

      final success = game.makeMove(0);

      expect(success, true);
      expect(game.state.board[0], 'X');
      expect(game.moveCount, 1);
    });

    test('makeMove меняет игрока', () {
      final game = TicTacToeGame();
      game.startGame();

      game.makeMove(0);
      expect(game.getCurrentPlayer(), 'O');

      game.makeMove(1);
      expect(game.getCurrentPlayer(), 'X');
    });

    test('makeMove отклоняет ход в занятую клетку', () {
      final game = TicTacToeGame();
      game.startGame();

      game.makeMove(0);
      final secondMove = game.makeMove(0);

      expect(secondMove, false);
    });

    test('checkWinner определяет победителя по горизонтали', () {
      final game = TicTacToeGame();
      game.startGame();

      // X X X
      // O O .
      // . . .
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X выигрывает

      expect(game.state.winner, 'X');
      expect(game.state.isGameOver, true);
      expect(game.result, GameResult.playerWin);
    });

    test('checkWinner определяет ничью', () {
      final game = TicTacToeGame();
      game.startGame();

      // X X O
      // O O X
      // X O X
      game.makeMove(0); // X
      game.makeMove(2); // O
      game.makeMove(1); // X
      game.makeMove(3); // O
      game.makeMove(5); // X
      game.makeMove(4); // O
      game.makeMove(6); // X
      game.makeMove(7); // O
      game.makeMove(8); // X

      expect(game.state.isGameOver, true);
      expect(game.result, GameResult.draw);
    });

    test('resetGame очищает состояние', () {
      final game = TicTacToeGame();
      game.startGame();
      game.makeMove(0);
      game.makeMove(1);

      game.resetGame();

      expect(game.moveCount, 0);
      expect(game.state.board.every((cell) => cell == ''), true);
      expect(game.getCurrentPlayer(), 'X');
    });

    test('updateSettings изменяет настройки', () {
      final game = TicTacToeGame();
      expect(game.settings.botLevel, BotLevel.easy);

      game.updateSettings(game.settings.copyWith(botLevel: BotLevel.hard));
      expect(game.settings.botLevel, BotLevel.hard);
    });

    test('isPlayerTurn и isBotTurn работают корректно', () {
      final settings = GameSettings(
        playerSymbol: 'X',
        botSymbol: 'O',
      );
      final game = TicTacToeGame(settings: settings);
      game.startGame();

      expect(game.isPlayerTurn, true);
      expect(game.isBotTurn, false);

      game.makeMove(0);

      expect(game.isPlayerTurn, false);
      expect(game.isBotTurn, true);
    });

    test('makeBotMove делает корректный ход', () {
      final settings = GameSettings(
        playerSymbol: 'X',
        botSymbol: 'O',
        botLevel: BotLevel.easy,
      );
      final game = TicTacToeGame(settings: settings);
      game.startGame();

      game.makeMove(0); // ход игрока

      final botMove = game.makeBotMove();

      expect(botMove, isNotNull);
      expect(game.state.board[botMove!], 'O');
    });

    test('нельзя сделать ход после окончания игры', () {
      final game = TicTacToeGame();
      game.startGame();

      // X выигрывает
      game.makeMove(0);
      game.makeMove(3);
      game.makeMove(1);
      game.makeMove(4);
      game.makeMove(2);

      final invalidMove = game.makeMove(5);
      expect(invalidMove, false);
    });
  });
}
