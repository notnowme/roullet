import 'package:flutter/material.dart';

const List<Color> marbleColors = [
  Color(0xFF7B6CF6),
  Color(0xFF4ECDC4),
  Color(0xFFFF6B6B),
  Color(0xFFFFA726),
  Color(0xFF66BB6A),
  Color(0xFFEC407A),
  Color(0xFF29B6F6),
  Color(0xFFD4E157),
  Color(0xFFAB47BC),
  Color(0xFF26C6DA),
];

abstract class AppColor {
  AppColor._();

  static const bgPrimary = Color(0xFF0D0D1A);
  static const bgCard = Color(0xFF13132A);
  static const bgElevated = Color(0xFF1E1E36);

  static const accent = Color(0xFF7B6CF6);
  static const accentSub = Color(0xFF4ECDC4);
  static const danger = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFA726);
  static const success = Color(0xFF66BB6A);

  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
  static const textMuted = Colors.white38;

  static const border = Color(0xFF3A3A55);
  static const borderLight = Color(0xFF2A2A45);
}
