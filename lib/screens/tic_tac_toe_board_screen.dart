import 'package:flutter/material.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/models/game_settings.dart';
import 'package:tic_tac_toe/models/game_state.dart';
import 'package:tic_tac_toe/utils/bot_controller.dart';

class TicTacToeBoardScreen extends StatefulWidget {
  const TicTacToeBoardScreen({super.key});

  @override
  State<TicTacToeBoardScreen> createState() => _TicTacToeBoardScreenState();
}

class _TicTacToeBoardScreenState extends State<TicTacToeBoardScreen> {
  late TicTacToeGame game;

  @override
  void initState() {
    super.initState();
    game = TicTacToeGame(settings: GameSettings.defaultSettings());
    game.startGame();
  }

  void _handleCellTap(int index) {
    if (game.state.isGameOver) return;
    if (!game.isPlayerTurn) return;

    setState(() {
      if (game.makeMove(index)) {
        _checkGameResult();

        if (!game.state.isGameOver && game.isBotTurn) {
          Future.delayed(Duration(milliseconds: game.settings.botMoveDelay),
              () {
            if (mounted) {
              setState(() {
                game.makeBotMove();
                _checkGameResult();
              });
            }
          });
        }
      }
    });
  }

  void _checkGameResult() {
    if (game.state.isGameOver) {
      String message;
      switch (game.result) {
        case GameResult.playerWin:
          message = 'Вы выиграли!';
          break;
        case GameResult.botWin:
          message = 'Бот выиграл!';
          break;
        case GameResult.draw:
          message = 'Ничья!';
          break;
        default:
          return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showResultDialog(message);
        }
      });
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                game.resetGame();
                game.startGame();
              });
            },
            child: const Text('Новая игра'),
          ),
        ],
      ),
    );
  }

  void _changeBotLevel(BotLevel level) {
    setState(() {
      game.updateSettings(game.settings.copyWith(botLevel: level));
      game.resetGame();
      game.startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                game.resetGame();
                game.startGame();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Ход: ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      game.getCurrentPlayer(),
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Сложность: '),
                    DropdownButton<BotLevel>(
                      value: game.settings.botLevel,
                      items: const [
                        DropdownMenuItem(
                          value: BotLevel.easy,
                          child: Text('Легко'),
                        ),
                        DropdownMenuItem(
                          value: BotLevel.medium,
                          child: Text('Средне'),
                        ),
                        DropdownMenuItem(
                          value: BotLevel.hard,
                          child: Text('Сложно'),
                        ),
                      ],
                      onChanged: game.moveCount == 0
                          ? (level) {
                              if (level != null) _changeBotLevel(level);
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final isWinningCell = game.winningCombination.contains(index);
                  final cellValue = game.state.board[index];

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      key: ValueKey(cellValue),
                      onTap: () => _handleCellTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isWinningCell
                              ? Colors.red.shade100
                              : Colors.transparent,
                          border: Border.all(
                            color: isWinningCell ? Colors.red : Colors.teal,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            cellValue,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isWinningCell ? Colors.red : Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Ходов сделано: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${game.moveCount}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Статус: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getStatusText(game.state.status),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.notStarted:
        return 'Не начата';
      case GameStatus.inProgress:
        return 'В процессе';
      case GameStatus.finished:
        return 'Завершена';
      case GameStatus.paused:
        return 'Пауза';
    }
  }
}
