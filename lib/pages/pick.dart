import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/components/btn.dart';
import 'package:tic_tac/components/o_widget.dart';
import 'package:tic_tac/components/x_widget.dart';
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/services/sound.dart';
import 'package:tic_tac/core/theme.dart';
import 'game.dart';

class PickPage extends StatefulWidget {
  const PickPage({super.key});

  @override
  _PickPageState createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();

  String groupValue = 'X';
  bool isEndless = false;

  void setGroupValue(String value) {
    if (groupValue != value) {
      soundService.playSound('click'); // صوت خفيف عند التبديل
      setState(() => groupValue = value);
    }
  }

  void setEndless(bool value) {
    if (isEndless != value) {
      soundService.playSound('click');
      setState(() => isEndless = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Text(
              "PICK YOUR SIDE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Who goes first?",
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
            ),
            const Spacer(),

            // منطقة اختيار الجانب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildPickerOption('X', XWidget(80, 15), MyTheme.red),
                _buildPickerOption(
                    'O', OWidget(80, MyTheme.teal), MyTheme.teal),
              ],
            ),

            const Spacer(),

            // --- خيار ميزة اللعبة اللانهائية ---
            const Text(
              "GAME MODE",
              style: TextStyle(
                color: Colors.white38,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeOption("NORMAL", !isEndless, () => setEndless(false)),
                const SizedBox(width: 15),
                _buildModeOption("ENDLESS", isEndless, () => setEndless(true)),
              ],
            ),

            const Spacer(),

            // زر المتابعة
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Btn(
                onTap: () {
                  boardService.isEndless$.add(isEndless);
                  boardService.resetBoard();
                  boardService.setStart(groupValue);
                  if (groupValue == 'O') {
                    boardService.player$.add("X");
                    boardService.botMove();
                  }
                  soundService.playSound('click');
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const GamePage()));
                },
                height: 60,
                width: 280,
                borderRadius: 15,
                color: MyTheme.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    const SizedBox(width: 10),
                    const Text(
                      "LET'S PLAY",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? MyTheme.orange : MyTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.white24 : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white38,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOption(String value, Widget icon, Color color) {
    bool isSelected = groupValue == value;

    return GestureDetector(
      onTap: () => setGroupValue(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : MyTheme.cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 20)]
              : [],
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 20),
            Text(
              value == 'X' ? "FIRST" : "SECOND",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
