import 'package:flutter/material.dart';
import 'package:tic_tac/core/theme.dart';

class XWidget extends StatelessWidget {
  final double size;
  final double thickness;

  const XWidget(this.size, this.thickness, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center, // توسيط الخطين تلقائياً
        children: <Widget>[
          _buildLine(angle: 45),
          _buildLine(angle: -45),
        ],
      ),
    );
  }

  Widget _buildLine({required double angle}) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180, // تحويل الدرجات إلى راديان
      child: Container(
        width: size,
        height: thickness,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(thickness),
          boxShadow: [
            BoxShadow(
              color: MyTheme.red.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              MyTheme.red,
              MyTheme.orange,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}
