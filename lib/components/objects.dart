import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:toruru/components/balls.dart';
import 'package:toruru/components/particles.dart';

abstract class Objects extends BodyComponent with ContactCallbacks {}

class TriangleObject extends Objects {
  @override
  final Vector2 position;

  final double size;

  TriangleObject(this.position, {this.size = 2.0});

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..set([
        Vector2(0, -size),
        Vector2(-size, size),
        Vector2(size, size),
      ]);

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = position
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.6
        ..friction = 0.1,
    );
  }

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..moveTo(0, -size)
      ..lineTo(-size, size)
      ..lineTo(size, size)
      ..close();

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFF4ECDC4).withValues(alpha: 0.15),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF4ECDC4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.05,
    );
  }
}

class CircleObject extends Objects {
  @override
  final Vector2 position;

  final double radius;

  CircleObject(this.position, {this.radius = 1.5});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = position
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.6
        ..friction = 0.1,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = const Color(0xFFFFA726).withValues(alpha: 0.15),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = const Color(0xFFFFA726)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.07,
    );
    canvas.drawCircle(
      Offset(-radius * 0.3, -radius * 0.3),
      radius * 0.25,
      Paint()..color = Colors.white.withValues(alpha: 0.2),
    );
  }
}

class PlankObject extends Objects {
  @override
  final Vector2 position;
  final double width;
  @override
  final double angle;

  PlankObject(this.position, {this.width = 5.0, this.angle = 0});

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        width / 2,
        0.2,
        Vector2.zero(),
        0,
      );

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = position
        ..angle = angle
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.4
        ..friction = 0.05,
    );
  }

  @override
  void render(Canvas canvas) {
    // canvas.save();
    // canvas.rotate(angle);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: 0.4),
      Paint()..color = const Color(0xFFFF6B6B).withValues(alpha: 0.9),
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: 0.4),
      Paint()
        ..color = const Color(0xFFFF6B6B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.06,
    );
    // canvas.restore();
  }
}

class RotatingObject extends Objects {
  @override
  final Vector2 position;
  final double width;
  final double angularSpeed;

  RotatingObject(
    this.position, {
    this.width = 6.0,
    this.angularSpeed = 1.5,
  });

  @override
  Body createBody() {
    final shape1 = PolygonShape()
      ..setAsBox(
        width / 2,
        0.25,
        Vector2.zero(),
        0,
      );
    final shape2 = PolygonShape()
      ..setAsBox(
        0.25,
        width / 2,
        Vector2.zero(),
        0,
      );

    return world.createBody(
        BodyDef()
          ..type = BodyType.kinematic
          ..position = position
          ..angularVelocity = angularSpeed
          ..userData = this,
      )
      ..createFixture(FixtureDef(shape1)..restitution = 0.5)
      ..createFixture(FixtureDef(shape2)..restitution = 0.5);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.rotate(body.angle);

    final paint = Paint()..color = const Color(0xFF4ECDC4);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: 0.5),
      paint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 0.5, height: width),
      paint,
    );

    canvas.restore();
  }
}

class MovingObject extends Objects {
  @override
  final Vector2 position;
  final double width;
  final double height;
  final bool horizontal;
  final double range;
  final double speed;

  late Vector2 _startPos;

  MovingObject(
    this.position, {
    this.width = 5.0,
    this.height = 0.4,
    this.horizontal = true,
    this.range = 4.0,
    this.speed = 3.0,
  });

