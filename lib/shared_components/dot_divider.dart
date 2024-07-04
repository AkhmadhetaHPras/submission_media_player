import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';

class DotDivider extends StatelessWidget {
  const DotDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Icon(
        Icons.circle,
        size: 6,
        color: MainColor.whiteF2F0EB,
      ),
    );
  }
}
