import 'package:tic_tac_toe/models/game_settings.dart';
import 'package:tic_tac_toe/models/game_state.dart';
import 'package:tic_tac_toe/utils/bot_controller.dart';
import 'package:tic_tac_toe/utils/utils.dart';

abstract class Game {
  void startGame();
  void stopGame();
  void resetGame();

  String getCurrentPlayer();
  List<String> getBoardState();
  String checkWinner();
}

class TicTacToeGame implements Game {
  GameSettings settings;

  GameState _state;

  final BotController _botController = BotController();

  TicTacToeGame({GameSettings? settings})
      : settings = settings ?? GameSettings.defaultSettings(),
        _state = GameState.initial(
          firstPlayer: settings?.firstPlayer ?? 'X',
        );

  GameState get state => _state;

  @override
  void startGame() {
    _state = _state.copyWith(
      status: GameStatus.inProgress,
    );
  }

  @override
  void stopGame() {
    _state = _state.copyWith(
      status: GameStatus.paused,
    );
  }

  @override
  void resetGame() {
    _state = GameState.initial(firstPlayer: settings.firstPlayer);
  }

  @override
  String getCurrentPlayer() {
    return _state.currentPlayer;
  }

  @override
  List<String> getBoardState() {
    return List.from(_state.board);
  }

  @override
  String checkWinner() {
    List<int> winningCombo = [];

    if (Utils.isWinner(_state.board, _state.currentPlayer, winningCombo)) {
      _state = _state.copyWith(
        status: GameStatus.finished,
        winner: _state.currentPlayer,
        winningCombination: winningCombo,
        result: _state.currentPlayer == settings.playerSymbol
            ? GameResult.playerWin
            : GameResult.botWin,
      );
      return _state.currentPlayer;
    }

    if (_state.isBoardFull) {
      _state = _state.copyWith(
        status: GameStatus.finished,
        result: GameResult.draw,
      );
      return 'Draw';
    }

    return '';
  }

  bool makeMove(int index) {
    if (_state.isGameOver) return false;
    if (index < 0 || index >= settings.boardSize) return false;
    if (_state.board[index] != '') return false;

    List<String> newBoard = List.from(_state.board);
    newBoard[index] = _state.currentPlayer;

    _state = _state.copyWith(
      board: newBoard,
      moveCount: _state.moveCount + 1,
      status: GameStatus.inProgress,
    );

    String winner = checkWinner();

    if (winner.isEmpty && !_state.isGameOver) {
      _state = _state.copyWith(
        currentPlayer: _state.currentPlayer == 'X' ? 'O' : 'X',
      );
    }

    return true;
  }

  int? makeBotMove() {
    if (_state.isGameOver) return null;
    if (_state.currentPlayer != settings.botSymbol) return null;

    int botMove = _botController.makeMove(
      _state.board,
      settings.botSymbol,
      settings.botLevel,
    );

    if (makeMove(botMove)) {
      return botMove;
    }

    return null;
  }

  bool get isBotTurn => _state.currentPlayer == settings.botSymbol;

  bool get isPlayerTurn => _state.currentPlayer == settings.playerSymbol;

  void updateSettings(GameSettings newSettings) {
    settings = newSettings;
  }

  int get moveCount => _state.moveCount;

  List<int> get winningCombination => _state.winningCombination;

  GameResult get result => _state.result;

  @override
  String toString() {
    return 'TicTacToeGame(settings: $settings, state: $_state)';
  }
}
