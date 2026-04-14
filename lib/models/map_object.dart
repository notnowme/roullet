/// 모든 좌표/크기는 0~1 비율 (월드 크기 대비)
library;

enum MapObjectType {
  peg,
  pegZone,
  circleBumper,
  triangle,
  plank,
  rotatingObject,
  movingObject,
  bouncePad,
  mapLine,
  wall,
  breakableWall,
  accelField,
  decelField,
  wormhole,
  flipper,
  elasticRope,
}

// ─────────────────────────────────────────────────────────────────────────────
// Base
// ─────────────────────────────────────────────────────────────────────────────

sealed class MapObject {
  String get id;
  MapObjectType get type;
  double get rx;
  double get ry;

  const MapObject();

  /// 위치만 변경한 복사본. 에디터 드래그에서 사용.
  MapObject movedTo(double rx, double ry);

  Map<String, dynamic> toJson();

  factory MapObject.fromJson(Map<String, dynamic> json) {
    final type = MapObjectType.values.byName(json['type'] as String);
    return switch (type) {
      MapObjectType.peg => PegObject.fromJson(json),
      MapObjectType.pegZone => PegZoneObject.fromJson(json),
      MapObjectType.circleBumper => CircleBumperObject.fromJson(json),
      MapObjectType.triangle => TriangleObject.fromJson(json),
      MapObjectType.plank => PlankObject.fromJson(json),
      MapObjectType.rotatingObject => RotatingObject.fromJson(json),
      MapObjectType.movingObject => MovingObject.fromJson(json),
      MapObjectType.bouncePad => BouncePadObject.fromJson(json),
      MapObjectType.mapLine => MapLineObject.fromJson(json),
      MapObjectType.wall => WallObject.fromJson(json),
      MapObjectType.breakableWall => BreakableWallObject.fromJson(json),
      MapObjectType.accelField => AccelFieldObject.fromJson(json),
      MapObjectType.decelField => DecelFieldObject.fromJson(json),
      MapObjectType.wormhole => WormholeObject.fromJson(json),
      MapObjectType.flipper => FlipperObject.fromJson(json),
      MapObjectType.elasticRope => ElasticRopeObject.fromJson(json),
    };
  }

  /// id 생성 헬퍼
  static String generateId(MapObjectType type) =>
      '${DateTime.now().microsecondsSinceEpoch}_${type.name}';

  Map<String, dynamic> _baseJson() => {
    'type': type.name,
    'rx': rx,
    'ry': ry,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// 기본 오브젝트
// ─────────────────────────────────────────────────────────────────────────────

class PegObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.peg;
  @override
  final double rx;
  @override
  final double ry;
  final double size;

  const PegObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.015,
  });

  PegObject.place({required this.rx, required this.ry, this.size = 0.015})
    : id = MapObject.generateId(MapObjectType.peg);

  @override
  PegObject movedTo(double rx, double ry) =>
      PegObject(id: id, rx: rx, ry: ry, size: size);

  PegObject copyWith({double? rx, double? ry, double? size}) => PegObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
  );

  @override
  Map<String, dynamic> toJson() => {..._baseJson(), 'size': size};

  factory PegObject.fromJson(Map<String, dynamic> j) => PegObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.peg),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.015,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class PegZoneObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.pegZone;
  @override
  final double rx;
  @override
  final double ry; // 시작 Y
  final double endRy; // 끝 Y
  final double density;

  const PegZoneObject({
    required this.id,
    this.rx = 0.0,
    required this.ry,
    required this.endRy,
    this.density = 1.0,
  });

  PegZoneObject.place({
    this.rx = 0.0,
    required this.ry,
    required this.endRy,
    this.density = 1.0,
  }) : id = MapObject.generateId(MapObjectType.pegZone);

  @override
  PegZoneObject movedTo(double rx, double ry) => PegZoneObject(
    id: id,
    rx: rx,
    ry: ry,
    endRy: endRy,
    density: density,
  );

  PegZoneObject copyWith({
    double? rx,
    double? ry,
    double? endRy,
    double? density,
  }) => PegZoneObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    endRy: endRy ?? this.endRy,
    density: density ?? this.density,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'endRy': endRy,
    'density': density,
  };

  factory PegZoneObject.fromJson(Map<String, dynamic> j) => PegZoneObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.pegZone),
    rx: (j['rx'] as num?)?.toDouble() ?? 0.0,
    ry: (j['ry'] as num).toDouble(),
    endRy: (j['endRy'] as num?)?.toDouble() ?? 0.6,
    density: (j['density'] as num?)?.toDouble() ?? 1.0,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 장애물
