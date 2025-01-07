import 'dart:async';
import 'package:flutter/material.dart';

class ClockController extends ChangeNotifier {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  DateTime get currentTime => _currentTime;

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime = DateTime.now();
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
