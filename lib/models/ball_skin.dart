import 'package:flutter/material.dart';
import 'package:toruru/l10n/app_localizations.dart';

enum BallSkin {
  marble,
  solarSystem,
  sports,
  pixel,
  slime,
  fruit
  ;

  String getLabel(BuildContext context) {
    return switch (this) {
      BallSkin.marble => AppLocalizations.of(context)!.marble,
      BallSkin.solarSystem => AppLocalizations.of(context)!.solar,
      BallSkin.sports => AppLocalizations.of(context)!.sports,
      BallSkin.pixel => AppLocalizations.of(context)!.pixel,
      BallSkin.slime => AppLocalizations.of(context)!.slime,
      BallSkin.fruit => AppLocalizations.of(context)!.fruits,
    };
  }

  String getdescription(BuildContext context) {
    return switch (this) {
      BallSkin.marble => AppLocalizations.of(context)!.marbleDesc,
      BallSkin.solarSystem => AppLocalizations.of(context)!.solarDesc,
      BallSkin.sports => AppLocalizations.of(context)!.sportsDesc,
      BallSkin.pixel => AppLocalizations.of(context)!.pixelDesc,
      BallSkin.slime => AppLocalizations.of(context)!.slimeDesc,
      BallSkin.fruit => AppLocalizations.of(context)!.fruitsDesc,
    };
  }

  /// 스킨별 기본 물리 속성 (개별 항목이 없는 marble, pixel, slime용)
  double get defaultRestitution => switch (this) {
    BallSkin.marble => 0.6,
    BallSkin.pixel => 0.7,
    BallSkin.slime => 0.85,
    _ => 0.6,
  };

  double get defaultDensity => switch (this) {
    BallSkin.marble => 0.3,
    BallSkin.pixel => 0.25,
    BallSkin.slime => 0.2,
    _ => 0.3,
  };
}

// ── 행성 데이터 ──────────────────────────────────────────────────────────────

class PlanetData {
  final String Function(BuildContext) name;
  final Color baseColor;
  final Color darkColor;
  final Color lightColor;
  final double restitution;
  final double density;

  const PlanetData({
    required this.name,
    required this.baseColor,
    required this.darkColor,
    required this.lightColor,
    required this.restitution,
    required this.density,
  });
}

final List<PlanetData> planets = [
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.mercury,
    baseColor: const Color(0xFF9E9E9E),
    darkColor: const Color(0xFF424242),
    lightColor: const Color(0xFFBDBDBD),
    restitution: 0.3,
    density: 0.5,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.venus,
    baseColor: const Color(0xFFE8C46A),
    darkColor: const Color(0xFFC49A3C),
    lightColor: const Color(0xFFFFF3CD),
    restitution: 0.25,
    density: 0.6,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.earth,
    baseColor: const Color(0xFF1565C0),
    darkColor: const Color(0xFF0D47A1),
    lightColor: const Color(0xFF42A5F5),
    restitution: 0.4,
    density: 0.5,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.marble,
    baseColor: const Color(0xFFBF360C),
    darkColor: const Color(0xFF7F0000),
    lightColor: const Color(0xFFFF7043),
    restitution: 0.45,
    density: 0.4,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.jupiter,
    baseColor: const Color(0xFFD2691E),
    darkColor: const Color(0xFF8B4513),
    lightColor: const Color(0xFFF5CBA7),
    restitution: 0.2,
    density: 0.8,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.saturn,
    baseColor: const Color(0xFFDAA520),
    darkColor: const Color(0xFF8B6914),
    lightColor: const Color(0xFFFFF59D),
    restitution: 0.35,
    density: 0.25,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.uranus,
    baseColor: const Color(0xFF80DEEA),
    darkColor: const Color(0xFF26C6DA),
    lightColor: const Color(0xFFE0F7FA),
    restitution: 0.3,
    density: 0.45,
  ),
  PlanetData(
    name: (context) => AppLocalizations.of(context)!.neptune,
    baseColor: const Color(0xFF283593),
    darkColor: const Color(0xFF1A237E),
    lightColor: const Color(0xFF5C6BC0),
    restitution: 0.3,
    density: 0.5,
  ),
];

// ── 스포츠 볼 데이터 ─────────────────────────────────────────────────────────

