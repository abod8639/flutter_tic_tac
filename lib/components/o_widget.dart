import 'package:flutter/material.dart';

class OWidget extends StatelessWidget {
  final double size;
  final Color color;

  const OWidget(this.size, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // استخدام Circle مباشرة أسهل من BorderRadius
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        gradient: RadialGradient(
          radius: 0.5,
          colors: [
            Colors.transparent, // الفراغ الداخلي
            Colors.transparent, // نهاية الفراغ
            color, // بداية لون الحلقة
            color, // تدرج خفيف للحلقة
          ],
          // الـ stops تحدد أين يبدأ وينتهي كل لون (من 0.0 إلى 1.0)
          stops: const [0.0, 0.7, 0.72, 0.5],
        ),
      ),
    );
  }
}
