import 'dart:async';
import 'package:flutter/material.dart';

// https://medium.com/fabcoding/implementing-search-in-flutter-delay-search-while-typing-8508ea4004c6
class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
