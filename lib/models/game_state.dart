enum GameStatus {
  notStarted,
  inProgress,
  finished,
  paused,
}

enum GameResult {
  none,
  playerWin,
  botWin,
  draw,
}

class GameState {
  final List<String> board;

  final String currentPlayer;

  final int moveCount;

  final GameStatus status;

  final GameResult result;

  final String? winner;

  final List<int> winningCombination;

  GameState({
    required this.board,
    required this.currentPlayer,
    this.moveCount = 0,
    this.status = GameStatus.notStarted,
    this.result = GameResult.none,
    this.winner,
    this.winningCombination = const [],
  });

  factory GameState.initial({String firstPlayer = 'X'}) {
    return GameState(
      board: List.filled(9, ''),
      currentPlayer: firstPlayer,
      moveCount: 0,
      status: GameStatus.notStarted,
      result: GameResult.none,
      winningCombination: [],
    );
  }

  GameState copyWith({
    List<String>? board,
    String? currentPlayer,
    int? moveCount,
    GameStatus? status,
    GameResult? result,
    String? winner,
    List<int>? winningCombination,
  }) {
    return GameState(
      board: board ?? List.from(this.board),
      currentPlayer: currentPlayer ?? this.currentPlayer,
      moveCount: moveCount ?? this.moveCount,
      status: status ?? this.status,
      result: result ?? this.result,
      winner: winner ?? this.winner,
      winningCombination:
          winningCombination ?? List.from(this.winningCombination),
    );
  }

  bool get isGameOver => status == GameStatus.finished;

  bool get isInProgress => status == GameStatus.inProgress;

  bool get isBoardFull => moveCount >= 9;

  @override
  String toString() {
    return 'GameState(currentPlayer: $currentPlayer, moveCount: $moveCount, '
        'status: $status, result: $result, winner: $winner)';
  }
}
