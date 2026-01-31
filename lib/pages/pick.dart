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

  void setGroupValue(String value) {
    if (groupValue != value) {
      soundService.playSound('click'); // صوت خفيف عند التبديل
      setState(() => groupValue = value);
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

            // زر المتابعة
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Btn(
                onTap: () {
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
                child: const Text(
                  "LET'S PLAY",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2),
                ),
              ),
            ),
          ],
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
