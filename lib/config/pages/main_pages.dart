import 'package:flutter/material.dart';
import 'package:media_player/config/routes/main_routes.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/music_player.dart';
import 'package:media_player/features/player/videos_player.dart';
import 'package:media_player/features/splash/splash_screen.dart';

/// A Map that associates each route defined in the [MainRoute] class with a widget builder function.
/// Each route is associated with a corresponding widget for the view associated with that route.
Map<String, Widget Function(BuildContext)> mainPages = {
  MainRoute.splash: (context) => const SplashScreen(),
  MainRoute.home: (context) => const Home(),
  MainRoute.musicPlayer: (context) => const MusicPlayer(),
  MainRoute.videoPlayer: (context) => const VideosPlayer(),
};
