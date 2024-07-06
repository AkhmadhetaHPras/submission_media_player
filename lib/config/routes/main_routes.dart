/// An abstract class that provides string constants for various routes in the application.
/// These routes can be used as unique identifiers for navigation between screens or views in the application.
///
/// Usage Example
/// ```dart
/// Navigator.pushNamed(context, MainRoute.splash);
/// ```
abstract class MainRoute {
  static const String splash = '/';
  static const String home = '/home';
  static const String musicPlayer = '/music-player';
  static const String videoPlayer = '/video-player';
}
