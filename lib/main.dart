import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/app_init.dart';

void main() async {
  await AppInit.initialize();
  runApp(const App());
}
