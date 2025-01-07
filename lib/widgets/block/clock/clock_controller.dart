import 'dart:async';
import 'package:flutter/material.dart';

class ClockController extends ChangeNotifier {
  DateTime _currentTime = DateTime.now();
  late Timer _timer;

  DateTime get currentTime => _currentTime;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime = DateTime.now();
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
