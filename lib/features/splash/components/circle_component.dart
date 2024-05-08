import 'package:flutter/material.dart';

class CircleComponent extends StatelessWidget {
  const CircleComponent({
    super.key,
    required this.scale,
    this.color,
    this.child,
  });
  
  final Widget? child;
  final Color? color;

final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Transform.scale(
        scale: scale,
        child: child ??
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
      ),
    );
  }
}
