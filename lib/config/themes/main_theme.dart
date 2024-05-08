import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';

/// A [ThemeData] object that defines the visual theme for the application.
/// It includes properties such as the main color, color scheme, icons, and other settings that affect the appearance and visual behavior of widgets in the app.
final ThemeData mainTheme = ThemeData(
  primaryColor: MainColor.purple5A579C,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: MainColor.purple5A579C,
    cardColor: MainColor.whiteFFFFFF,
    errorColor: MainColor.redDC3545,
  ),
  iconTheme: const IconThemeData(
    color: MainColor.purple5A579C,
    size: 24,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: MainColor.black000000,
  ),
);