class SportsData {
  final String Function(BuildContext) name;
  final Color baseColor; // 구체 베이스 색
  final Color lightColor; // 그라데이션 밝은 쪽
  final Color darkColor; // 그라데이션 어두운 쪽
  final Color trailColor; // 트레일 색
  final bool nameDark; // true → 이름 글자 어둡게
  final double restitution;
  final double density;

  const SportsData({
    required this.name,
    required this.baseColor,
    required this.lightColor,
    required this.darkColor,
    required this.trailColor,
    required this.restitution,
    required this.density,
    this.nameDark = false,
  });
}

// ── 과일 데이터 ──────────────────────────────────────────────────────────────

class FruitData {
  final String Function(BuildContext) name;
  final Color baseColor;
  final Color lightColor;
  final Color darkColor;
  final Color trailColor;
  final bool nameDark;
  final double restitution;
  final double density;

  const FruitData({
    required this.name,
    required this.baseColor,
    required this.lightColor,
    required this.darkColor,
    required this.trailColor,
    required this.restitution,
    required this.density,
    this.nameDark = false,
  });
}

final List<FruitData> fruits = [
  // 0: 사과 — 적당한 무게, 약간 튀김
  FruitData(
    name: (context) => AppLocalizations.of(context)!.apple,
    baseColor: const Color(0xFFE53935),
    lightColor: const Color(0xFFFF5252),
    darkColor: const Color(0xFFB71C1C),
    trailColor: const Color(0xFFE53935),
    restitution: 0.3,
    density: 0.35,
  ),
  // 1: 배 — 부드럽고 적당함
  FruitData(
    name: (context) => AppLocalizations.of(context)!.pear,
    baseColor: const Color(0xFFD4E157),
    lightColor: const Color(0xFFF4FF81),
    darkColor: const Color(0xFF827717),
    trailColor: const Color(0xFFCDDC39),
    restitution: 0.25,
    density: 0.35,
    nameDark: true,
  ),
  // 2: 파인애플 — 무겁고 단단함
  FruitData(
    name: (context) => AppLocalizations.of(context)!.pineapple,
    baseColor: const Color(0xFFFFB300),
    lightColor: const Color(0xFFFFD54F),
    darkColor: const Color(0xFFE65100),
    trailColor: const Color(0xFFFF8F00),
    restitution: 0.2,
    density: 0.5,
    nameDark: true,
  ),
  // 3: 오렌지 — 적당히 튀김
  FruitData(
    name: (context) => AppLocalizations.of(context)!.orange,
    baseColor: const Color(0xFFFF7043),
    lightColor: const Color(0xFFFF9E80),
    darkColor: const Color(0xFFBF360C),
    trailColor: const Color(0xFFFF7043),
    restitution: 0.45,
    density: 0.35,
  ),
  // 4: 레몬 — 가볍고 잘 튀김
  FruitData(
    name: (context) => AppLocalizations.of(context)!.lemon,
    baseColor: const Color(0xFFFDD835),
    lightColor: const Color(0xFFFFFF8D),
    darkColor: const Color(0xFFF9A825),
    trailColor: const Color(0xFFFDD835),
    restitution: 0.5,
    density: 0.25,
    nameDark: true,
  ),
  // 5: 키위 — 작고 부드러움
  FruitData(
    name: (context) => AppLocalizations.of(context)!.kiwi,
    baseColor: const Color(0xFF558B2F),
    lightColor: const Color(0xFF9CCC65),
    darkColor: const Color(0xFF33691E),
    trailColor: const Color(0xFF7CB342),
    restitution: 0.3,
    density: 0.3,
  ),
  // 6: 딸기 — 매우 가볍고 부드러움
  FruitData(
    name: (context) => AppLocalizations.of(context)!.strawberry,
    baseColor: const Color(0xFFFF1744),
    lightColor: const Color(0xFFFF8A80),
    darkColor: const Color(0xFFB71C1C),
    trailColor: const Color(0xFFFF4081),
    restitution: 0.2,
    density: 0.2,
  ),
  // 7: 코코넛 — 단단하고 무거움
  FruitData(
    name: (context) => AppLocalizations.of(context)!.coconut,
    baseColor: const Color(0xFF6D4C41),
    lightColor: const Color(0xFF8D6E63),
    darkColor: const Color(0xFF3E2723),
    trailColor: const Color(0xFF8D6E63),
    restitution: 0.35,
    density: 0.55,
  ),
  // 8: 두리안 — 무겁고 뻣뻣함
  FruitData(
    name: (context) => AppLocalizations.of(context)!.durian,
    baseColor: const Color(0xFFAFB42B),
    lightColor: const Color(0xFFE6EE9C),
    darkColor: const Color(0xFF827717),
    trailColor: const Color(0xFFCDDC39),
    restitution: 0.15,
    density: 0.6,
    nameDark: true,
  ),
  // 9: 바나나 — 가볍고 부드러움
  FruitData(
    name: (context) => AppLocalizations.of(context)!.banana,
    baseColor: const Color(0xFFFDD835),
    lightColor: const Color(0xFFFFFF8D),
    darkColor: const Color(0xFFF57F17),
    trailColor: const Color(0xFFFDD835),
    restitution: 0.2,
    density: 0.2,
    nameDark: true,
  ),
];

