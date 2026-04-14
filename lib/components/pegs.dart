import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Peg extends BodyComponent with ContactCallbacks {
  final Vector2 pos;
  final double radius;

  Peg(this.pos, {this.radius = 0.3});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.5
      ..friction = 0.05;

    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..position = pos
        ..userData = this,
    )..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = Colors.white60
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.2,
    );
    canvas.drawCircle(
      Offset.zero,
      radius * 0.85,
      Paint()..color = const Color(0xFF3A3A55),
    );
    canvas.drawCircle(
      Offset(-radius * 0.28, -radius * 0.28),
      radius * 0.3,
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );
  }
}