  @override
  Body createBody() {
    _startPos = position.clone();

    final shape = PolygonShape()
      ..setAsBox(width / 2, height / 2, Vector2.zero(), 0);

    return world.createBody(
      BodyDef()
        ..type = BodyType.kinematic
        ..position = position
        ..linearVelocity = horizontal ? Vector2(speed, 0) : Vector2(0, speed)
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.4
        ..friction = 0.0,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final pos = body.position;
    final vel = body.linearVelocity;

    if (horizontal) {
      if (pos.x > _startPos.x + range) {
        body.linearVelocity = Vector2(-speed, vel.y);
      } else if (pos.x < _startPos.x - range) {
        body.linearVelocity = Vector2(speed, vel.y);
      }
    } else {
      if (pos.y > _startPos.y + range) {
        body.linearVelocity = Vector2(vel.x, -speed);
      } else if (pos.y < _startPos.y - range) {
        body.linearVelocity = Vector2(vel.x, speed);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      Paint()..color = const Color(0xFF29B6F6),
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      Paint()
        ..color = const Color(0xFF29B6F6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.06,
    );
  }
}

class BounceObject extends Objects {
  @override
  final Vector2 position;
  final double width;
  final double boostForce;

  bool _flash = false;
  double _flashTimer = 0;

  BounceObject(
    this.position, {
    this.width = 4.0,
    this.boostForce = 60.0,
  });

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBox(width / 2, 0.3, Vector2.zero(), 0);

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = position
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.0
        ..friction = 0.0,
    );
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      final vel = other.body.linearVelocity;
      other.body.linearVelocity = Vector2(vel.x, -boostForce);
      _flash = true;
      _flashTimer = 0;

      world.add(
        GameParticles.bounce(position: body.position.clone(), width: width),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_flash) {
      _flashTimer += dt;
      if (_flashTimer > 0.15) {
        _flash = false;
        _flashTimer = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final color = _flash ? Colors.white : const Color(0xFFFF6B6B);

    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: 0.6),
      Paint()..color = color,
    );

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: _flash ? 1.0 : 0.4)
      ..strokeWidth = 0.08;

    for (int i = -2; i <= 2; i++) {
      canvas.drawLine(
        Offset(i * width * 0.18, -0.3),
        Offset(i * width * 0.18, 0.3),
        linePaint,
      );
    }
  }
}

class BreakableWallObject extends Objects {
  @override
  final Vector2 position;
  final double width;
  final int maxHits;

  int _currentHits = 0;
  bool _broken = false;

  BreakableWallObject(
    this.position, {
    this.width = 5.0,
    this.maxHits = 3,
  });

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        width / 2,
        0.25,
        Vector2.zero(),
        0,
      );

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = position
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.3
        ..friction = 0.0,
    );
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball && !_broken) {
      _currentHits++;

      if (_currentHits >= maxHits) {
        _broken = true;

        world.add(
          GameParticles.destruction(
            position: body.position.clone(),
            width: width,
          ),
        );
        // 다음 프레임에서 제거
        // 업데이트 중 바로 제거하면 에러
        Future.microtask(() => removeFromParent());
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_broken) return;

    final hpRatio = 1.0 - (_currentHits / maxHits);
    final color = Color.lerp(
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      hpRatio,
    )!;

    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: 0.5),
      Paint()..color = color.withValues(alpha: 0.5),
    );

    // 균열
    if (_currentHits > 0) {
      final crakPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..strokeWidth = 0.04
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < _currentHits; i++) {
        final xPos = (i - _currentHits / 2) * (width / (maxHits + 1));
        canvas.drawLine(
          Offset(xPos, -0.25),
          Offset(xPos + 0.15, 0.25),
          crakPaint,
        );
      }

      // 남은 체력
      final tp = TextPainter(
        text: TextSpan(
          text: '${maxHits - _currentHits}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    }
  }
}

class SpeedFieldObject extends Objects {
  @override
  final Vector2 position;
  final double radius; // 영향 범위
  final double multiplier; // > 1.0 가속, < 1.0 감속

  double _wavePhase = 0; // 파동 애니메이션

  SpeedFieldObject(
    this.position, {
    this.radius = 3.0,
    this.multiplier = 1.5,
  });

  bool get isAccel => multiplier > 1.0;

  Color get _baseColor =>
      isAccel ? const Color(0xFFFF6B6B) : const Color(0xFF7B6CF6);

