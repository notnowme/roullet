import 'package:flutter/material.dart';

/// 기기 타입 분류
enum Device {
  phone, // 일반 스마트폰 (< 600dp)
  foldable, // 갤럭시 폴드 등 폴더블 (600~719dp, 또는 aspect ratio 특이)
  tablet, // 태블릿 (>= 720dp)
}

/// 반응형 레이아웃 유틸리티
class ResponsiveLayout {
  final BuildContext context;

  ResponsiveLayout(this.context);

  /// 화면 크기
  Size get screenSize => MediaQuery.of(context).size;
  double get width => screenSize.width;
  double get height => screenSize.height;

  /// 기기 pixel ratio
  double get devicePixelRatio => MediaQuery.of(context).devicePixelRatio;

  /// 세이프 영역 패딩
  EdgeInsets get safePadding => MediaQuery.of(context).padding;

  /// 화면 비율
  double get aspectRatio => width / height;

  /// 기기 타입 판별
  Device get deviceType {
    final shortSide = width < height ? width : height;

    // 폴더블 감지: 접은 상태는 좁고 긴 화면, 펼친 상태는 거의 정사각형
    if (_isFoldable) return Device.foldable;
    if (shortSide >= 720) return Device.tablet;
    if (shortSide >= 600) return Device.foldable; // 600~719 경계
    return Device.phone;
  }

  /// 갤럭시 폴드 감지 (펼친 상태: ~1.0 비율, 접은 상태: ~0.46 비율)
  bool get _isFoldable {
    final shortSide = width < height ? width : height;
    // 펼친 폴드: 짧은 변 600~800, 비율 0.7~1.1 (거의 정사각형)
    if (shortSide >= 600 &&
        shortSide < 820 &&
        aspectRatio > 0.65 &&
        aspectRatio < 1.1) {
      return true;
    }
    // 접은 폴드: 짧은 변 280~380, 매우 좁음
    if (shortSide >= 280 && shortSide <= 400 && aspectRatio < 0.55) {
      return true;
    }
    return false;
  }

  /// 폴드 펼침 상태 여부
  bool get isFoldUnfolded {
    return deviceType == Device.foldable && aspectRatio > 0.65;
  }

  /// 폴드 접힘 상태 여부
  bool get isFoldFolded {
    return deviceType == Device.foldable && aspectRatio <= 0.65;
  }

  // ─── 게임 화면 관련 ──────────────────────────────────────────────

  /// 게임 영역 줌 계산 (기존 _calcZoom 대체)
  double get gameZoom {
    switch (deviceType) {
      case Device.phone:
        return 20.0 * (width / 360.0).clamp(0.8, 1.5);
      case Device.foldable:
        if (isFoldUnfolded) {
          // 펼친 상태: 넓은 화면에 맞게 줌 증가
          return 20.0 * (width / 360.0).clamp(1.2, 2.0);
        }
        // 접은 상태: 좁은 화면
        return 20.0 * (width / 360.0).clamp(0.7, 1.2);
      case Device.tablet:
        return 20.0 * (width / 360.0).clamp(1.5, 2.8);
    }
  }

  /// 에디터 그리드 셀 크기
  double get editorGridSize {
    switch (deviceType) {
      case Device.phone:
        return 48;
      case Device.foldable:
        return isFoldUnfolded ? 56 : 44;
      case Device.tablet:
        return 64;
    }
  }

  // ─── UI 컴포넌트 크기 ─────────────────────────────────────────────

  /// 컨트롤 패널 (하단) 최대 너비
  double get controlPanelMaxWidth {
    switch (deviceType) {
      case Device.phone:
        return width;
      case Device.foldable:
        return isFoldUnfolded ? width * 0.65 : width;
      case Device.tablet:
        return 480;
    }
  }

  /// 헤더 높이
  double get headerHeight {
    switch (deviceType) {
      case Device.phone:
        return 48;
      case Device.foldable:
        return isFoldUnfolded ? 64 : 44;
      case Device.tablet:
        return 64;
    }
  }

  /// 버튼 패딩
  EdgeInsets get buttonPadding {
    switch (deviceType) {
      case Device.phone:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
      case Device.foldable:
        return isFoldUnfolded
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 3)
            : const EdgeInsets.symmetric(horizontal: 9, vertical: 4);
      case Device.tablet:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    }
  }

  /// 기본 폰트 크기 배율
  double get fontScale {
    switch (deviceType) {
      case Device.phone:
        return 1.0;
      case Device.foldable:
        return isFoldUnfolded ? 1.1 : 0.9;
      case Device.tablet:
        return 1.2;
    }
  }

  /// 리더보드 너비
  double get leaderboardWidth {
    switch (deviceType) {
      case Device.phone:
        return width;
      case Device.foldable:
        return isFoldUnfolded ? width * 0.4 : width;
      case Device.tablet:
        return 320;
    }
  }

  /// 리더보드를 사이드에 표시할지 여부 (태블릿/펼친 폴드)
  bool get showLeaderboardSide {
    return deviceType == Device.tablet || isFoldUnfolded;
  }

  // ─── 에디터 관련 ──────────────────────────────────────────────────

  /// 에디터에서 속성 패널을 사이드에 표시할지
  bool get showEditorSidePanel {
    return deviceType == Device.tablet || isFoldUnfolded;
  }

  /// 에디터 툴바 아이콘 크기
  double get editorIconSize {
    switch (deviceType) {
      case Device.phone:
        return 24;
      case Device.foldable:
        return isFoldUnfolded ? 28 : 22;
      case Device.tablet:
        return 32;
    }
  }

  /// 에디터 오브젝트 팔레트 아이템 크기
  double get paletteItemSize {
    switch (deviceType) {
      case Device.phone:
        return 56;
      case Device.foldable:
        return isFoldUnfolded ? 64 : 52;
      case Device.tablet:
        return 72;
    }
  }

  /// 에디터 속성 패널 너비 (사이드 표시일 때)
  double get editorPropertyPanelWidth {
    switch (deviceType) {
      case Device.phone:
        return width;
      case Device.foldable:
        return isFoldUnfolded ? 280 : width;
      case Device.tablet:
        return 320;
    }
  }

  double get nativeSmallBannerHeight {
    return (width / 4).clamp(90.0, 150.0);
  }
}

/// 편의 Extension
extension ResponsiveContext on BuildContext {
  ResponsiveLayout get responsive => ResponsiveLayout(this);
}

/// 화면 크기 변경 감지 위젯 (폴드 접기/펼치기 대응)
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveLayout layout) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, ResponsiveLayout(context));
      },
    );
  }
}
