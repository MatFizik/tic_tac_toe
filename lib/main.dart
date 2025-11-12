import 'package:flutter/material.dart';
import 'package:tic_tac_toe/easy_bot.dart';

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

  void resetGame() {
    board = List.filled(9, '');
    winner = '';
    currentPlayer = 'X';
    moves = 0;
  }

  void checkWinner() {
    if (moves > 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('It\'s a Draw!')),
      );
      return;
    }
    if ((board[0] == board[1] && board[1] == board[2]) && board[0] != '') {
      winner = board[0];
    } else if ((board[0] == board[4] && board[4] == board[8]) &&
        board[0] != '') {
      winner = board[0];
    } else if ((board[0] == board[3] && board[3] == board[6]) &&
        board[0] != '') {
      winner = board[0];
    } else if ((board[3] == board[4] && board[4] == board[5]) &&
        board[3] != '') {
      winner = board[3];
    } else if ((board[1] == board[4] && board[4] == board[7]) &&
        board[1] != '') {
      winner = board[1];
    } else if ((board[6] == board[7] && board[7] == board[8]) &&
        board[6] != '') {
      winner = board[6];
    } else if ((board[6] == board[4] && board[4] == board[2]) &&
        board[6] != '') {
      winner = board[6];
    } else if ((board[2] == board[5] && board[5] == board[8]) &&
        board[2] != '') {
      winner = board[2];
    }

    if (winner != '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$winner is the winner!')),
      );
    }
  }

  void makeMove(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = currentPlayer;
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (currentPlayer == 'O' && moves < 8) {
          int botMove = easyBot.makeMove();
          while (board[botMove] != '') {
            botMove = easyBot.makeMove();
          }
          board[botMove] = currentPlayer;
          currentPlayer = 'X';
        }
        moves += 2;
      });
      checkWinner();
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
                child: const Row(
                  children: [
                    Radio<BotLevel>(
                      value: BotLevel.easy,
                    ),
                    Text('Easy Bot'),
                    Radio<BotLevel>(
                      value: BotLevel.medium,
                      enabled: false,
                    ),
                    Text('Medium Bot'),
                    Radio<BotLevel>(
                      value: BotLevel.hard,
                      enabled: false,
                    ),
                    Text('Hard Bot'),
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
                    InkWell(
                      onTap: () {
                        if (winner != '') return;
                        makeMove(i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                        ),
                        child: Center(
                          child: Text(
                            board[i],
                            style: const TextStyle(
                              fontSize: 42,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      resetGame();
                    },
                  );
                },
                child: const Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum BotLevel { easy, medium, hard }
