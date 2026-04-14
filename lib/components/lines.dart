import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class MapLine extends BodyComponent with ContactCallbacks {
  final List<Vector2> points;

  MapLine(this.points);

  @override
  Body createBody() {
    final shape = ChainShape()..createChain(points);
    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..userData = this,
    )..createFixture(
      FixtureDef(shape)
        ..restitution = 0.35
        ..friction = 0.15,
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF7B6CF6)
      ..strokeWidth = 0.08
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.x, points.first.y);
    for (final p in points.skip(1)) {
      path.lineTo(p.x, p.y);
    }
    canvas.drawPath(path, paint);
  }
}