  @override
  Body createBody() {
    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = position
        ..userData = this,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 파동 애니메이션
    _wavePhase += dt * 2.0;
    if (_wavePhase > 1.0) _wavePhase -= 1.0;

    // 범위 안 속도 변경
    final balls = world.children.whereType<Ball>();
    for (final ball in balls) {
      final dist = ball.body.position.distanceTo(position);
      if (dist < radius) {
        // 중심에 가까울수록 효과 셈
        final strength = 1.0 - (dist / radius);
        final vel = ball.body.linearVelocity;
        final speed = vel.length;
        if (speed < 0.1) continue;

        double targetMultiplier;
        if (isAccel) {
          // 가속
          targetMultiplier = 1.0 + (multiplier - 1.0) * strength * dt * 3;
        } else {
          // 감속
          targetMultiplier = 1.0 - (1.0 - multiplier) * strength * dt * 3;
        }

        ball.body.linearVelocity = vel * targetMultiplier;

        // 제한
        if (ball.body.linearVelocity.length > 25.0) {
          ball.body.linearVelocity =
              ball.body.linearVelocity.normalized() * 25.0;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = _baseColor.withValues(alpha: 0.08),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = _baseColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.05,
    );

    // 팡동 링
    for (int i = 0; i < 3; i++) {
      final phase = (_wavePhase + i / 3.0) % 1.0;
      final waveRadius = radius * phase;
      final alpha = (1.0 - phase) * 0.3;

      canvas.drawCircle(
        Offset.zero,
        waveRadius,
        Paint()
          ..color = _baseColor.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.06,
      );
      // 중심 아이콘
      canvas.drawCircle(
        Offset.zero,
        radius * 0.12,
        Paint()..color = _baseColor.withValues(alpha: 0.6),
      );

      // 화살표 표시 (가속: ▲▲, 감속: ▼▼)
      final arrowPaint = Paint()
        ..color = _baseColor.withValues(alpha: 0.5)
        ..strokeWidth = 0.06
        ..style = PaintingStyle.stroke;

      if (isAccel) {
        // 위쪽 화살표 2개
        for (final offset in [-0.15, 0.15]) {
          final path = Path()
            ..moveTo(offset, 0.1)
            ..lineTo(offset, -0.2)
            ..moveTo(offset - 0.1, -0.1)
            ..lineTo(offset, -0.2)
            ..lineTo(offset + 0.1, -0.1);
          canvas.drawPath(path, arrowPaint);
        }
      } else {
        // 아래쪽 화살표 2개
        for (final offset in [-0.15, 0.15]) {
          final path = Path()
            ..moveTo(offset, -0.1)
            ..lineTo(offset, 0.2)
            ..moveTo(offset - 0.1, 0.1)
            ..lineTo(offset, 0.2)
            ..lineTo(offset + 0.1, 0.1);
          canvas.drawPath(path, arrowPaint);
        }
      }
    }
  }
}

class WormholeObject extends Objects {
  final Vector2 entryPos;
  final Vector2 exitPos;
  final double radius;
  final Color color;

  double _spinPhase = 0;
  double _cooldown = 0;

  WormholeObject({
    required this.entryPos,
    required this.exitPos,
    this.radius = 1.5,
    this.color = const Color(0xFF9C27B0),
  });

  @override
  Body createBody() {
    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = entryPos
        ..userData = this,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spinPhase += dt * 3.0;
    if (_cooldown > 0) _cooldown -= dt;

    final balls = world.children.whereType<Ball>();
    for (final ball in balls) {
      final dist = ball.body.position.distanceTo(entryPos);
      if (dist < radius * 0.5 && _cooldown <= 0) {
        // 입구
        world.add(GameParticles.warp(position: entryPos.clone()));

        final vel = ball.body.linearVelocity.clone();
        ball.body.setTransform(exitPos, 0);
        ball.body.linearVelocity = vel;
        _cooldown = 1.0;

        // 출구
        world.add(GameParticles.warp(position: exitPos.clone()));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _drawPortal(canvas, Offset.zero, radius, color);
  }

  void _drawPortal(Canvas canvas, Offset center, double r, Color c) {
    canvas.drawCircle(
      center,
      r,
      Paint()..color = c.withValues(alpha: 0.1),
    );

    for (int i = 0; i < 4; i++) {
      final phase = (_spinPhase + i / 4.0) % 1.0;
      final ringRadius = r * (0.3 + phase * 0.7);
      final alpha = (1.0 - phase) * 0.5;

      canvas.drawCircle(
        center,
        ringRadius,
        Paint()
          ..color = c.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.08,
      );
    }

    canvas.drawCircle(
      center,
      r * 0.15,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
  }
}

class WormholeExitObject extends Objects {
  final Vector2 pos;
  final double radius;
  final Color color;

  double _spinPhase = 0;

  WormholeExitObject({
    required this.pos,
    this.radius = 1.5,
    this.color = const Color(0xFF9C27B0),
  });

  @override
  Body createBody() {
    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = pos
        ..userData = this,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spinPhase += dt * 3.0;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = color.withValues(alpha: 0.08),
    );

    for (int i = 0; i < 4; i++) {
      final phase = (_spinPhase + i / 4.0) % 1.0;
      final ringRadius = radius * (1.0 - phase * 0.7);
      final alpha = phase * 0.4;

      canvas.drawCircle(
        Offset.zero,
        ringRadius,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.08,
      );
    }

    canvas.drawCircle(
      Offset.zero,
      radius * 0.15,
      Paint()..color = Colors.white.withValues(alpha: 0.4),
    );
  }
}

class FlipperObject extends Objects {
  @override
  final Vector2 position; // 피벗(고정점) 위치
  final double width;
  final double interval; // 작동 간격 (초)
  final bool isLeft; // true: 왼쪽 피벗, false: 오른쪽 피벗

  double _timer = 0;
  double _flipAngle = 0;
  bool _flipping = false;
  double _flipProgress = 0;

  // 각도 범위
  static const double _restAngle = 0.4; // 내려간 상태
  static const double _flipAngleMax = -0.5; // 올라간 상태

  FlipperObject(
    this.position, {
    this.width = 4.0,
    this.interval = 2.0,
    this.isLeft = true,
  });

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        width / 2,
        0.2,
        Vector2(isLeft ? width / 2 : -width / 2, 0),
        0,
      );

    final startAngle = isLeft ? _restAngle : -_restAngle;

    return world.createBody(
      BodyDef()
        ..type = BodyType.kinematic
        ..position = position
        ..angle = startAngle
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.8
        ..friction = 0.0,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    _timer += dt;

    if (!_flipping && _timer >= interval) {
      _flipping = true;
      _flipProgress = 0;
      _timer = 0;
    }

    if (_flipping) {
      _flipProgress += dt * 8.0; // 속도

      if (_flipProgress < 1.0) {
        // 올라가기 (빠르게)
        final t = Curves.easeOut.transform(_flipProgress);
        final from = isLeft ? _restAngle : -_restAngle;
        final to = isLeft ? _flipAngleMax : -_flipAngleMax;
        _flipAngle = from + (to - from) * t;
      } else if (_flipProgress < 2.0) {
        // 내려오기 천천히
        final t = Curves.easeIn.transform(_flipProgress - 1.0);
        final from = isLeft ? _flipAngleMax : -_flipAngleMax;
        final to = isLeft ? _restAngle : -_restAngle;
        _flipAngle = from + (to - from) * t;
      } else {
        _flipping = false;
        _flipAngle = isLeft ? _restAngle : -_restAngle;
      }

      body.setTransform(position, _flipAngle);
    }
  }

  @override
  void render(Canvas canvas) {
    // 피벗 포인트
    final pivotX = isLeft ? 0.0 : 0.0;
    canvas.drawCircle(
      Offset(pivotX, 0),
      0.3,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );

    // 본체
    final rect = Rect.fromCenter(
      center: Offset(isLeft ? width / 2 : -width / 2, 0),
      width: width,
      height: 0.4,
    );

    // 플립 중 밝게
    final color = _flipping
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFFF6B6B).withValues(alpha: 0.6);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(0.2)),
      Paint()..color = color,
    );

    // 테두리
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(0.2)),
      Paint()
        ..color = Colors.white.withValues(alpha: _flipping ? 0.4 : 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.05,
    );

