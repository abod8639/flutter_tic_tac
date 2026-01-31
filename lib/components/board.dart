import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tic_tac/components/x_widget.dart';
import 'package:tic_tac/services/alert.dart';
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/core/theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'o_widget.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardService = locator<BoardService>();
  final alertService = locator<AlertService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
            MapEntry<List<List<String>>, MapEntry<BoardState, String>>>(
        stream: Rx.combineLatest2(boardService.board$, boardService.boardState$,
            (a, b) => MapEntry(a, b)),
        builder: (context,
            AsyncSnapshot<
                    MapEntry<List<List<String>>, MapEntry<BoardState, String>>>
                snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final List<List<String>> board = snapshot.data!.key;
          final MapEntry<BoardState, String> state = snapshot.data!.value;

          if (state.key == BoardState.Done) {
            boardService.resetBoard();

            String title = 'Winner';
            if (state.value == "") {
              title = "Draw";
            }

            Widget body = state.value == 'X'
                ? XWidget(50, 20)
                : (state.value == "O"
                    ? OWidget(50, MyTheme.orange)
                    : Row(
                        children: <Widget>[
                          XWidget(50, 20),
                          OWidget(50, MyTheme.orange)
                        ],
                      ));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Alert(
                context: context,
                title: title,
                style: alertService.resultAlertStyle,
                buttons: [],
                content: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[body]),
              ).show();
            });
          }

          return Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                // BoxShadow(
                //   blurRadius: 7.0,
                //   spreadRadius: 0.0,
                //   color: Color(0x1F000000),
                // ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: board
                  .asMap()
                  .map(
                    (i, row) => MapEntry(
                      i,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: row
                            .asMap()
                            .map(
                              (j, item) => MapEntry(
                                j,
                                GestureDetector(
                                  onTap: () {
                                    if (board[i][j] != ' ') return;
                                    boardService.newMove(i, j);
                                  },
                                  child: _buildBox(i, j, item),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          );
        });
  }

  Widget _buildBox(int i, int j, item) {
    BorderSide neonBorder = BorderSide(
      width: 2,
      color: Colors.white.withOpacity(0.08),
    );
    BoxBorder border = Border(
      top: i == 1 || i == 2 ? neonBorder : BorderSide.none,
      bottom: i == 0 || i == 1 ? neonBorder : BorderSide.none,
      left: j == 1 || j == 2 ? neonBorder : BorderSide.none,
      right: j == 0 || j == 1 ? neonBorder : BorderSide.none,
    );

    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      height: MediaQuery.of(context).size.width / 4,
      width: MediaQuery.of(context).size.width / 4,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: item == ' '
              ? const SizedBox.shrink()
              : item == 'X'
                  ? const XWidget(50, 12)
                  : const OWidget(
                      50, MyTheme.teal), // استخدمنا Teal للـ O لتباين أفضل
        ),
      ),
    );
  }
}
