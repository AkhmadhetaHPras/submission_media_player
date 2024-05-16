import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/features/player/components/time_display.dart';
import 'package:video_player/video_player.dart';

class VideoIndicator extends StatelessWidget {
  const VideoIndicator({
    super.key,
    required this.isVisible,
    required this.position,
    required this.duration,
    required this.controller,
  });

  final bool isVisible;
  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            MainColor.black000000,
            MainColor.black000000.withOpacity(0.5),
            MainColor.black000000.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: TimeDisplay(
              position: position,
              duration: duration,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          VideoProgressIndicator(
            controller,
            allowScrubbing: isVisible,
          ),
        ],
      ),
    );
  }
}
