import 'package:flutter/material.dart';
import 'package:tic_tac/core/theme.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MyTheme.orange.withOpacity(0.8),
                width: 12,
              ),
              boxShadow: [
                BoxShadow(
                  color: MyTheme.orange.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              _buildXLine(angle: 45),
              _buildXLine(angle: -45),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildXLine({required double angle}) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180,
      child: Container(
        height: 12,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [MyTheme.red, MyTheme.orange],
          ),
          boxShadow: [
            BoxShadow(
              color: MyTheme.red.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