    // 작동 게이지
    if (!_flipping) {
      final gauge = _timer / interval;
      canvas.drawRect(
        Rect.fromLTWH(
          isLeft ? 0 : -width * gauge,
          0.3,
          width * gauge,
          0.08,
        ),
        Paint()..color = const Color(0xFFFF6B6B).withValues(alpha: 0.3),
      );
    }
  }
}

class ElasticRopeObject extends Objects {
  final Vector2 startPoint;
  final Vector2 endPoint;
  final double elasticForce;
  final double damping;

  double _stretch = 0.0;
  double _stretchVel = 0.0;

  static const double _stiffness = 30.0;
  static const double _ropeThickness = 0.12;
  static const double _hitCooldown = 0.35;

  // beginContact에서 저장 → update에서 처리 (Box2D step 밖)
  final List<({Ball ball, Vector2 hitDir, double incomingSpeed})> _pendingHits =
      [];
  final Map<String, double> _ballCooldowns = {};

  ElasticRopeObject({
    required this.startPoint,
    required this.endPoint,
    this.elasticForce = 20.0,
    this.damping = 4.0,
  });

  Vector2 get _midPoint => (startPoint + endPoint) / 2;
  double get _ropeLength => startPoint.distanceTo(endPoint);

  Vector2 get _normal {
    final dir = endPoint - startPoint;
    return Vector2(-dir.y, dir.x).normalized();
  }

