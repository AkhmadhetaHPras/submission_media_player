import 'package:flutter/material.dart';

class ControllButton extends StatelessWidget {
  const ControllButton({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.onPressed,
    required this.splashR,
    required this.icSize,
    this.icColor,
  });

  final IconData icon;
  final Color bgColor;
  final Function() onPressed;
  final double splashR, icSize;
  final Color? icColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      shape: const OvalBorder(),
      child: IconButton(
        splashRadius: splashR,
        iconSize: icSize,
        icon: Icon(
          icon,
          color: icColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
