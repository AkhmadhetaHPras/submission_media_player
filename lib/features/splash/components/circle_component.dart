import 'package:flutter/material.dart';

class CircleComponent extends StatelessWidget {
  const CircleComponent({
    super.key,
    required this.scale,
    this.color,
    this.child,
  });
  final double scale;
  final Color? color;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Transform.scale(
        scale: scale,
        child: child ??
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
      ),
    );
  }
}