  @override
  Body createBody() {
    final mid = _midPoint;
    final dir = endPoint - startPoint;
    final angle = math.atan2(dir.y, dir.x);
    final len = _ropeLength;

    // 두께를 시각적 로프와 맞게 줄임
    final shape = PolygonShape()
      ..setAsBox(len / 2, _ropeThickness, Vector2.zero(), 0);

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = mid
        ..angle = angle
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution =
            1.0 // 완전 탄성: Box2D가 기본 반발 처리
        ..friction = 0.0
        ..userData = this,
    );
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      if (_ballCooldowns.containsKey(other.name)) return;

      final toball = other.body.position - _midPoint;
      final dot = toball.dot(_normal);
      final hitDir = (dot >= 0 ? _normal : -_normal).clone();

      // 로프를 향해 들어오는 속도 (양수 = 실제 충돌 방향)
      final incomingSpeed = other.body.linearVelocity.dot(-hitDir);
      if (incomingSpeed <= 0) return;

      // 데이터만 저장, velocity 조작은 update에서
      _pendingHits.add((
        ball: other,
        hitDir: hitDir,
        incomingSpeed: incomingSpeed,
      ));
      _ballCooldowns[other.name] = _hitCooldown;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Box2D step 완료 후 처리
    for (final hit in _pendingHits) {
      // stretch 설정 (시각적 효과)
      final newStretch = (hit.incomingSpeed * 0.05).clamp(0.0, 1.0);
      if (newStretch > _stretch) {
        _stretch = newStretch;
        _stretchVel = 0.0;
      }

      // Box2D restitution=1.0이 기본 반발 처리 완료
      // elasticForce로 최소 튕김 속도 보장
      final ball = hit.ball;
      final hitDir = hit.hitDir;
      final currentNormalVel = ball.body.linearVelocity.dot(hitDir);
      if (currentNormalVel < elasticForce) {
        ball.body.linearVelocity =
            ball.body.linearVelocity +
            hitDir * (elasticForce - currentNormalVel);
      }
    }
    _pendingHits.clear();

    // 쿨다운 감소
    _ballCooldowns.updateAll((_, v) => v - dt);
    _ballCooldowns.removeWhere((_, v) => v <= 0);

    // 스프링 물리 (로프 반동 시각 효과)
    if (_stretch.abs() > 0.001 || _stretchVel.abs() > 0.001) {
      final springForce = -_stiffness * _stretch;
      final dampForce = -damping * _stretchVel;
      _stretchVel += (springForce + dampForce) * dt;
      _stretch += _stretchVel * dt;

      if (_stretch.abs() < 0.001 && _stretchVel.abs() < 0.001) {
        _stretch = 0.0;
        _stretchVel = 0.0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // BodyComponent가 이미 body.angle 회전을 적용하므로
    // canvas.rotate() 없이 로컬 좌표계에서 그리면 됨
    final len = _ropeLength;
    final halfLen = len / 2;

    final p1 = Offset(-halfLen, 0);
    final p2 = Offset(halfLen, 0);
    final midOffset = _stretch * len * 0.3;
    final mid = Offset(0, midOffset);

    final stretchAbs = _stretch.abs();
    final ropeColor = Color.lerp(
      const Color(0xFFFFA726),
      const Color(0xFFFFD54F),
      stretchAbs.clamp(0.0, 1.0),
    )!;

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, p2.dx, p2.dy);

    final thickness = _ropeThickness * 3 * (1.0 - stretchAbs * 0.3);

    canvas.drawPath(
      path,
      Paint()
        ..color = ropeColor.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round,
    );

    if (stretchAbs > 0.05) {
      canvas.drawPath(
        path,
        Paint()
          ..color = ropeColor.withValues(alpha: stretchAbs * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness * 3
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }

    canvas.drawCircle(
      p1,
      0.2,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      p2,
      0.2,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
  }
}