final List<SportsData> sportsBalls = [
  // 0: 야구공 — 단단하고 적당히 무거움
  SportsData(
    name: (context) => AppLocalizations.of(context)!.baseball,
    baseColor: const Color(0xFFEEEEEE),
    lightColor: const Color(0xFFFFFFFF),
    darkColor: const Color(0xFFBBBBBB),
    trailColor: const Color(0xFFE53935),
    restitution: 0.35,
    density: 0.4,
    nameDark: true,
  ),
  // 1: 축구공 — 균형잡힌 표준
  SportsData(
    name: (context) => AppLocalizations.of(context)!.soccerBall,
    baseColor: const Color(0xFFF0F0F0),
    lightColor: const Color(0xFFFFFFFF),
    darkColor: const Color(0xFFCCCCCC),
    trailColor: const Color(0xFF546E7A),
    restitution: 0.6,
    density: 0.3,
    nameDark: true,
  ),
  // 2: 농구공 — 탄성 최고
  SportsData(
    name: (context) => AppLocalizations.of(context)!.basketball,
    baseColor: const Color(0xFFE65100),
    lightColor: const Color(0xFFFF8F00),
    darkColor: const Color(0xFFBF360C),
    trailColor: const Color(0xFFE65100),
    restitution: 0.85,
    density: 0.25,
  ),
  // 3: 테니스공 — 가볍고 잘 튀김
  SportsData(
    name: (context) => AppLocalizations.of(context)!.tennisBall,
    baseColor: const Color(0xFFCDDC39),
    lightColor: const Color(0xFFEEFF41),
    darkColor: const Color(0xFF9E9D24),
    trailColor: const Color(0xFFCDDC39),
    restitution: 0.75,
    density: 0.2,
    nameDark: true,
  ),
  // 4: 배구공 — 가볍고 적당히 튀김
  SportsData(
    name: (context) => AppLocalizations.of(context)!.volleyball,
    baseColor: const Color(0xFFECEFF1),
    lightColor: const Color(0xFFFFFFFF),
    darkColor: const Color(0xFFB0BEC5),
    trailColor: const Color(0xFF1565C0),
    restitution: 0.7,
    density: 0.2,
    nameDark: true,
  ),
  // 5: 골프공 — 단단하고 무거움
  SportsData(
    name: (context) => AppLocalizations.of(context)!.golfBall,
    baseColor: const Color(0xFFF5F5F5),
    lightColor: const Color(0xFFFFFFFF),
    darkColor: const Color(0xFFBDBDBD),
    trailColor: const Color(0xFF26A69A),
    restitution: 0.4,
    density: 0.5,
    nameDark: true,
  ),
  // 6: 당구공 — 단단하고 묵직함
  SportsData(
    name: (context) => AppLocalizations.of(context)!.billiardBall,
    baseColor: const Color(0xFFE53935),
    lightColor: const Color(0xFFEF9A9A),
    darkColor: const Color(0xFF7F0000),
    trailColor: const Color(0xFFE53935),
    restitution: 0.5,
    density: 0.6,
    nameDark: true,
  ),
  // 7: 볼링공 — 매우 무겁고 안 튀김
  SportsData(
    name: (context) => AppLocalizations.of(context)!.bowlingBall,
    baseColor: const Color(0xFF1A237E),
    lightColor: const Color(0xFF3949AB),
    darkColor: const Color(0xFF0D1257),
    trailColor: const Color(0xFF3949AB),
    restitution: 0.2,
    density: 0.8,
  ),
];
