import 'package:flutter/material.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/l10n/app_localizations.dart';

/// 우승 조건
enum WinCondition {
  first,
  last,
  firstToNums,
  lastToNums,
}

/// 카메라 모드
enum CameraMode {
  followLast,
  followFirst,
  followBattle,
  editor,
}

/// 디바이스 크기
enum DeviceType {
  normal,
  tablet,
  foldOpen,
  foldClose,
}

/// 에러 타입
enum ErrorType {
  warning(AppColor.warning),
  error(AppColor.danger),
  exit(AppColor.textPrimary)
  ;

  final Color color;
  const ErrorType(this.color);

  // context를 인자로 받아 해당 언어에 맞는 레이블을 반환합니다.
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ErrorType.warning => '🥲 ${l10n.warning}',
      ErrorType.error => '🫨 ${l10n.error}',
      ErrorType.exit => '👋 ${l10n.appExit}',
    };
  }
}
