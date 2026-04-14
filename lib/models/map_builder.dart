import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:toruru/components/lines.dart';
import 'package:toruru/components/objects.dart';
import 'package:toruru/components/pegs.dart';
import 'package:toruru/components/walls.dart';
import 'package:toruru/models/map_data.dart';

class MapBuilder {
  final MapData mapData;
  final double worldWidth;
  final double worldHeight;

  MapBuilder({
    required this.mapData,
    required this.worldWidth,
    required this.worldHeight,
  });

  List<Component> build() {
    final components = <Component>[];
    for (final obj in mapData.objects) {
      final result = _buildObject(obj);
      if (result is List<Component>) {
        components.addAll(result);
      } else if (result is Component) {
        components.add(result);
      }
    }
    return components;
  }

  dynamic _buildObject(MapObject obj) {
    final x = obj.rx * worldWidth;
    final y = obj.ry * worldHeight;

    return switch (obj.type) {
      MapObjectType.peg => Peg(
        Vector2(x, y),
        radius: obj.size * worldWidth,
      ),
      MapObjectType.circleBumper => CircleObject(
        Vector2(x, y),
        radius: obj.size * worldWidth,
      ),
      MapObjectType.triangle => TriangleObject(
        Vector2(x, y),
        size: obj.size * worldWidth,
      ),
      MapObjectType.plank => PlankObject(
        Vector2(x, y),
        width: obj.size * worldWidth,
        angle: obj.angle,
      ),
      MapObjectType.rotatingObject => RotatingObject(
        Vector2(x, y),
        width: obj.size * worldWidth,
        angularSpeed: obj.speed,
      ),
      MapObjectType.movingObject => MovingObject(
        Vector2(x, y),
        width: obj.size * worldWidth,
        horizontal: obj.horizontal,
        range: obj.horizontal
            ? obj.range * worldWidth
            : obj.range * worldHeight,
        speed: obj.horizontal
            ? obj.speed * worldWidth
            : obj.speed * worldHeight,
      ),
      MapObjectType.bouncePad => BounceObject(
        Vector2(x, y),
        width: obj.size * worldWidth,
        boostForce: obj.boostForce,
      ),
      MapObjectType.mapLine =>
        obj.points.length >= 2
            ? MapLine(
                obj.points
                    .map((p) => Vector2(p[0] * worldWidth, p[1] * worldHeight))
                    .toList(),
              )
            : null,
      MapObjectType.wall => Wall(
        Vector2(x - obj.size * worldWidth / 2, y),
        Vector2(x + obj.size * worldWidth / 2, y),
      ),
      MapObjectType.pegZone => _buildPegZone(obj),
      MapObjectType.breakableWall => BreakableWallObject(
        Vector2(x, y),
        width: obj.size * worldWidth,
        maxHits: obj.maxHits,
      ),
      MapObjectType.accelField => SpeedFieldObject(
        Vector2(x, y),
        radius: obj.fieldRadius * worldWidth,
        multiplier: obj.multiplier,
      ),
      MapObjectType.decelField => SpeedFieldObject(
        Vector2(x, y),
        radius: obj.fieldRadius * worldWidth,
        multiplier: obj.multiplier,
      ),
      MapObjectType.wormhole => [
        WormholeObject(
          entryPos: Vector2(x, y),
          exitPos: Vector2(obj.exitRx * worldWidth, obj.exitRy * worldHeight),
          radius: obj.fieldRadius * worldWidth,
        ),
        WormholeExitObject(
          pos: Vector2(obj.exitRx * worldWidth, obj.exitRy * worldHeight),
          radius: obj.fieldRadius * worldWidth,
        ),
      ],
      MapObjectType.flipper => FlipperObject(
        Vector2(x, y),
        width: obj.size * worldWidth,
        interval: obj.interval,
        isLeft: obj.isLeft,
      ),
      MapObjectType.elasticRope => ElasticRopeObject(
        startPoint: Vector2(x, y),
        endPoint: Vector2(obj.exitRx * worldWidth, obj.exitRy * worldHeight),
        elasticForce: obj.boostForce,
      ),
    };
  }

  List<Peg> _buildPegZone(MapObject obj) {
    final pegs = <Peg>[];
    final startY = obj.ry * worldHeight;
    final endY = obj.endRy * worldHeight;
    final pegRadius = worldWidth * 0.015;
    final rowSpacing = (worldWidth * 0.14) / obj.density;
    final rows = ((endY - startY) / rowSpacing).floor();

    for (int row = 0; row < rows; row++) {
      final isOffset = row.isOdd;
      final count = 5 + row % 3;
      final spacing = worldWidth / (count + 1);
      final y = startY + row * rowSpacing;

      for (int col = 0; col <= count; col++) {
        final x = spacing * (col + (isOffset ? 1.0 : 0.5));
        if (x > pegRadius && x < worldWidth - pegRadius) {
          pegs.add(Peg(Vector2(x, y), radius: pegRadius));
        }
      }
    }
    return pegs;
  }
}
