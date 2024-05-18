import 'package:flutter/material.dart';
import 'package:media_player/config/pages/main_pages.dart';
import 'package:media_player/config/routes/main_routes.dart';
import 'package:media_player/config/themes/main_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Media Player',
      theme: mainTheme,
      initialRoute: MainRoute.splash,
      routes: mainPages,
    );
  }
}
