import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class GameParticles {
  static final _rng = math.Random();

  /// 충돌 파티클 (작은 파편 튀기)
  static ParticleSystemComponent collision({
    required Vector2 position,
    required Color color,
    int count = 6,
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: count,
        lifespan: 0.4,
        generator: (i) {
          final angle = _rng.nextDouble() * math.pi * 2;
          final speed = 2.0 + _rng.nextDouble() * 4.0;
          return AcceleratedParticle(
            speed: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
            acceleration: Vector2(0, 10),
            child: CircleParticle(
              radius: 0.08 + _rng.nextDouble() * 0.08,
              paint: Paint()..color = color.withValues(alpha: 0.7),
            ),
          );
        },
      ),
    );
  }

  /// 별가루 파티클 — 행성 스킨 전용
  static ParticleSystemComponent starDust({
    required Vector2 position,
    required Color color,
  }) {
    final starColors = [
      color,
      Colors.white,
      const Color(0xFFFFD700),
      Color.lerp(color, Colors.white, 0.6)!,
      const Color(0xFFFFF9C4),
    ];

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 5,
        lifespan: 0.65,
        generator: (i) {
          final angle = _rng.nextDouble() * math.pi * 2;
          final speed = 0.8 + _rng.nextDouble() * 3.2;
          final starColor = starColors[_rng.nextInt(starColors.length)];
          final starSize = 0.07 + _rng.nextDouble() * 0.10;

          return AcceleratedParticle(
            speed: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
            acceleration: Vector2(0, 1.5), // 낮은 중력 — 떠다니는 느낌
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final alpha = (1.0 - particle.progress).clamp(0.0, 1.0);
                final size = starSize * (1.0 - particle.progress * 0.35);
                _drawStar(canvas, size, starColor.withValues(alpha: alpha));
              },
            ),
          );
        },
      ),
    );
  }

  /// 8비트 픽셀 파티클 — 픽셀 스킨 전용
  static ParticleSystemComponent pixelCollision({
    required Vector2 position,
    required Color color,
  }) {
    final pixColors = [
      color,
      Color.lerp(color, Colors.white, 0.55)!,
      Color.lerp(color, Colors.black, 0.3)!,
      Colors.white,
    ];

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 5,
        lifespan: 0.35,
        generator: (i) {
          final angle = (i / 8.0) * math.pi * 2 + _rng.nextDouble() * 0.5;
          final speed = 2.0 + _rng.nextDouble() * 4.0;
          final pixColor = pixColors[_rng.nextInt(pixColors.length)];
          final pixSize = 0.07 + _rng.nextDouble() * 0.07;

          return AcceleratedParticle(
            speed: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
            acceleration: Vector2(0, 10),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final alpha = (1.0 - particle.progress).clamp(0.0, 1.0);
                canvas.drawRect(
                  Rect.fromCenter(
                    center: Offset.zero,
                    width: pixSize,
                    height: pixSize,
                  ),
                  Paint()..color = pixColor.withValues(alpha: alpha),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 슬라임 스플래시 — 물방울이 늘어나며 튀는 파티클
  static ParticleSystemComponent slimeSplash({
    required Vector2 position,
    required Color color,
  }) {
    final splashColors = [
      color,
      Color.lerp(color, Colors.white, 0.45)!,
      color.withValues(alpha: 0.55),
    ];

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 5,
        lifespan: 0.50,
        generator: (i) {
          final angle = _rng.nextDouble() * math.pi * 2;
          final speed = 1.2 + _rng.nextDouble() * 3.5;
          final sc = splashColors[_rng.nextInt(splashColors.length)];
          final blobSize = 0.06 + _rng.nextDouble() * 0.07;

          return AcceleratedParticle(
            speed: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
            acceleration: Vector2(0, 5), // 낮은 중력 — 떠다니는 액체
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final alpha = (1.0 - particle.progress).clamp(0.0, 1.0);
                final t = particle.progress;
                // 이동 방향으로 늘어남 (물방울 비행 모양)
                final stretch = 1.0 + t * 1.5;
                final shrink = 1.0 / math.sqrt(stretch);
                final size = blobSize * (1.0 - t * 0.3);
                canvas.save();
                canvas.rotate(angle);
                canvas.scale(stretch, shrink);
                // 반투명 blob
                canvas.drawCircle(
                  Offset.zero, size,
                  Paint()
                    ..color = sc.withValues(alpha: alpha * 0.70)
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.25),
                );
                // 하이라이트 점
                canvas.drawCircle(
                  Offset(-size * 0.25, -size * 0.25), size * 0.30,
                  Paint()..color = Colors.white.withValues(alpha: alpha * 0.45),
                );
                canvas.restore();
              },
            ),
          );
        },
      ),
    );
  }

  /// 4각 별 도형 그리기 (별가루용 헬퍼)
  static void _drawStar(Canvas canvas, double size, Color color) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) - math.pi / 2;
      final r = i.isEven ? size : size * 0.35;
      final x = r * math.cos(angle);
      final y = r * math.sin(angle);
      if (i == 0) { path.moveTo(x, y); }
      else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    // 중앙 반짝 글로우
    canvas.drawCircle(
      Offset.zero,
      size * 0.22,
      Paint()
        ..color = Colors.white.withValues(alpha: color.a * 0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5),
    );
  }

  /// 골 축하 파티클 (위로 퍼지는 컨페티)
  static ParticleSystemComponent goalCelebration({
    required Vector2 position,
  }) {
    const colors = [
      Color(0xFF7B6CF6),
      Color(0xFF4ECDC4),
      Color(0xFFFF6B6B),
      Color(0xFFFFA726),
      Color(0xFF66BB6A),
      Color(0xFFFFD700),
    ];

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 30,
        lifespan: 1.5,
        generator: (i) {
          final angle = -math.pi / 2 + (_rng.nextDouble() - 0.5) * math.pi;
          final speed = 5.0 + _rng.nextDouble() * 10.0;
          final color = colors[_rng.nextInt(colors.length)];

          return AcceleratedParticle(
            speed: Vector2(
              math.cos(angle) * speed,
              math.sin(angle) * speed,
            ),
            acceleration: Vector2(0, 15),
            child: CircleParticle(
              radius: 0.1 + _rng.nextDouble() * 0.12,
              paint: Paint()..color = color.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
  }

  /// 파괴 파티클 (BreakableWall 부서질 때)
  static ParticleSystemComponent destruction({
    required Vector2 position,
    required double width,
    Color color = const Color(0xFF4ECDC4),
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 15,
        lifespan: 0.6,
        generator: (i) {
          final xOffset = (_rng.nextDouble() - 0.5) * width;
          final angle = -math.pi / 2 + (_rng.nextDouble() - 0.5) * math.pi;
          final speed = 3.0 + _rng.nextDouble() * 5.0;

          return AcceleratedParticle(
            position: Vector2(xOffset, 0),
            speed: Vector2(
              math.cos(angle) * speed,
              math.sin(angle) * speed,
            ),
            acceleration: Vector2(0, 12),
            child: CircleParticle(
              radius: 0.06 + _rng.nextDouble() * 0.1,
              paint: Paint()..color = color.withValues(alpha: 0.6),
            ),
          );
        },
      ),
    );
  }

  /// 바운스패드 이펙트 (위로 번쩍)
  static ParticleSystemComponent bounce({
    required Vector2 position,
    required double width,
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 8,
        lifespan: 0.3,
        generator: (i) {
          final xOffset = (_rng.nextDouble() - 0.5) * width;
          return AcceleratedParticle(
            position: Vector2(xOffset, 0),
            speed: Vector2(0, -5.0 - _rng.nextDouble() * 3.0),
            acceleration: Vector2(0, 8),
            child: CircleParticle(
              radius: 0.06,
              paint: Paint()..color = Colors.white.withValues(alpha: 0.6),
            ),
          );
        },
      ),
    );
  }

  /// 웜홀 텔레포트 이펙트
  static ParticleSystemComponent warp({
    required Vector2 position,
    Color color = const Color(0xFF9C27B0),
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 12,
        lifespan: 0.5,
        generator: (i) {
          final angle = (i / 12.0) * math.pi * 2;
          final speed = 3.0 + _rng.nextDouble() * 2.0;

          return AcceleratedParticle(
            speed: Vector2(
              math.cos(angle) * speed,
              math.sin(angle) * speed,
            ),
            acceleration: Vector2.zero(),
            child: CircleParticle(
              radius: 0.05 + _rng.nextDouble() * 0.06,
              paint: Paint()..color = color.withValues(alpha: 0.5),
            ),
          );
        },
      ),
    );
  }
}
