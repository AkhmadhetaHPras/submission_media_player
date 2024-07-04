import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    super.key,
    required this.position,
    required this.duration,
  });

  final Duration position;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          position.toString().split(".")[0],
          style: const TextStyle(
            color: MainColor.whiteF2F0EB,
          ),
        ),
        Text(
          duration.toString().split(".")[0],
          style: const TextStyle(
            color: MainColor.whiteF2F0EB,
          ),
        ),
      ],
    );
  }
}
