import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/components/btn.dart';
import 'package:tic_tac/components/logo.dart';
import 'package:tic_tac/pages/game.dart';
import 'package:tic_tac/pages/pick.dart';
import 'package:tic_tac/pages/settings.dart';
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/services/sound.dart';
import 'package:tic_tac/core/theme.dart';

class StartPage extends StatelessWidget {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();

  StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      body: Stack(
        children: [
          // إضافة تأثير إضاءة في الخلفية لتحسين الـ UX البصري
          Positioned(
            top: -100,
            right: -50,
            child: _buildBlurCircle(MyTheme.orange.withOpacity(0.2)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildBlurCircle(MyTheme.red.withOpacity(0.15)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  const Spacer(flex: 2),

                  Column(
                    children: [
                      const Logo(),
                      const SizedBox(height: 20),
                      Text(
                        "TIC TAC",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                                color: MyTheme.red.withOpacity(0.5),
                                blurRadius: 15)
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  Column(
                    children: [
                      _buildMenuButton(
                        context,
                        label: "SINGLE PLAYER",
                        isPrimary: true,
                        onTap: () {
                          boardService.gameMode$.add(GameMode.Solo);
                          soundService.playSound('click');
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => PickPage()));
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildMenuButton(
                        context,
                        label: "WITH A FRIEND",
                        isPrimary: false,
                        onTap: () {
                          boardService.gameMode$.add(GameMode.Multi);
                          soundService.playSound('click');
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => GamePage()));
                        },
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // زر الإعدادات بشكل أيقونة عصرية في الأسفل
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: Colors.white54, size: 32),
                    onPressed: () {
                      soundService.playSound('click');
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => SettingsPage()));
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ودجت مساعد لبناء الأزرار بتصميم موحد
  Widget _buildMenuButton(BuildContext context,
      {required String label,
      required VoidCallback onTap,
      bool isPrimary = false}) {
    return Btn(
      onTap: onTap,
      height: 60,
      width: double.infinity, // يأخذ عرض الشاشة المتاح
      borderRadius: 15,
      color: isPrimary ? MyTheme.red : MyTheme.cardColor,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // تأثير الإضاءة الخلفية
  Widget _buildBlurCircle(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(color, BlendMode.srcIn),
          child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle)),
        ),
      ),
    );
  }
}
