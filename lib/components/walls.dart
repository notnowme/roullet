import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:toruru/common/constants/colors.dart';

class Wall extends BodyComponent with ContactCallbacks {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    return world.createBody(
      BodyDef()
        ..type = BodyType.static
        ..userData = this,
    )..createFixture(FixtureDef(shape)..restitution = 0.3);
  }

  @override
  void render(Canvas canvas) {
    // 1. 선의 스타일 설정
    final paint = Paint()
      ..color = AppColor.accent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.1)
      ..strokeWidth =
          0.03 // 선 두께 (물리 세계 단위 기준)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // 끝부분을 둥글게 하면 더 예쁩니다.

    // 2. 시작점부터 끝점까지 그리기
    canvas.drawLine(
      Offset(start.x, start.y),
      Offset(end.x, end.y),
      paint,
    );
  }
}
