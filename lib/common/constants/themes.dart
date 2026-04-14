import 'package:flutter/material.dart';
import 'package:toruru/common/constants/colors.dart';

abstract class AppUI {
  AppUI._();

  static BoxDecoration glassCard({
    double opacity = 0.12,
    double borderRadius = 16,
    Color? borderColor,
    Color? bgColor,
  }) {
    return BoxDecoration(
      color: bgColor ?? Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? Colors.white.withValues(alpha: 0.08),
      ),
    );
  }

  static BoxDecoration glassCardBlur({
    double opacity = 0.08,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: AppColor.bgCard.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    );
  }

  static BoxDecoration accentButton({double borderRadius = 12}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF7B6CF6), Color(0xFF9B8FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppColor.accent.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration toggleButton({
    required bool isSelected,
    double borderRadius = 10,
  }) {
    return BoxDecoration(
      color: isSelected
          ? AppColor.accent.withValues(alpha: 0.2)
          : Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isSelected ? AppColor.accent : AppColor.border,
      ),
    );
  }

  static InputDecoration inputDecoration({
    String? hintText,
    double borderRadius = 12,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColor.textMuted),
      filled: true,
      fillColor: AppColor.bgElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static BoxDecoration neonButton({
    Color color = AppColor.accent,
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, Color.lerp(color, Colors.white, 0.15)!],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: color.withValues(alpha: 0.5)),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.15),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration neonToggle({
    required bool isSelected,
    Color activeColor = AppColor.accent,
    double borderRadius = 10,
  }) {
    return BoxDecoration(
      gradient: isSelected
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                activeColor.withValues(alpha: 0.25),
                activeColor.withValues(alpha: 0.1),
              ],
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.06),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isSelected
            ? activeColor.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.08),
        width: isSelected ? 1.5 : 1,
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.25),
                blurRadius: 12,
              ),
              BoxShadow(
                color: activeColor.withValues(alpha: 0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ]
          : null,
    );
  }

  static BoxDecoration neonOutline({
    Color color = AppColor.textMuted,
    double borderRadius = 12,
    double opacity = 0.05,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    );
  }
}
