import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:toruru/components/particles.dart';
import 'package:toruru/models/ball_skin.dart';
import 'package:toruru/screens/rollit_game.dart';

class Ball extends BodyComponent with ContactCallbacks {
  final Vector2 startPos;
  final Color color;
  final String name;
  final double radius;
  final Vector2 initVelocity;
  final double restitution;
  final double density;
  final double maxSpeed;
  final bool showTrail;

  /// 스킨 변형 인덱스.
  /// solarSystem: 0~7 (행성), sports: 0~7 (스포츠 볼), 나머지: -1
  final int planetIndex;

  final List<Vector2> _trail = [];
  static const int _trailLength = 12;

  double stuckTimer = 0.0;
  Vector2 prevPosition = Vector2.zero();
  double teleportFlash = 0.0;

  // ── 슬라임 찌그러짐 스프링 ────────────────────────────────────────────────
  double _squishAmount = 0.0; // mode 1: 충돌 방향 압축/팽창
  double _squishVelocity = 0.0;
  double _squishAngle = 0.0; // 충돌 방향
  double _wobbleAmount = 0.0; // mode 2: 사각형↔마름모 (quadrupole)
  double _wobbleVelocity = 0.0;
  double _particleCooldown = 0.0; // 파티클 생성 쿨다운 (초)

  Ball(
    this.startPos, {
    this.radius = 0.7,
    this.color = const Color(0xFF7B6CF6),
    this.name = '',
    this.restitution = 0.6,
    this.density = 0.3,
    this.maxSpeed = 25.0,
    this.showTrail = true,
    this.planetIndex = -1,
    Vector2? initVelocity,
  }) : initVelocity = initVelocity ?? Vector2.zero();

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..restitution = restitution
      ..density = density
      ..friction = 0.05;
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: startPos,
      linearVelocity: initVelocity,
      bullet: true,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    final settings = (game as RollitGame).settings;
    // 속도 문턱 + 쿨다운으로 파티클 과다 생성 방지
    final speed = body.linearVelocity.length;
    if (speed > 0.5 && _particleCooldown <= 0.0) {
      _particleCooldown = 0.12; // 120 ms 쿨다운
      game.world.add(switch (settings.ballSkin) {
        BallSkin.solarSystem => GameParticles.starDust(
          position: body.position.clone(),
          color: color,
        ),
        BallSkin.pixel => GameParticles.pixelCollision(
          position: body.position.clone(),
          color: color,
        ),
        BallSkin.slime => GameParticles.slimeSplash(
          position: body.position.clone(),
          color: color,
        ),
        _ => GameParticles.collision(
          position: body.position.clone(),
          color: color,
          count: 3,
        ),
      });
    }

    // 슬라임 스킨: 충돌 시 mode 1(squish) + mode 2(wobble) 동시 트리거
    if (settings.ballSkin == BallSkin.slime && speed > 1.0) {
      final impact = (speed / 12.0).clamp(0.35, 0.85);
      if (impact > _squishAmount) {
        _squishAmount = impact;
        _squishVelocity = 0.0;
        _squishAngle = math.atan2(
          body.linearVelocity.y,
          body.linearVelocity.x,
        );
        _wobbleAmount = impact * 0.55;
        _wobbleVelocity = 0.0;
      }
    }

    final velo = body.linearVelocity;
    final rng = math.Random();
    if (speed < 0.1) return;
    final angleOffset = (rng.nextDouble() - 0.5) * 0.4;
    final currentAngle = math.atan2(velo.y, velo.x);
    final newAngle = currentAngle + angleOffset;
    body.linearVelocity = Vector2(
      math.cos(newAngle) * speed,
      math.sin(newAngle) * speed,
    );
    final maxSpeed = settings.maxSpeed;
    if (body.linearVelocity.length > maxSpeed) {
      body.linearVelocity = body.linearVelocity.normalized() * maxSpeed;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _trail.add(body.position.clone());
    if (_trail.length > _trailLength) {
      _trail.removeAt(0);
    }

    // 파티클 쿨다운 감소
    if (_particleCooldown > 0.0) {
      _particleCooldown -= dt;
    }

    // 슬라임 mode 1: 충돌 방향 squish (dipole)
    if (_squishAmount != 0.0 || _squishVelocity != 0.0) {
      const double k1 = 35.0;
      const double d1 = 5.5;
      final acc1 = -k1 * _squishAmount - d1 * _squishVelocity;
      _squishVelocity += acc1 * dt;
      _squishAmount = (_squishAmount + _squishVelocity * dt).clamp(-0.45, 1.0);
      if (_squishAmount.abs() < 0.002 && _squishVelocity.abs() < 0.005) {
        _squishAmount = 0.0;
        _squishVelocity = 0.0;
      }
    }
    // 슬라임 mode 2: quadrupole wobble (더 빠른 주파수, 더 오래 지속)
    if (_wobbleAmount != 0.0 || _wobbleVelocity != 0.0) {
      const double k2 = 60.0;
      const double d2 = 4.0;
      final acc2 = -k2 * _wobbleAmount - d2 * _wobbleVelocity;
      _wobbleVelocity += acc2 * dt;
      _wobbleAmount = (_wobbleAmount + _wobbleVelocity * dt).clamp(-0.40, 0.80);
      if (_wobbleAmount.abs() < 0.002 && _wobbleVelocity.abs() < 0.005) {
        _wobbleAmount = 0.0;
        _wobbleVelocity = 0.0;
      }
    }
  }

  // ── 렌더링 진입점 ─────────────────────────────────────────────────────────

