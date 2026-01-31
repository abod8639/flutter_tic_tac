import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tic_tac/components/x_widget.dart';
import 'package:tic_tac/components/o_widget.dart'; // تأكد من المسار الصحيح
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/core/theme.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardService = locator<BoardService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: Rx.combineLatest3(
        boardService.board$, 
        boardService.boardState$,
        boardService.fadingMoves$,
        (a, b, c) => {'board': a, 'state': b, 'fading': c}
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final List<List<String>> board = snapshot.data!['board'];
        final MapEntry<BoardState, String> state = snapshot.data!['state'];
        final List<List<int>> fading = snapshot.data!['fading'];

        // استدعاء نافذة النتيجة عند انتهاء اللعبة
        if (state.key == BoardState.Done) {
          _showResultDialog(context, state.value);
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MyTheme.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: board.asMap().entries.map((rowEntry) {
              int i = rowEntry.key;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: rowEntry.value.asMap().entries.map((itemEntry) {
                  int j = itemEntry.key;
                  String item = itemEntry.value;
                  return GestureDetector(
                    onTap: () {
                      if (item == ' ' && state.key != BoardState.Done) {
                        boardService.newMove(i, j);
                      }
                    },
                    child: _buildBox(i, j, item, fading),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // دالة بناء المربع الصغير
  Widget _buildBox(int i, int j, String item, List<List<int>> fading) {
    BorderSide neonBorder = BorderSide(
      width: 1.5,
      color: Colors.white.withOpacity(0.08),
    );

    bool isFading = fading.any((move) => move[0] == i && move[1] == j);

    return Container(
      height: MediaQuery.of(context).size.width / 4,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
        border: Border(
          top: i > 0 ? neonBorder : BorderSide.none,
          left: j > 0 ? neonBorder : BorderSide.none,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: item == ' '
              ? const SizedBox.shrink()
              : BlinkingWidget(
                  isBlinking: isFading,
                  child: item == 'X' 
                      ? const XWidget(45, 10) 
                      : const OWidget(45, MyTheme.teal),
                ),
        ),
      ),
    );
  }

  // دالة عرض الديالوج (تم نقلها خارج الـ build)
  void _showResultDialog(BuildContext context, String winner) {
    String resultTitle = winner == "" ? "DRAW" : "WINNER!";
    Widget resultIcon = winner == 'X'
        ? const XWidget(80, 15)
        : (winner == 'O'
            ? const OWidget(80, MyTheme.teal)
            : const Icon(Icons.balance, color: Colors.orange, size: 80));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        // barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.85),
        builder: (context) => AlertDialog(
          backgroundColor: MyTheme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(resultTitle, style: const TextStyle(letterSpacing: 5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              resultIcon,
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDialogBtn(Icons.replay_rounded, MyTheme.orange, () {
                    boardService.newGame();
                    Navigator.pop(context);
                  }, isPrimary: true),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDialogBtn(IconData icon, Color color, VoidCallback onTap, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: isPrimary ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 15)] : [],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class BlinkingWidget extends StatefulWidget {
  final Widget child;
  final bool isBlinking;

  const BlinkingWidget({super.key, required this.child, required this.isBlinking});

  @override
  _BlinkingWidgetState createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.isBlinking) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(BlinkingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isBlinking && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: widget.isBlinking ? _controller.value : 1.0,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}