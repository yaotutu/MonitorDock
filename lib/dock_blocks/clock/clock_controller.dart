import 'dart:async';
import 'package:flutter/foundation.dart';

class ClockController extends ValueNotifier<DateTime> {
  Timer? _timer;

  ClockController() : super(DateTime.now());

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      value = DateTime.now();
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
