import 'package:flutter/material.dart';

/// App typography configuration
class AppTypography {
  /// Title style - iOS style large title
  static TextStyle title({required bool isDark}) => TextStyle(
        fontFamily: '.SF Pro Display', // iOS系统字体
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.3,
      );

  /// Subtitle style - iOS style headline
  static TextStyle subtitle({required bool isDark}) => TextStyle(
        fontFamily: '.SF Pro Text',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.3,
      );

  /// Body text style - iOS style body
  static TextStyle body({required bool isDark}) => TextStyle(
        fontFamily: '.SF Pro Text',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        height: 1.4,
      );

  /// Label text style - iOS style subheadline
  static TextStyle label({required bool isDark}) => TextStyle(
        fontFamily: '.SF Pro Text',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// Small text style - iOS style footnote
  static TextStyle small({required bool isDark}) => TextStyle(
        fontFamily: '.SF Pro Text',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.2,
      );
}
