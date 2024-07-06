import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';

class BackButtonAppBarLeading extends StatelessWidget {
  const BackButtonAppBarLeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('back_btn'),
      icon: const Icon(
        Icons.arrow_back_ios_new_sharp,
        size: 18,
        color: MainColor.whiteFFFFFF,
      ),
      onPressed: () => Navigator.pop(context),
      splashRadius: 18,
    );
  }
}
