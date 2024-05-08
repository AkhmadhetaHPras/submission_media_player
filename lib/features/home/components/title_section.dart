import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        title,
        style: MainTextStyle.poppinsW600.copyWith(
          fontSize: 20,
          color: MainColor.whiteF2F0EB,
        ),
      ),
    );
  }
}
