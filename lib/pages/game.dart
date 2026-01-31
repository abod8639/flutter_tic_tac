import 'package:flutter/material.dart';
import 'package:tic_tac/components/board.dart';
import 'package:tic_tac/components/o_widget.dart';
import 'package:tic_tac/components/x_widget.dart';
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/core/theme.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final boardService = locator<BoardService>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) boardService.newGame();
      },
      child: Scaffold(
        backgroundColor: MyTheme.background,
        body: SafeArea(
          child: StreamBuilder<MapEntry<int, int>>(
            stream: boardService.score$,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final int xScore = snapshot.data!.key;
              final int oScore = snapshot.data!.value;

              return Column(
                children: <Widget>[
                  _buildTopBar(context),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // نتيجة اللاعب X
                        _buildScoreCard(
                          label: "Player X",
                          score: xScore,
                          icon: XWidget(30, 8),
                          isLeft: true,
                          color: MyTheme.red,
                        ),

                        // لوحة اللعب الرئيسية
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: MyTheme.cardColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Board(),
                        ),

                        // نتيجة اللاعب O
                        _buildScoreCard(
                          label: "Player O",
                          score: oScore,
                          icon: OWidget(30, MyTheme.teal),
                          isLeft: false,
                          color: MyTheme.teal,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
            onPressed: () {
              boardService.newGame();
              Navigator.pop(context);
            },
          ),
          const Text(
            "BATTLE",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: () => boardService.newGame(),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard({
    required String label,
    required int score,
    required Widget icon,
    required bool isLeft,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MyTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLeft) icon else Text("$score", style: _scoreStyle),
          Text(
            label.toUpperCase(),
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          if (isLeft) Text("$score", style: _scoreStyle) else icon,
        ],
      ),
    );
  }

  TextStyle get _scoreStyle => const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );
}