  @override
  void render(Canvas canvas) {
    final settings = (game as RollitGame).settings;
    if (settings.showTrail) _renderTrail(canvas);

    switch (settings.ballSkin) {
      case BallSkin.marble:
        _renderMarble(canvas);
      case BallSkin.solarSystem:
        if (planetIndex >= 0) {
          _renderPlanet(canvas, planetIndex);
        } else {
          _renderMarble(canvas);
        }
      case BallSkin.sports:
        if (planetIndex >= 0) {
          _renderSport(canvas, planetIndex);
        } else {
          _renderMarble(canvas);
        }
      case BallSkin.pixel:
        _renderPixel(canvas);
      case BallSkin.slime:
        _renderSlime(canvas);
      case BallSkin.fruit:
        if (planetIndex >= 0) {
          _renderFruit(canvas, planetIndex);
        } else {
          _renderMarble(canvas);
        }
    }
  }

  // ── 마블 ──────────────────────────────────────────────────────────────────

  void _renderMarble(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius * 1.6,
      Paint()
        ..color = color.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 1.0,
          colors: [
            Color.lerp(color, Colors.white, 0.35)!,
            color,
            Color.lerp(color, Colors.black, 0.3)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.2, -radius * 0.3),
        width: radius * 0.9,
        height: radius * 0.5,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset(-radius * 0.3, -radius * 0.35),
      radius * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(radius * 0.15, radius * 0.35),
        width: radius * 0.5,
        height: radius * 0.25,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06,
    );
    _renderName(canvas);
  }

  // ── 행성 ──────────────────────────────────────────────────────────────────

  void _renderPlanet(Canvas canvas, int index) {
    final planet = planets[index];
    if (index == 5) _renderSaturnRing(canvas, planet);

    canvas.drawCircle(
      Offset.zero,
      radius * 1.6,
      Paint()
        ..color = planet.baseColor.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 1.0,
          colors: [planet.lightColor, planet.baseColor, planet.darkColor],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );
    _renderPlanetSurface(canvas, index, planet);
    canvas.restore();

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.2, -radius * 0.3),
        width: radius * 0.9,
        height: radius * 0.5,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06,
    );
    _renderName(canvas);
  }

  void _renderPlanetSurface(Canvas canvas, int index, PlanetData planet) {
    switch (index) {
      case 0: // 수성 — 크레이터
        final p = Paint()..color = planet.darkColor.withValues(alpha: 0.5);
        canvas.drawCircle(
          Offset(radius * 0.30, radius * 0.20),
          radius * 0.12,
          p,
        );
        canvas.drawCircle(
          Offset(-radius * 0.40, radius * 0.10),
          radius * 0.08,
          p,
        );
        canvas.drawCircle(
          Offset(radius * 0.10, -radius * 0.35),
          radius * 0.06,
          p,
        );
        canvas.drawCircle(
          Offset(-radius * 0.20, radius * 0.38),
          radius * 0.10,
          p,
        );
        canvas.drawCircle(
          Offset(radius * 0.45, -radius * 0.15),
          radius * 0.07,
          p,
        );

      case 1: // 금성 — 구름
        final cp = Paint()
          ..color = Colors.white.withValues(alpha: 0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.09
          ..strokeCap = StrokeCap.round;
        for (int i = -2; i <= 2; i++) {
          final y = i * radius * 0.32;
          canvas.drawPath(
            Path()
              ..moveTo(-radius, y)
              ..quadraticBezierTo(
                0,
                y - radius * 0.12,
                radius,
                y + radius * 0.06,
              ),
            cp,
          );
        }

      case 2: // 지구 — 대륙
        final lp = Paint()
          ..color = const Color(0xFF2E7D32).withValues(alpha: 0.85);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(-radius * 0.1, -radius * 0.1),
            width: radius * 0.55,
            height: radius * 0.5,
          ),
          lp,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(radius * 0.38, radius * 0.22),
            width: radius * 0.32,
            height: radius * 0.5,
          ),
          lp,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(-radius * 0.45, radius * 0.32),
            width: radius * 0.22,
            height: radius * 0.28,
          ),
          lp,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(0, -radius * 0.84),
            width: radius * 0.5,
            height: radius * 0.22,
          ),
          Paint()..color = Colors.white.withValues(alpha: 0.75),
        );

      case 3: // 화성 — 극관 + 협곡
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(0, -radius * 0.82),
            width: radius * 0.48,
            height: radius * 0.20,
          ),
          Paint()..color = Colors.white.withValues(alpha: 0.65),
        );
        canvas.drawPath(
          Path()
            ..moveTo(-radius * 0.5, radius * 0.05)
            ..lineTo(radius * 0.5, radius * 0.10),
          Paint()
            ..color = planet.darkColor.withValues(alpha: 0.45)
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.07
            ..strokeCap = StrokeCap.round,
        );

      case 4: // 목성 — 줄무늬 + 대적반
        const bands = [
          Color(0xFFF5CBA7),
          Color(0xFFD2691E),
          Color(0xFFF5DEB3),
          Color(0xFFCD853F),
          Color(0xFFF4A460),
          Color(0xFFC8956C),
        ];
        final bh = (radius * 2.2) / bands.length;
        for (int i = 0; i < bands.length; i++) {
          canvas.drawRect(
            Rect.fromLTWH(-radius, -radius + i * bh, radius * 2, bh),
            Paint()..color = bands[i].withValues(alpha: 0.55),
          );
        }
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(radius * 0.18, radius * 0.22),
            width: radius * 0.38,
            height: radius * 0.22,
          ),
          Paint()..color = const Color(0xFFB71C1C).withValues(alpha: 0.75),
        );

      case 5: // 토성 — 줄무늬
        const sb = [Color(0xFFFFF9C4), Color(0xFFDAA520), Color(0xFFF5DEB3)];
        final sbh = (radius * 2.2) / sb.length;
        for (int i = 0; i < sb.length; i++) {
          canvas.drawRect(
            Rect.fromLTWH(-radius, -radius + i * sbh, radius * 2, sbh),
            Paint()..color = sb[i].withValues(alpha: 0.4),
          );
        }

      case 6: // 천왕성
        canvas.drawRect(
          Rect.fromLTWH(-radius, -radius * 0.18, radius * 2, radius * 0.36),
          Paint()..color = Colors.white.withValues(alpha: 0.1),
        );

      case 7: // 해왕성 — 대흑반
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(-radius * 0.18, radius * 0.12),
            width: radius * 0.42,
            height: radius * 0.26,
          ),
          Paint()..color = Colors.black.withValues(alpha: 0.38),
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(radius * 0.3, -radius * 0.28),
            width: radius * 0.2,
            height: radius * 0.12,
          ),
          Paint()..color = Colors.white.withValues(alpha: 0.25),
        );
    }
  }

  void _renderSaturnRing(Canvas canvas, PlanetData planet) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 3.4,
        height: radius * 0.75,
      ),
      Paint()
        ..color = planet.lightColor.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.45,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 2.6,
        height: radius * 0.55,
      ),
      Paint()
        ..color = planet.darkColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.22,
    );
  }

  // ── 스포츠 볼 ─────────────────────────────────────────────────────────────

  void _renderSport(Canvas canvas, int index) {
    final sport = sportsBalls[index];

    canvas.drawCircle(
      Offset.zero,
      radius * 1.6,
      Paint()
        ..color = sport.trailColor.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 1.0,
          colors: [sport.lightColor, sport.baseColor, sport.darkColor],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );
    _renderSportSurface(canvas, index);
    canvas.restore();

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.2, -radius * 0.3),
        width: radius * 0.8,
        height: radius * 0.45,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06,
    );

    final nameColor = sport.nameDark
        ? Colors.black.withValues(alpha: 0.72)
        : Colors.white.withValues(alpha: 0.9);
    _renderName(canvas, textColor: nameColor);
  }

  void _renderSportSurface(Canvas canvas, int index) {
    switch (index) {
      case 0: // 야구공 — 2개의 붉은 아치 봉합선
        final seam = Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.08
          ..strokeCap = StrokeCap.round;
        // 왼쪽 아치
        canvas.drawPath(
          Path()
            ..moveTo(-radius * 0.25, -radius * 0.72)
            ..cubicTo(
              -radius * 0.65,
              -radius * 0.2,
              -radius * 0.65,
              radius * 0.2,
              -radius * 0.25,
              radius * 0.72,
            ),
          seam,
        );
        // 오른쪽 아치
        canvas.drawPath(
          Path()
            ..moveTo(radius * 0.25, -radius * 0.72)
            ..cubicTo(
              radius * 0.65,
              -radius * 0.2,
              radius * 0.65,
              radius * 0.2,
              radius * 0.25,
              radius * 0.72,
            ),
          seam,
        );
        // 봉합 틱 마크
        final tick = Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.055
          ..strokeCap = StrokeCap.round;
        for (int i = 1; i <= 4; i++) {
          final t = i / 5.0;
          final y = (-0.72 + 1.44 * t) * radius;
          final lx = (-0.45 + math.sin(t * math.pi) * (-0.18)) * radius;
          canvas.drawLine(
            Offset(lx - radius * 0.06, y - radius * 0.04),
            Offset(lx + radius * 0.05, y + radius * 0.07),
            tick,
          );
          canvas.drawLine(
            Offset(-lx + radius * 0.06, y - radius * 0.04),
            Offset(-lx - radius * 0.05, y + radius * 0.07),
            tick,
          );
        }

      case 1: // 축구공 — 오각형 패치
        final patch = Paint()..color = Colors.black.withValues(alpha: 0.82);
        canvas.drawPath(
          _polygonPath(5, radius * 0.24, Offset.zero, -math.pi / 2),
          patch,
        );
        for (int i = 0; i < 5; i++) {
          final a = (i * 72 - 90) * math.pi / 180;
          final cx = math.cos(a) * radius * 0.57;
          final cy = math.sin(a) * radius * 0.57;
          canvas.drawPath(
            _polygonPath(5, radius * 0.17, Offset(cx, cy), a + math.pi * 0.2),
            patch,
          );
        }

      case 2: // 농구공 — 봉합선 3개
        final seam = Paint()
          ..color = Colors.black.withValues(alpha: 0.80)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.075
          ..strokeCap = StrokeCap.round;
        // 수평 봉합선
        canvas.drawPath(
          Path()
            ..moveTo(-radius, 0)
            ..quadraticBezierTo(0, radius * 0.18, radius, 0),
          seam,
        );
        // 왼쪽 아치
        canvas.drawPath(
          Path()
            ..moveTo(0, -radius)
            ..cubicTo(
              -radius * 0.35,
              -radius * 0.28,
              -radius * 0.35,
              radius * 0.28,
              0,
              radius,
            ),
          seam,
        );
        // 오른쪽 아치
        canvas.drawPath(
          Path()
            ..moveTo(0, -radius)
            ..cubicTo(
              radius * 0.35,
              -radius * 0.28,
              radius * 0.35,
              radius * 0.28,
              0,
              radius,
            ),
          seam,
        );

      case 3: // 테니스공 — S자 봉합선
        canvas.drawPath(
          Path()
            ..moveTo(-radius * 0.55, -radius * 0.82)
            ..cubicTo(
              -radius * 0.55,
              -radius * 0.1,
              radius * 0.55,
              radius * 0.1,
              radius * 0.55,
              radius * 0.82,
            ),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.88)
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.12
            ..strokeCap = StrokeCap.round,
        );

      case 4: // 배구공 — 패널 + 봉합선
        final blue = Paint()
          ..color = const Color(0xFF1565C0).withValues(alpha: 0.55);
        // 왼쪽 파란 패널
        canvas.drawPath(
          Path()
            ..moveTo(-radius, -radius * 0.38)
            ..quadraticBezierTo(-radius * 0.12, 0, -radius, radius * 0.38)
            ..lineTo(-radius * 1.5, radius * 0.38)
            ..lineTo(-radius * 1.5, -radius * 0.38)
            ..close(),
          blue,
        );
        // 오른쪽 파란 패널
        canvas.drawPath(
          Path()
            ..moveTo(radius, -radius * 0.38)
            ..quadraticBezierTo(radius * 0.12, 0, radius, radius * 0.38)
            ..lineTo(radius * 1.5, radius * 0.38)
            ..lineTo(radius * 1.5, -radius * 0.38)
            ..close(),
          blue,
        );
        // 봉합선
        final sv = Paint()
          ..color = Colors.white.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.055;
        canvas.drawPath(
          Path()
            ..moveTo(-radius * 0.06, -radius)
            ..quadraticBezierTo(-radius * 0.12, 0, -radius * 0.06, radius),
          sv,
        );
        canvas.drawPath(
          Path()
            ..moveTo(radius * 0.06, -radius)
            ..quadraticBezierTo(radius * 0.12, 0, radius * 0.06, radius),
          sv,
        );

      case 5: // 골프공 — 딤플
        final dimple = Paint()
          ..color = const Color(0xFFAAAAAA).withValues(alpha: 0.45);
        final dr = radius * 0.09;
        final sp = radius * 0.27;
        for (int row = -3; row <= 3; row++) {
          for (int col = -3; col <= 3; col++) {
            final dx = col * sp + (row.isOdd ? sp / 2 : 0);
            final dy = row * sp;
            if (dx * dx + dy * dy < (radius * 0.84) * (radius * 0.84)) {
              canvas.drawCircle(Offset(dx, dy), dr, dimple);
            }
          }
        }

      case 6: // 당구공 — 흰 원 (이름이 그 위에 표시)
        canvas.drawCircle(
          Offset.zero,
          radius * 0.44,
          Paint()..color = Colors.white.withValues(alpha: 0.94),
        );

      case 7: // 볼링공 — 손가락 구멍 3개
        final hole = Paint()..color = Colors.black.withValues(alpha: 0.65);
        canvas.drawCircle(Offset(0, -radius * 0.36), radius * 0.13, hole);
        canvas.drawCircle(
          Offset(radius * 0.22, -radius * 0.10),
          radius * 0.10,
          hole,
        );
        canvas.drawCircle(
          Offset(-radius * 0.22, -radius * 0.10),
          radius * 0.10,
          hole,
        );
    }
  }

  // ── 8비트 픽셀 볼 ─────────────────────────────────────────────────────────

  void _renderPixel(Canvas canvas) {
    const gridN = 10;
    final pixSize = (radius * 2) / gridN;

    for (int row = 0; row < gridN; row++) {
      for (int col = 0; col < gridN; col++) {
        final cx = -radius + (col + 0.5) * pixSize;
        final cy = -radius + (row + 0.5) * pixSize;
        if (cx * cx + cy * cy > radius * radius) continue;

        final dist = math.sqrt(cx * cx + cy * cy);
        final Color pixColor;

        if (dist > radius * 0.82) {
          // 테두리 픽셀 — 어둡게
          pixColor = Color.lerp(color, Colors.black, 0.48)!;
        } else if (row <= 2 && col <= 3) {
          // 좌상단 — 하이라이트
          pixColor = Color.lerp(color, Colors.white, 0.62)!;
        } else if (row >= gridN - 3 && col >= gridN - 4) {
          // 우하단 — 그림자
          pixColor = Color.lerp(color, Colors.black, 0.42)!;
        } else {
          pixColor = color;
        }

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: pixSize * 0.9,
            height: pixSize * 0.9,
          ),
          Paint()..color = pixColor,
        );
      }
    }

    // 하드엣지 하이라이트 픽셀 (좌상단 2×1 블록)
    canvas.drawRect(
      Rect.fromLTWH(
        -radius + pixSize * 1.0,
        -radius + pixSize * 1.0,
        pixSize * 1.6,
        pixSize * 0.9,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        -radius + pixSize * 1.0,
        -radius + pixSize * 2.0,
        pixSize * 0.9,
        pixSize * 0.9,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );

    _renderName(canvas);
  }

  // ── 슬라임 ────────────────────────────────────────────────────────────────

  void _renderSlime(Canvas canvas) {
    final squish = _squishAmount.clamp(-0.35, 0.85);
    final wobble = _wobbleAmount.clamp(-0.35, 0.70);
    final blobPath = (squish.abs() > 0.005 || wobble.abs() > 0.005)
        ? _buildBlobPath(radius, squish, _squishAngle, wobble)
        : (Path()
            ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius)));

    // ── 인접 색상 생성 (글로우 + 내부 색 혼합 공용) ──
    final hsl = HSLColor.fromColor(color);
    final c1 = hsl
        .withHue((hsl.hue + 38) % 360)
        .withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0))
        .toColor();
    final c2 = hsl
        .withHue((hsl.hue - 32) % 360)
        .withLightness((hsl.lightness * 1.15).clamp(0.0, 1.0))
        .toColor();
    final c3 = hsl
        .withHue((hsl.hue + 75) % 360)
        .withSaturation((hsl.saturation * 0.85).clamp(0.0, 1.0))
        .toColor();

    // 1) 도깨비불 글로우 ─────────────────────────────────────────────
    //  a) 메인 아우라 — blob 형태를 따르는 넓은 글로우
    canvas.drawPath(
      blobPath,
      Paint()
        ..color = color.withValues(alpha: 0.14)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.0),
    );
    //  b) 위습 텐드릴 — 6방향으로 뻗는 불꽃 혀
    final wispColors = [color, c1, c2, c3, c1, c2];
    final seed = (color.toARGB32() & 0xFF) * 0.042; // 공마다 다른 배치
    for (int i = 0; i < 6; i++) {
      final a = (i / 6.0) * math.pi * 2 + seed;
      final dist = radius * (0.75 + (i % 3) * 0.30);
      final wr = radius * (0.22 + (i % 2) * 0.14);
      canvas.drawCircle(
        Offset(math.cos(a) * dist, math.sin(a) * dist),
        wr,
        Paint()
          ..color = wispColors[i].withValues(alpha: 0.18)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, wr * 1.3),
      );
    }
    //  c) 밝은 코어 — 본체 안쪽의 강한 빛
    canvas.drawPath(
      blobPath,
      Paint()
        ..color = Color.lerp(color, Colors.white, 0.35)!.withValues(alpha: 0.10)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.35),
    );

    // 2) 본체 — 반투명 젤리 그라데이션
    canvas.drawPath(
      blobPath,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.35),
          radius: 1.0,
          colors: [
            Color.lerp(color, Colors.white, 0.48)!.withValues(alpha: 0.80),
            color.withValues(alpha: 0.72),
            Color.lerp(color, Colors.black, 0.28)!.withValues(alpha: 0.88),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // 3) 내부 색 혼합 — 인접 색상이 섞이는 유기적 액체
    canvas.save();
    canvas.clipPath(blobPath);
    canvas.drawCircle(
      Offset(-radius * 0.32, -radius * 0.12),
      radius * 0.55,
      Paint()
        ..color = c1.withValues(alpha: 0.52)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.35),
    );
    canvas.drawCircle(
      Offset(radius * 0.28, radius * 0.22),
      radius * 0.48,
      Paint()
        ..color = c2.withValues(alpha: 0.28)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.30),
    );
    canvas.drawCircle(
      Offset(radius * 0.05, -radius * 0.38),
      radius * 0.40,
      Paint()
        ..color = c3.withValues(alpha: 0.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.25),
    );
    canvas.restore();

    // 4) 젤리 외곽선 — 인접 색 틴트
    canvas.drawPath(
      blobPath,
      Paint()
        ..color = Color.lerp(c1, Colors.black, 0.38)!.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.10,
    );

    // 5) 상단 큰 하이라이트 (광택) — 고정 위치
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.18, -radius * 0.30),
        width: radius * 0.72,
        height: radius * 0.36,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );

    // 6) 작은 반짝 포인트
    canvas.drawCircle(
      Offset(-radius * 0.28, -radius * 0.36),
      radius * 0.10,
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );

    _renderName(canvas);
  }

  /// 유기적 액체 변형 경로 생성 (12-point Catmull-Rom 스플라인)
  ///
  /// squish > 0 (충돌): 앞면 납작, 옆면 불룩, 뒷면 살짝 팽창
  /// squish < 0 (반동): 앞면 팽창, 옆면 수축 → 세로로 늘어남
  Path _buildBlobPath(double r, double squish, double angle, double wobble) {
    const n = 16; // 16점 → 더 부드러운 곡선
    final pts = List<Offset>.generate(n, (i) {
      final theta = (i / n) * 2 * math.pi;
      final phi = theta - angle;
      final c = math.cos(phi);
      final s = math.sin(phi);

      // mode 1 (dipole): 충돌 방향 압축 + 수직 팽창
      final axial = c > 0 ? -squish * c * c * 0.48 : squish * c * c * 0.10;
      final lateral = squish * s * s * 0.42;

      // mode 2 (quadrupole): cos(2φ) — 사각형↔마름모 출렁임
      final quad = wobble * math.cos(2 * phi) * 0.28;

      final rr = r * (1.0 + axial + lateral + quad).clamp(0.2, 1.95);
      return Offset(rr * math.cos(theta), rr * math.sin(theta));
    });

    return _catmullRomClosed(pts);
  }

  /// 닫힌 Catmull-Rom 스플라인 → cubic Bézier Path
  Path _catmullRomClosed(List<Offset> pts) {
    final n = pts.length;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n; i++) {
      final p0 = pts[(i - 1 + n) % n];
      final p1 = pts[i];
      final p2 = pts[(i + 1) % n];
      final p3 = pts[(i + 2) % n];
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6.0,
        p1.dy + (p2.dy - p0.dy) / 6.0,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6.0,
        p2.dy - (p3.dy - p1.dy) / 6.0,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    path.close();
    return path;
  }

  // ── 과일 ──────────────────────────────────────────────────────────────────

  void _renderFruit(Canvas canvas, int index) {
    final fruit = fruits[index % fruits.length];
    final clipCircle = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
    final textColor = fruit.nameDark
        ? Colors.black.withValues(alpha: 0.70)
        : null;

    // 공통: 글로우
    canvas.drawCircle(
      Offset.zero,
      radius * 1.5,
      Paint()
        ..color = fruit.baseColor.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    switch (index % fruits.length) {
      // ── 0: 사과 ────────────────────────────────────────────────────────────
      case 0:
        _fruitBody(canvas, fruit);
        // 줄기
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(0, -radius * 0.88),
              width: radius * 0.09,
              height: radius * 0.28,
            ),
            Radius.circular(radius * 0.04),
          ),
          Paint()..color = const Color(0xFF5D4037),
        );
        // 잎
        canvas.save();
        canvas.translate(radius * 0.16, -radius * 0.90);
        canvas.rotate(-0.55);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: radius * 0.30,
            height: radius * 0.14,
          ),
          Paint()..color = const Color(0xFF4CAF50),
        );
        canvas.restore();

      // ── 1: 배 ──────────────────────────────────────────────────────────────
      case 1:
        _fruitBody(canvas, fruit);
        // 노란빛 패치
        canvas.save();
        canvas.clipPath(clipCircle);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(radius * 0.12, radius * 0.08),
            width: radius * 0.55,
            height: radius * 0.50,
          ),
          Paint()..color = const Color(0xFFFFF9C4).withValues(alpha: 0.28),
        );
        canvas.restore();
        // 줄기
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(0, -radius * 0.88),
              width: radius * 0.08,
              height: radius * 0.24,
            ),
            Radius.circular(radius * 0.04),
          ),
          Paint()..color = const Color(0xFF5D4037),
        );

      // ── 2: 파인애플 ─────────────────────────────────────────────────────────
      case 2:
        _fruitBody(canvas, fruit);
        // 크로스해치 무늬
        canvas.save();
        canvas.clipPath(
          Path()..addOval(
            Rect.fromCircle(center: Offset.zero, radius: radius * 0.90),
          ),
        );
        final texP = Paint()
          ..color = const Color(0xFFE65100).withValues(alpha: 0.30)
          ..strokeWidth = radius * 0.045
          ..style = PaintingStyle.stroke;
        final step = radius * 0.24;
        for (double d = -radius * 1.5; d < radius * 1.5; d += step) {
          canvas.drawLine(
            Offset(d, -radius * 1.5),
            Offset(d + radius * 1.5, radius * 1.5),
            texP,
          );
          canvas.drawLine(
            Offset(d, radius * 1.5),
            Offset(d + radius * 1.5, -radius * 1.5),
            texP,
          );
        }
        canvas.restore();
        // 왕관 잎
        final crownP = Paint()..color = const Color(0xFF388E3C);
        for (int j = 0; j < 5; j++) {
          final xOff = (j - 2) * radius * 0.19;
          final h = (j % 2 == 0 ? 0.40 : 0.30) * radius;
          canvas.save();
          canvas.translate(xOff, -radius * 0.90);
          canvas.rotate((j - 2) * 0.22);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(0, -h * 0.5),
              width: radius * 0.12,
              height: h,
            ),
            crownP,
          );
          canvas.restore();
        }

      // ── 3: 오렌지 ───────────────────────────────────────────────────────────
      case 3:
        _fruitBody(canvas, fruit);
        // 6 구획선
        canvas.save();
        canvas.clipPath(
          Path()..addOval(
            Rect.fromCircle(center: Offset.zero, radius: radius * 0.86),
          ),
        );
        final segP = Paint()
          ..color = const Color(0xFFBF360C).withValues(alpha: 0.38)
          ..strokeWidth = radius * 0.025
          ..style = PaintingStyle.stroke;
        for (int j = 0; j < 6; j++) {
          final a = j * math.pi / 3;
          canvas.drawLine(
            Offset.zero,
            Offset(radius * math.cos(a), radius * math.sin(a)),
            segP,
          );
        }
        canvas.restore();
        // 배꼽
        canvas.drawCircle(
          Offset(0, radius * 0.64),
          radius * 0.12,
          Paint()..color = const Color(0xFFBF360C).withValues(alpha: 0.65),
        );
        canvas.drawCircle(
          Offset(0, radius * 0.64),
          radius * 0.06,
          Paint()..color = const Color(0xFF7F0000).withValues(alpha: 0.55),
        );

      // ── 4: 레몬 ─────────────────────────────────────────────────────────────
      case 4:
        _fruitBody(canvas, fruit);
        // 표면 질감 (황금각 배열 점들)
        canvas.save();
        canvas.clipPath(clipCircle);
        final poreP = Paint()
          ..color = const Color(0xFFF9A825).withValues(alpha: 0.45);
        for (int j = 0; j < 22; j++) {
          final a = j * 2.399;
          final rd = math.sqrt((j + 0.5) / 22) * radius * 0.78;
          canvas.drawCircle(
            Offset(rd * math.cos(a), rd * math.sin(a)),
            radius * 0.035,
            poreP,
          );
        }
        canvas.restore();
        // 양쪽 끝 꼭지
        canvas.drawCircle(
          Offset(0, -radius * 0.82),
          radius * 0.10,
          Paint()..color = const Color(0xFFF9A825).withValues(alpha: 0.75),
        );
        canvas.drawCircle(
          Offset(0, radius * 0.82),
          radius * 0.10,
          Paint()..color = const Color(0xFFF9A825).withValues(alpha: 0.75),
        );

      // ── 5: 키위 (단면) ───────────────────────────────────────────────────────
      case 5:
        // 갈색 껍질
        canvas.drawCircle(
          Offset.zero,
          radius,
          Paint()..color = const Color(0xFF5D4037),
        );
        // 녹색 과육
        canvas.drawCircle(
          Offset.zero,
          radius * 0.84,
          Paint()
            ..shader =
                const RadialGradient(
                  colors: [Color(0xFF9CCC65), Color(0xFF558B2F)],
                  stops: [0.3, 1.0],
                ).createShader(
                  Rect.fromCircle(center: Offset.zero, radius: radius * 0.84),
                ),
        );
        // 12개 구획선
        canvas.save();
        canvas.clipPath(
          Path()..addOval(
            Rect.fromCircle(center: Offset.zero, radius: radius * 0.80),
          ),
        );
        final kSeg = Paint()
          ..color = const Color(0xFF33691E).withValues(alpha: 0.55)
          ..strokeWidth = radius * 0.018
          ..style = PaintingStyle.stroke;
        for (int j = 0; j < 12; j++) {
          final a = j * math.pi / 6;
          canvas.drawLine(
            Offset.zero,
            Offset(radius * 0.78 * math.cos(a), radius * 0.78 * math.sin(a)),
            kSeg,
          );
        }
        canvas.restore();
        // 씨앗 (12개)
        final seedP = Paint()
          ..color = const Color(0xFF1A0A00).withValues(alpha: 0.85);
        for (int j = 0; j < 12; j++) {
          final a = j * math.pi / 6 + math.pi / 12;
          final sx = radius * 0.64 * math.cos(a);
          final sy = radius * 0.64 * math.sin(a);
          canvas.save();
          canvas.translate(sx, sy);
          canvas.rotate(a + math.pi / 2);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: radius * 0.06,
              height: radius * 0.10,
            ),
            seedP,
          );
          canvas.restore();
        }
        // 하얀 심
        canvas.drawCircle(
          Offset.zero,
          radius * 0.20,
          Paint()..color = Colors.white.withValues(alpha: 0.90),
        );

      // ── 6: 딸기 ─────────────────────────────────────────────────────────────
      case 6:
        _fruitBody(canvas, fruit);
        // 꼭지 잎 (calyx)
        final calP = Paint()..color = const Color(0xFF388E3C);
        for (int j = 0; j < 4; j++) {
          final a = j * math.pi / 2 + math.pi / 4;
          canvas.save();
          canvas.translate(
            math.cos(a) * radius * 0.16,
            -radius * 0.78 + math.sin(a) * radius * 0.10,
          );
          canvas.rotate(a + math.pi / 2);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(0, -radius * 0.12),
              width: radius * 0.13,
              height: radius * 0.24,
            ),
            calP,
          );
          canvas.restore();
        }
        // 씨앗 (황금각)
        final dotP = Paint()
          ..color = const Color(0xFFFFF176).withValues(alpha: 0.90);
        for (int j = 0; j < 12; j++) {
          final a = j * 2.399;
          final rd = math.sqrt((j + 0.5) / 12) * radius * 0.70;
          final sx = rd * math.cos(a);
          final sy = rd * math.sin(a) + radius * 0.04;
          if (sy < radius * 0.62) {
            canvas.save();
            canvas.translate(sx, sy);
            canvas.rotate(a);
            canvas.drawOval(
              Rect.fromCenter(
                center: Offset.zero,
                width: radius * 0.055,
                height: radius * 0.09,
              ),
              dotP,
            );
            canvas.restore();
          }
        }

      // ── 7: 코코넛 ───────────────────────────────────────────────────────────
      case 7:
        _fruitBody(canvas, fruit);
        // 섬유 결 (중심에서 바깥으로 휘는 선)
        canvas.save();
        canvas.clipPath(clipCircle);
        final fibP = Paint()
          ..color = const Color(0xFF3E2723).withValues(alpha: 0.40)
          ..strokeWidth = radius * 0.028
          ..style = PaintingStyle.stroke;
        for (int j = 0; j < 8; j++) {
          final a = j * math.pi / 4;
          final path = Path()
            ..moveTo(0, 0)
            ..cubicTo(
              radius * 0.45 * math.cos(a - 0.4),
              radius * 0.45 * math.sin(a - 0.4),
              radius * 0.72 * math.cos(a + 0.3),
              radius * 0.72 * math.sin(a + 0.3),
              radius * math.cos(a),
              radius * math.sin(a),
            );
          canvas.drawPath(path, fibP);
        }
        canvas.restore();
        // 3개 눈
        final eyeP = Paint()
          ..color = const Color(0xFF1A0A00).withValues(alpha: 0.80);
        for (final pos in [
          Offset(0, -radius * 0.28),
          Offset(-radius * 0.24, radius * 0.18),
          Offset(radius * 0.24, radius * 0.18),
        ]) {
          canvas.drawCircle(pos, radius * 0.09, eyeP);
          canvas.drawCircle(
            pos,
            radius * 0.05,
            Paint()..color = Colors.black.withValues(alpha: 0.60),
          );
        }

      // ── 8: 두리안 ───────────────────────────────────────────────────────────
      case 8:
        _fruitBody(canvas, fruit);
        // 가시 무늬
        canvas.save();
        canvas.clipPath(
          Path()..addOval(
            Rect.fromCircle(center: Offset.zero, radius: radius * 0.88),
          ),
        );
        final spkP = Paint()
          ..color = const Color(0xFF827717).withValues(alpha: 0.50)
          ..strokeWidth = radius * 0.028
          ..style = PaintingStyle.stroke;
        final sp = radius * 0.27;
        for (double sx = -radius; sx <= radius; sx += sp) {
          for (double sy = -radius; sy <= radius; sy += sp) {
            if (sx * sx + sy * sy < (radius * 0.82) * (radius * 0.82)) {
              final spikeH = radius * 0.15;
              final path = Path()
                ..moveTo(sx - radius * 0.08, sy + spikeH * 0.35)
                ..lineTo(sx, sy - spikeH)
                ..lineTo(sx + radius * 0.08, sy + spikeH * 0.35);
              canvas.drawPath(path, spkP);
            }
          }
        }
        canvas.restore();

      // ── 9: 바나나 (단면) ─────────────────────────────────────────────────────
      case 9:
        // 노란 바탕
        canvas.drawCircle(
          Offset.zero,
          radius,
          Paint()
            ..shader =
                const RadialGradient(
                  center: Alignment(-0.2, -0.3),
                  colors: [
                    Color(0xFFFFFF8D),
                    Color(0xFFFDD835),
                    Color(0xFFF57F17),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ).createShader(
                  Rect.fromCircle(center: Offset.zero, radius: radius),
                ),
        );
        // 3구획 Y자 단면
        final banP = Paint()
          ..color = const Color(0xFFFFF9C4).withValues(alpha: 0.88);
        for (int j = 0; j < 3; j++) {
          final a = j * 2 * math.pi / 3 - math.pi / 2;
          final cx = math.cos(a) * radius * 0.20;
          final cy = math.sin(a) * radius * 0.20;
          final tx = math.cos(a) * radius * 0.70;
          final ty = math.sin(a) * radius * 0.70;
          final bw = radius * 0.22;
          final path = Path()
            ..moveTo(cx, cy)
            ..cubicTo(
              cx - bw * math.sin(a),
              cy + bw * math.cos(a),
              tx - bw * 0.5 * math.sin(a),
              ty + bw * 0.5 * math.cos(a),
              tx,
              ty,
            )
            ..cubicTo(
              tx + bw * 0.5 * math.sin(a),
              ty - bw * 0.5 * math.cos(a),
              cx + bw * math.sin(a),
              cy - bw * math.cos(a),
              cx,
              cy,
            );
          canvas.drawPath(path, banP);
        }
        // 중심점
        canvas.drawCircle(
          Offset.zero,
          radius * 0.09,
          Paint()..color = const Color(0xFFF57F17).withValues(alpha: 0.85),
        );
        // 외곽선
        canvas.drawCircle(
          Offset.zero,
          radius,
          Paint()
            ..color = const Color(0xFFF57F17).withValues(alpha: 0.50)
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.07,
        );
    }

    // 키위·바나나는 하이라이트를 각자 처리 → 나머지는 공통 적용
    if (index % fruits.length != 5 && index % fruits.length != 9) {
      _fruitHighlight(canvas);
    }
    _renderName(canvas, textColor: textColor);
  }

  /// 과일 공통 구체 바디
  void _fruitBody(Canvas canvas, FruitData fruit) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.28, -0.38),
          radius: 1.0,
          colors: [fruit.lightColor, fruit.baseColor, fruit.darkColor],
          stops: const [0.0, 0.50, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = fruit.darkColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.07,
    );
  }

  /// 과일 공통 하이라이트
  void _fruitHighlight(Canvas canvas) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.20, -radius * 0.30),
        width: radius * 0.88,
        height: radius * 0.46,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset(-radius * 0.30, -radius * 0.35),
      radius * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.70),
    );
  }

  // ── 헬퍼 ──────────────────────────────────────────────────────────────────

  /// 정다각형 Path (sides 개 꼭짓점)
  Path _polygonPath(int sides, double r, Offset center, double startAngle) {
    final path = Path();
    for (int i = 0; i <= sides; i++) {
      final a = startAngle + (2 * math.pi * i / sides);
      final x = center.dx + r * math.cos(a);
      final y = center.dy + r * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  /// 이름 첫 글자 렌더링
  void _renderName(Canvas canvas, {Color? textColor}) {
    if (name.isEmpty) return;
    final tc = textColor ?? Colors.white.withValues(alpha: 0.9);
    final shadowColor = (tc.a > 0.5 ? Colors.black : Colors.white).withValues(
      alpha: 0.25,
    );

    final shadow = TextPainter(
      text: TextSpan(
        text: name[0],
        style: TextStyle(
          color: shadowColor,
          fontSize: radius * 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    shadow.paint(
      canvas,
      Offset(-shadow.width / 2 + 0.03, -shadow.height / 2 + 0.03),
    );

    final text = TextPainter(
      text: TextSpan(
        text: name[0],
        style: TextStyle(
          color: tc,
          fontSize: radius * 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(-text.width / 2, -text.height / 2));
  }

  // ── 트레일 ────────────────────────────────────────────────────────────────

  void _renderTrail(Canvas canvas) {
    if (_trail.length < 3) return;
    final speed = body.linearVelocity.length;
    final speedAlpha = (speed / 15.0).clamp(0.0, 1.0);
    if (speedAlpha < 0.05) return;

    canvas.save();
    canvas.rotate(-body.angle);

    final points = <Offset>[];
    for (final p in _trail) {
      final d = p - body.position;
      points.add(Offset(d.x, d.y));
    }
    points.add(Offset.zero);

    final count = points.length;
    final angularVel = body.angularVelocity;
    final leftEdge = <Offset>[];
    final rightEdge = <Offset>[];

    for (int i = 0; i < count; i++) {
      final progress = i / (count - 1);
      final halfWidth = radius * 1.2 * progress * progress;
      Offset dir;
      if (i < count - 1) {
        dir = points[i + 1] - points[i];
      } else {
        dir = points[i] - points[i - 1];
      }
      final len = dir.distance;
      if (len < 0.001) {
        leftEdge.add(points[i]);
        rightEdge.add(points[i]);
        continue;
      }
      final nx = -dir.dy / len;
      final ny = dir.dx / len;
      final twistPhase = (1.0 - progress) * 6.0;
      final twistStrength = (angularVel.abs() / 8.0).clamp(0.0, 1.0);
      final twist = math.sin(twistPhase) * twistStrength;
      final leftScale = (1.0 + twist).clamp(0.1, 2.0);
      final rightScale = (1.0 - twist).clamp(0.1, 2.0);
      leftEdge.add(
        Offset(
          points[i].dx + nx * halfWidth * leftScale,
          points[i].dy + ny * halfWidth * leftScale,
        ),
      );
      rightEdge.add(
        Offset(
          points[i].dx - nx * halfWidth * rightScale,
          points[i].dy - ny * halfWidth * rightScale,
        ),
      );
    }

    final path = Path();
    path.moveTo(leftEdge.first.dx, leftEdge.first.dy);
    for (int i = 0; i < leftEdge.length - 1; i++) {
      final mid = Offset(
        (leftEdge[i].dx + leftEdge[i + 1].dx) / 2,
        (leftEdge[i].dy + leftEdge[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(leftEdge[i].dx, leftEdge[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(leftEdge.last.dx, leftEdge.last.dy);
    path.lineTo(rightEdge.last.dx, rightEdge.last.dy);
    for (int i = rightEdge.length - 1; i > 0; i--) {
      final mid = Offset(
        (rightEdge[i].dx + rightEdge[i - 1].dx) / 2,
        (rightEdge[i].dy + rightEdge[i - 1].dy) / 2,
      );
      path.quadraticBezierTo(rightEdge[i].dx, rightEdge[i].dy, mid.dx, mid.dy);
    }
    path.close();

    final rect = path.getBounds();
    if (rect.isEmpty) {
      canvas.restore();
      return;
    }

    final tailPos = points.first;
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment(tailPos.dx.sign, tailPos.dy.sign),
          end: Alignment.center,
          colors: [
            color.withValues(alpha: 0.0),
            color.withValues(alpha: 0.25 * speedAlpha),
            color.withValues(alpha: 0.45 * speedAlpha),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.12 * speedAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.15
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.restore();
  }
}
