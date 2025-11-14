import 'package:tic_tac_toe/utils/bot_controller.dart';

class GameSettings {
  final int boardSize;

  BotLevel botLevel;

  final String playerSymbol;

  final String botSymbol;

  final String firstPlayer;

  bool soundEnabled;

  bool animationsEnabled;

  int botMoveDelay;

  GameSettings({
    this.boardSize = 9,
    this.botLevel = BotLevel.easy,
    this.playerSymbol = 'X',
    this.botSymbol = 'O',
    this.firstPlayer = 'X',
    this.soundEnabled = false,
    this.animationsEnabled = true,
    this.botMoveDelay = 500,
  });

  GameSettings copyWith({
    int? boardSize,
    BotLevel? botLevel,
    String? playerSymbol,
    String? botSymbol,
    String? firstPlayer,
    bool? soundEnabled,
    bool? animationsEnabled,
    int? botMoveDelay,
  }) {
    return GameSettings(
      boardSize: boardSize ?? this.boardSize,
      botLevel: botLevel ?? this.botLevel,
      playerSymbol: playerSymbol ?? this.playerSymbol,
      botSymbol: botSymbol ?? this.botSymbol,
      firstPlayer: firstPlayer ?? this.firstPlayer,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      botMoveDelay: botMoveDelay ?? this.botMoveDelay,
    );
  }

  factory GameSettings.defaultSettings() {
    return GameSettings();
  }

  factory GameSettings.easy() {
    return GameSettings(
      botLevel: BotLevel.easy,
      botMoveDelay: 500,
    );
  }

  factory GameSettings.medium() {
    return GameSettings(
      botLevel: BotLevel.medium,
      botMoveDelay: 700,
    );
  }

  factory GameSettings.hard() {
    return GameSettings(
      botLevel: BotLevel.hard,
      botMoveDelay: 1000,
    );
  }

  @override
  String toString() {
    return 'GameSettings(boardSize: $boardSize, botLevel: $botLevel, '
        'playerSymbol: $playerSymbol, botSymbol: $botSymbol, '
        'firstPlayer: $firstPlayer, soundEnabled: $soundEnabled, '
        'animationsEnabled: $animationsEnabled, botMoveDelay: $botMoveDelay)';
  }
}
