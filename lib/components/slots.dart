import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Slot extends BodyComponent with ContactCallbacks {
  final int index;
  final String label;
  final double x;
  final double width;
  final double topY;
  final double bottomY;

  static const List<Color> _slotColors = [
    Color(0xFF7B6CF6),
    Color(0xFF4ECDC4),
    Color(0xFFFF6B6B),
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
  ];

  Color get _color => _slotColors[index % _slotColors.length];

  Slot({
    required this.index,
    required this.label,
    required this.x,
    required this.width,
    required this.topY,
    required this.bottomY,
  });

  @override
  Body createBody() {
    // 물리 바디는 필요 X
    // 생성은 필수로 해야 함
    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..userData = this,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        x,
        topY,
        width,
        bottomY - topY,
      ),
      Paint()..color = _color.withValues(alpha: 0.15),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, topY, width, bottomY - topY),
      Paint()
        ..color = _color.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.08,
    );

    final fontSize = (width * 0.2).clamp(0.5, 1.5);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: _color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);

    tp.paint(
      canvas,
      Offset(x + (width - tp.width) / 2, topY + 0.4),
    );
  }
}
