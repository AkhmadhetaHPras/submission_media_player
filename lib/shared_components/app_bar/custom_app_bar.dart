import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/constants/assets_const.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
  });

  final Widget? leading;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MainColor.purple5A579C,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: leading ??
            SvgPicture.asset(
              AssetsConsts.logo,
              colorFilter: const ColorFilter.mode(
                MainColor.whiteF2F0EB,
                BlendMode.srcIn,
              ),
            ),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: title ??
            SvgPicture.asset(
              AssetsConsts.logoName,
              width: 120,
              colorFilter: const ColorFilter.mode(
                MainColor.whiteF2F0EB,
                BlendMode.srcIn,
              ),
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
