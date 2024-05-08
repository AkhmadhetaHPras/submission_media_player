import 'dart:async';

import 'package:flutter/material.dart';

/// A class to handle debouncing cases in Flutter application development.
/// Debouncing is used to delay or postpone the execution of an action until a certain time after the action was last triggered.
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  /// Debouncer can be used to delay the execution of an action (callback) until a certain time after the action was last triggered.
  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