// ─────────────────────────────────────────────────────────────────────────────

class CircleBumperObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.circleBumper;
  @override
  final double rx;
  @override
  final double ry;
  final double size;

  const CircleBumperObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.035,
  });

  CircleBumperObject.place({
    required this.rx,
    required this.ry,
    this.size = 0.035,
  }) : id = MapObject.generateId(MapObjectType.circleBumper);

  @override
  CircleBumperObject movedTo(double rx, double ry) =>
      CircleBumperObject(id: id, rx: rx, ry: ry, size: size);

  CircleBumperObject copyWith({double? rx, double? ry, double? size}) =>
      CircleBumperObject(
        id: id,
        rx: rx ?? this.rx,
        ry: ry ?? this.ry,
        size: size ?? this.size,
      );

  @override
  Map<String, dynamic> toJson() => {..._baseJson(), 'size': size};

  factory CircleBumperObject.fromJson(
    Map<String, dynamic> j,
  ) => CircleBumperObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.circleBumper),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.035,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class TriangleObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.triangle;
  @override
  final double rx;
  @override
  final double ry;
  final double size;

  const TriangleObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.05,
  });

  TriangleObject.place({required this.rx, required this.ry, this.size = 0.05})
    : id = MapObject.generateId(MapObjectType.triangle);

  @override
  TriangleObject movedTo(double rx, double ry) =>
      TriangleObject(id: id, rx: rx, ry: ry, size: size);

  TriangleObject copyWith({double? rx, double? ry, double? size}) =>
      TriangleObject(
        id: id,
        rx: rx ?? this.rx,
        ry: ry ?? this.ry,
        size: size ?? this.size,
      );

  @override
  Map<String, dynamic> toJson() => {..._baseJson(), 'size': size};

  factory TriangleObject.fromJson(Map<String, dynamic> j) => TriangleObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.triangle),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.05,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class PlankObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.plank;
  @override
  final double rx;
  @override
  final double ry;
  final double size;
  final double angle;

  const PlankObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.angle = 0.3,
  });

  PlankObject.place({
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.angle = 0.3,
  }) : id = MapObject.generateId(MapObjectType.plank);

  @override
  PlankObject movedTo(double rx, double ry) =>
      PlankObject(id: id, rx: rx, ry: ry, size: size, angle: angle);

  PlankObject copyWith({double? rx, double? ry, double? size, double? angle}) =>
      PlankObject(
        id: id,
        rx: rx ?? this.rx,
        ry: ry ?? this.ry,
        size: size ?? this.size,
        angle: angle ?? this.angle,
      );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'size': size,
    'angle': angle,
  };

  factory PlankObject.fromJson(Map<String, dynamic> j) => PlankObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.plank),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.2,
    angle: (j['angle'] as num?)?.toDouble() ?? 0.3,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class RotatingObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.rotatingObject;
  @override
  final double rx;
  @override
  final double ry;
  final double size;
  final double speed; // 각속도 (rad/s, 음수 = 반시계)

  const RotatingObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.speed = 1.5,
  });

  RotatingObject.place({
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.speed = 1.5,
  }) : id = MapObject.generateId(MapObjectType.rotatingObject);

  @override
  RotatingObject movedTo(double rx, double ry) =>
      RotatingObject(id: id, rx: rx, ry: ry, size: size, speed: speed);

  RotatingObject copyWith({
    double? rx,
    double? ry,
    double? size,
    double? speed,
  }) => RotatingObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
    speed: speed ?? this.speed,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'size': size,
    'speed': speed,
  };

  factory RotatingObject.fromJson(Map<String, dynamic> j) => RotatingObject(
    id:
        j['id'] as String? ??
        MapObject.generateId(MapObjectType.rotatingObject),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.2,
    speed: (j['speed'] as num?)?.toDouble() ?? 1.5,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class MovingObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.movingObject;
  @override
  final double rx;
  @override
  final double ry;
  final double size;
  final double speed;
  final double range; // 이동 범위 (비율)
  final bool horizontal;

  const MovingObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.speed = 0.1,
    this.range = 0.15,
    this.horizontal = true,
  });

  MovingObject.place({
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.speed = 0.1,
    this.range = 0.15,
    this.horizontal = true,
  }) : id = MapObject.generateId(MapObjectType.movingObject);

  @override
  MovingObject movedTo(double rx, double ry) => MovingObject(
    id: id,
    rx: rx,
    ry: ry,
    size: size,
    speed: speed,
    range: range,
    horizontal: horizontal,
  );

  MovingObject copyWith({
    double? rx,
    double? ry,
    double? size,
    double? speed,
    double? range,
    bool? horizontal,
  }) => MovingObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
    speed: speed ?? this.speed,
    range: range ?? this.range,
    horizontal: horizontal ?? this.horizontal,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'size': size,
    'speed': speed,
    'range': range,
    'horizontal': horizontal,
  };

  factory MovingObject.fromJson(Map<String, dynamic> j) => MovingObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.movingObject),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.2,
    speed: (j['speed'] as num?)?.toDouble() ?? 0.1,
    range: (j['range'] as num?)?.toDouble() ?? 0.15,
    horizontal: j['horizontal'] as bool? ?? true,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class BouncePadObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.bouncePad;
  @override
  final double rx;
  @override
  final double ry;
  final double size;
  final double boostForce;

  const BouncePadObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.15,
    this.boostForce = 40.0,
  });

  BouncePadObject.place({
    required this.rx,
    required this.ry,
    this.size = 0.15,
    this.boostForce = 40.0,
  }) : id = MapObject.generateId(MapObjectType.bouncePad);

  @override
  BouncePadObject movedTo(double rx, double ry) => BouncePadObject(
    id: id,
    rx: rx,
    ry: ry,
    size: size,
    boostForce: boostForce,
  );

  BouncePadObject copyWith({
    double? rx,
    double? ry,
    double? size,
    double? boostForce,
  }) => BouncePadObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
    boostForce: boostForce ?? this.boostForce,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'size': size,
    'boostForce': boostForce,
  };

  factory BouncePadObject.fromJson(Map<String, dynamic> j) => BouncePadObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.bouncePad),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.15,
    boostForce: (j['boostForce'] as num?)?.toDouble() ?? 40.0,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class MapLineObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.mapLine;
  @override
  final double rx;
  @override
  final double ry;
  final List<List<double>> points; // [[rx, ry], ...]

  const MapLineObject({
    required this.id,
    required this.rx,
    required this.ry,
    required this.points,
  });

  MapLineObject.place({required this.points})
    : id = MapObject.generateId(MapObjectType.mapLine),
      rx = points.isNotEmpty ? points.first[0] : 0.0,
      ry = points.isNotEmpty ? points.first[1] : 0.0;

  @override
  // mapLine은 points 기준이므로 rx/ry 단순 변경은 미지원 (에디터에서 점 개별 편집)
  MapLineObject movedTo(double rx, double ry) => this;

  MapLineObject copyWith({List<List<double>>? points}) => MapLineObject(
    id: id,
    rx: points != null && points.isNotEmpty ? points.first[0] : rx,
    ry: points != null && points.isNotEmpty ? points.first[1] : ry,
    points: points ?? this.points,
  );

  @override
  Map<String, dynamic> toJson() => {..._baseJson(), 'points': points};

  factory MapLineObject.fromJson(Map<String, dynamic> j) => MapLineObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.mapLine),
    rx: (j['rx'] as num?)?.toDouble() ?? 0.0,
    ry: (j['ry'] as num?)?.toDouble() ?? 0.0,
    points: (j['points'] as List)
        .map((p) => (p as List).map((v) => (v as num).toDouble()).toList())
        .toList(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class WallObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.wall;
  @override
  final double rx;
  @override
  final double ry;
  final double size; // 가로 길이 비율

  const WallObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.05,
  });

  WallObject.place({required this.rx, required this.ry, this.size = 0.05})
    : id = MapObject.generateId(MapObjectType.wall);

  @override
  WallObject movedTo(double rx, double ry) =>
      WallObject(id: id, rx: rx, ry: ry, size: size);

  WallObject copyWith({double? rx, double? ry, double? size}) => WallObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
  );

  @override
  Map<String, dynamic> toJson() => {..._baseJson(), 'size': size};

  factory WallObject.fromJson(Map<String, dynamic> j) => WallObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.wall),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.05,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class BreakableWallObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.breakableWall;
  @override
  final double rx;
  @override
  final double ry;
  final double size;
  final int maxHits;

  const BreakableWallObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 1.0,
    this.maxHits = 3,
  });

  BreakableWallObject.place({
    required this.rx,
    required this.ry,
    this.size = 1.0,
    this.maxHits = 3,
  }) : id = MapObject.generateId(MapObjectType.breakableWall);

  @override
  BreakableWallObject movedTo(double rx, double ry) =>
      BreakableWallObject(id: id, rx: rx, ry: ry, size: size, maxHits: maxHits);

  BreakableWallObject copyWith({
    double? rx,
    double? ry,
    double? size,
    int? maxHits,
  }) => BreakableWallObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
    maxHits: maxHits ?? this.maxHits,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'size': size,
    'maxHits': maxHits,
  };

  factory BreakableWallObject.fromJson(
    Map<String, dynamic> j,
  ) => BreakableWallObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.breakableWall),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 1.0,
    maxHits: (j['maxHits'] as num?)?.toInt() ?? 3,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 특수 오브젝트
