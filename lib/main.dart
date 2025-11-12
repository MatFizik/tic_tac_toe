import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/bot_controller.dart';
import 'package:tic_tac_toe/bots/easy_bot.dart';
import 'package:tic_tac_toe/utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TiC-TAC-TOE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EasyBot easyBot = EasyBot();
  String currentPlayer = 'X';
  List<String> board = List.filled(9, '');
  String winner = '';
  int moves = 0;
  BotLevel selectedBotLevel = BotLevel.easy;
  List<int> winningCombination = [];

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      moves = 0;
      winner = '';
      winningCombination.clear();
    });
  }

  void checkWinner() {
    if (Utils.isWinner(board, currentPlayer, winningCombination)) {
      winner = currentPlayer;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('$currentPlayer is the winner!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      );
      return;
    } else if (moves == 9) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('It\'s a draw!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      );
      return;
    }
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }

  void makeMove(int index) {
    if (board[index] == '' && moves < 9) {
      board[index] = currentPlayer;
      moves += 1;
      checkWinner();

      if (currentPlayer == 'O' && moves < 8 && winner == '') {
        int botMove = BotController().makeMove(board, 'O', selectedBotLevel);
        board[botMove] = currentPlayer;
        moves += 1;
        checkWinner();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RadioGroup<BotLevel>(
                groupValue: selectedBotLevel,
                onChanged: (BotLevel? value) {
                  setState(() {
                    selectedBotLevel = value!;
                  });
                },
                child: Row(
                  children: [
                    Radio<BotLevel>(
                      value: BotLevel.easy,
                      enabled: moves > 0 ? false : true,
                    ),
                    const Text('Easy Bot'),
                    Radio<BotLevel>(
                      value: BotLevel.medium,
                      enabled: moves > 0 ? false : true,
                    ),
                    const Text('Medium Bot'),
                    const Radio<BotLevel>(
                      value: BotLevel.hard,
                      enabled: false,
                    ),
                    const Text('Hard Bot'),
                  ],
                ),
              ),
              GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                children: [
                  for (int i = 0; i < 9; i++)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: InkWell(
                        key: UniqueKey(),
                        onTap: () {
                          if (winner != '') return;
                          makeMove(i);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: winningCombination.contains(i)
                                  ? Colors.red
                                  : Colors.teal,
                            ),
                            color: winningCombination.contains(i)
                                ? Colors.red.shade50
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              board[i],
                              style: TextStyle(
                                fontSize: 42,
                                color: winningCombination.contains(i)
                                    ? Colors.red
                                    : Colors.teal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        resetGame();
                      },
                    );
                  },
                  child: const Text('Restart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