// ─────────────────────────────────────────────────────────────────────────────

class AccelFieldObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.accelField;
  @override
  final double rx;
  @override
  final double ry;
  final double fieldRadius;
  final double multiplier; // > 1.0

  const AccelFieldObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.fieldRadius = 0.12,
    this.multiplier = 1.5,
  });

  AccelFieldObject.place({
    required this.rx,
    required this.ry,
    this.fieldRadius = 0.12,
    this.multiplier = 1.5,
  }) : id = MapObject.generateId(MapObjectType.accelField);

  @override
  AccelFieldObject movedTo(double rx, double ry) => AccelFieldObject(
    id: id,
    rx: rx,
    ry: ry,
    fieldRadius: fieldRadius,
    multiplier: multiplier,
  );

  AccelFieldObject copyWith({
    double? rx,
    double? ry,
    double? fieldRadius,
    double? multiplier,
  }) => AccelFieldObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    fieldRadius: fieldRadius ?? this.fieldRadius,
    multiplier: multiplier ?? this.multiplier,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'fieldRadius': fieldRadius,
    'multiplier': multiplier,
  };

  factory AccelFieldObject.fromJson(Map<String, dynamic> j) => AccelFieldObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.accelField),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    fieldRadius: (j['fieldRadius'] as num?)?.toDouble() ?? 0.12,
    multiplier: (j['multiplier'] as num?)?.toDouble() ?? 1.5,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class DecelFieldObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.decelField;
  @override
  final double rx;
  @override
  final double ry;
  final double fieldRadius;
  final double multiplier; // < 1.0

  const DecelFieldObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.fieldRadius = 0.15,
    this.multiplier = 0.5,
  });

  DecelFieldObject.place({
    required this.rx,
    required this.ry,
    this.fieldRadius = 0.15,
    this.multiplier = 0.5,
  }) : id = MapObject.generateId(MapObjectType.decelField);

  @override
  DecelFieldObject movedTo(double rx, double ry) => DecelFieldObject(
    id: id,
    rx: rx,
    ry: ry,
    fieldRadius: fieldRadius,
    multiplier: multiplier,
  );

  DecelFieldObject copyWith({
    double? rx,
    double? ry,
    double? fieldRadius,
    double? multiplier,
  }) => DecelFieldObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    fieldRadius: fieldRadius ?? this.fieldRadius,
    multiplier: multiplier ?? this.multiplier,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'fieldRadius': fieldRadius,
    'multiplier': multiplier,
  };

  factory DecelFieldObject.fromJson(Map<String, dynamic> j) => DecelFieldObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.decelField),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    fieldRadius: (j['fieldRadius'] as num?)?.toDouble() ?? 0.15,
    multiplier: (j['multiplier'] as num?)?.toDouble() ?? 0.5,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class WormholeObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.wormhole;
  @override
  final double rx; // 입구 X
  @override
  final double ry; // 입구 Y
  final double exitRx;
  final double exitRy;
  final double fieldRadius;

  const WormholeObject({
    required this.id,
    required this.rx,
    required this.ry,
    required this.exitRx,
    required this.exitRy,
    this.fieldRadius = 0.08,
  });

  WormholeObject.place({
    required this.rx,
    required this.ry,
    required this.exitRx,
    required this.exitRy,
    this.fieldRadius = 0.08,
  }) : id = MapObject.generateId(MapObjectType.wormhole);

  @override
  WormholeObject movedTo(double rx, double ry) => WormholeObject(
    id: id,
    rx: rx,
    ry: ry,
    exitRx: exitRx,
    exitRy: exitRy,
    fieldRadius: fieldRadius,
  );

  WormholeObject copyWith({
    double? rx,
    double? ry,
    double? exitRx,
    double? exitRy,
    double? fieldRadius,
  }) => WormholeObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    exitRx: exitRx ?? this.exitRx,
    exitRy: exitRy ?? this.exitRy,
    fieldRadius: fieldRadius ?? this.fieldRadius,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'exitRx': exitRx,
    'exitRy': exitRy,
    'fieldRadius': fieldRadius,
  };

  factory WormholeObject.fromJson(Map<String, dynamic> j) => WormholeObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.wormhole),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    exitRx: (j['exitRx'] as num?)?.toDouble() ?? 0.0,
    exitRy: (j['exitRy'] as num?)?.toDouble() ?? 0.0,
    fieldRadius: (j['fieldRadius'] as num?)?.toDouble() ?? 0.08,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class FlipperObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.flipper;
  @override
  final double rx;
  @override
  final double ry;
  final double size;
  final double interval; // 작동 주기 (초)
  final bool isLeft;

  const FlipperObject({
    required this.id,
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.interval = 1.0,
    this.isLeft = true,
  });

  FlipperObject.place({
    required this.rx,
    required this.ry,
    this.size = 0.2,
    this.interval = 1.0,
    this.isLeft = true,
  }) : id = MapObject.generateId(MapObjectType.flipper);

  @override
  FlipperObject movedTo(double rx, double ry) => FlipperObject(
    id: id,
    rx: rx,
    ry: ry,
    size: size,
    interval: interval,
    isLeft: isLeft,
  );

  FlipperObject copyWith({
    double? rx,
    double? ry,
    double? size,
    double? interval,
    bool? isLeft,
  }) => FlipperObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    size: size ?? this.size,
    interval: interval ?? this.interval,
    isLeft: isLeft ?? this.isLeft,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'size': size,
    'interval': interval,
    'isLeft': isLeft,
  };

  factory FlipperObject.fromJson(Map<String, dynamic> j) => FlipperObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.flipper),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    size: (j['size'] as num?)?.toDouble() ?? 0.2,
    interval: (j['interval'] as num?)?.toDouble() ?? 1.0,
    isLeft: j['isLeft'] as bool? ?? true,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class ElasticRopeObject extends MapObject {
  @override
  final String id;
  @override
  final MapObjectType type = MapObjectType.elasticRope;
  @override
  final double rx; // 시작점 X
  @override
  final double ry; // 시작점 Y
  final double exitRx; // 끝점 X
  final double exitRy; // 끝점 Y
  final double elasticForce;

  const ElasticRopeObject({
    required this.id,
    required this.rx,
    required this.ry,
    required this.exitRx,
    required this.exitRy,
    this.elasticForce = 25.0,
  });

  ElasticRopeObject.place({
    required this.rx,
    required this.ry,
    required this.exitRx,
    required this.exitRy,
    this.elasticForce = 25.0,
  }) : id = MapObject.generateId(MapObjectType.elasticRope);

  @override
  ElasticRopeObject movedTo(double rx, double ry) => ElasticRopeObject(
    id: id,
    rx: rx,
    ry: ry,
    exitRx: exitRx,
    exitRy: exitRy,
    elasticForce: elasticForce,
  );

  ElasticRopeObject copyWith({
    double? rx,
    double? ry,
    double? exitRx,
    double? exitRy,
    double? elasticForce,
  }) => ElasticRopeObject(
    id: id,
    rx: rx ?? this.rx,
    ry: ry ?? this.ry,
    exitRx: exitRx ?? this.exitRx,
    exitRy: exitRy ?? this.exitRy,
    elasticForce: elasticForce ?? this.elasticForce,
  );

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(),
    'exitRx': exitRx,
    'exitRy': exitRy,
    'elasticForce': elasticForce,
  };

  factory ElasticRopeObject.fromJson(
    Map<String, dynamic> j,
  ) => ElasticRopeObject(
    id: j['id'] as String? ?? MapObject.generateId(MapObjectType.elasticRope),
    rx: (j['rx'] as num).toDouble(),
    ry: (j['ry'] as num).toDouble(),
    exitRx: (j['exitRx'] as num?)?.toDouble() ?? 0.0,
    exitRy: (j['exitRy'] as num?)?.toDouble() ?? 0.0,
    // 구 저장본 호환: boostForce → elasticForce
    elasticForce:
        (j['elasticForce'] as num?)?.toDouble() ??
        (j['boostForce'] as num?)?.toDouble() ??
        25.0,
  );
}
