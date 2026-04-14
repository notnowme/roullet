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

/// 단일 오브젝트 데이터
/// 모든 좌표는 0~1 비율
class MapObject {
  final String id;
  final MapObjectType type;
  final double rx; // x 비율
  final double ry; // y 비율
  final double size; // 크기
  final double angle; // 회전
  final double speed; // 이동/회전 속도
  final double range; // 이동 범위 (비율)
  final double boostForce; // 바운스패드 전용
  final bool horizontal; // 이동 방향
  final List<List<double>> points; // mapLine 전용 [[rx, ry], ...]
  final double endRy; // pegZone 끝
  final double density; // pegZone 밀도
  final int maxHits;
  final double fieldRadius;
  final double multiplier;
  final double exitRx;
  final double exitRy;
  final bool isLeft;
  final double interval;

  MapObject({
    String? id,
    required this.type,
    this.rx = 0.5,
    this.ry = 0.5,
    this.size = 0.03,
    this.angle = 0,
    this.speed = 1.5,
    this.range = 0.15,
    this.boostForce = 40.0,
    this.horizontal = true,
    this.points = const [],
    this.endRy = 0.6,
    this.density = 1.0,
    this.maxHits = 3,
    this.fieldRadius = 0.1,
    this.multiplier = 1.5,
    this.exitRx = 0.0,
    this.exitRy = 0.0,
    this.isLeft = true,
    this.interval = 1.0,
  }) : id = id ?? '${DateTime.now().microsecondsSinceEpoch}_${type.name}';

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'rx': rx,
    'ry': ry,
    'size': size,
    'angle': angle,
    'speed': speed,
    'range': range,
    'boostForce': boostForce,
    'horizontal': horizontal,
    'points': points,
    'endRy': endRy,
    'density': density,
    'maxHits': maxHits,
    'fieldRadius': fieldRadius,
    'multiplier': multiplier,
    'exitRx': exitRx,
    'exitRy': exitRy,
    'isLeft': isLeft,
    'interval': interval,
  };

  factory MapObject.fromJson(Map<String, dynamic> json) => MapObject(
    type: MapObjectType.values.byName(json['type'] as String),
    rx: (json['rx'] as num).toDouble(),
    ry: (json['ry'] as num).toDouble(),
    size: (json['size'] as num?)?.toDouble() ?? 0.03,
    angle: (json['angle'] as num?)?.toDouble() ?? 0,
    speed: (json['speed'] as num?)?.toDouble() ?? 1.5,
    range: (json['range'] as num?)?.toDouble() ?? 0.15,
    boostForce: (json['boostForce'] as num?)?.toDouble() ?? 40.0,
    horizontal: json['horizontal'] as bool? ?? true,
    points:
        (json['points'] as List?)
            ?.map((p) => (p as List).map((v) => (v as num).toDouble()).toList())
            .toList() ??
        [],
    endRy: (json['endRy'] as num?)?.toDouble() ?? 0.6,
    density: (json['density'] as num?)?.toDouble() ?? 1.0,
    maxHits: (json['maxHits'] as num?)?.toInt() ?? 3,
    fieldRadius: (json['fieldRadius'] as num?)?.toDouble() ?? 0.1,
    multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.5,
    exitRx: (json['exitRx'] as num?)?.toDouble() ?? 0.0,
    exitRy: (json['exitRy'] as num?)?.toDouble() ?? 0.0,
    interval: (json['interval'] as num?)?.toDouble() ?? 1.0,
    isLeft: (json['isLeft'] as bool?) ?? false,
  );

  MapObject copyWith({
    String? id,
    MapObjectType? type,
    double? rx,
    double? ry,
    double? size,
    double? angle,
    double? speed,
    double? range,
    double? boostForce,
    bool? horizontal,
    List<List<double>>? points,
    double? endRy,
    double? density,
    double? fieldRadius,
    double? multiplier,
    double? exitRx,
    double? exitRy,
    int? maxHits,
    bool? isLeft,
    double? interval,
  }) {
    return MapObject(
      id: id ?? this.id,
      type: type ?? this.type,
      rx: rx ?? this.rx,
      ry: ry ?? this.ry,
      size: size ?? this.size,
      angle: angle ?? this.angle,
      speed: speed ?? this.speed,
      range: range ?? this.range,
      boostForce: boostForce ?? this.boostForce,
      horizontal: horizontal ?? this.horizontal,
      points: points ?? this.points,
      endRy: endRy ?? this.endRy,
      density: density ?? this.density,
      fieldRadius: fieldRadius ?? this.fieldRadius,
      multiplier: multiplier ?? this.multiplier,
      exitRx: exitRx ?? this.exitRx,
      exitRy: exitRy ?? this.exitRy,
      maxHits: maxHits ?? this.maxHits,
      isLeft: isLeft ?? this.isLeft,
      interval: interval ?? this.interval,
    );
  }
}

class MapData {
  final String name;
  final String id;
  final List<MapObject> objects;
  final double goalWidthRatio;
  final double goalYRatio;

  const MapData({
    required this.name,
    required this.id,
    required this.objects,
    this.goalWidthRatio = 0.4,
    this.goalYRatio = 0.97,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'goalWidthRatio': goalWidthRatio,
    'goalYRatio': goalYRatio,
    'objects': objects.map((o) => o.toJson()).toList(),
  };

  MapData copyWithObjects(List<MapObject> objects) {
    return MapData(
      name: name,
      id: id,
      objects: objects,
      goalWidthRatio: goalWidthRatio,
      goalYRatio: goalYRatio,
    );
  }

  factory MapData.fromJson(Map<String, dynamic> json) => MapData(
    name: json['name'] as String,
    id: json['id'] as String,
    goalWidthRatio: (json['goalWidthRatio'] as num?)?.toDouble() ?? 0.4,
    goalYRatio: (json['goalYRatio'] as num?)?.toDouble() ?? 0.97,
    objects: (json['objects'] as List)
        .map((o) => MapObject.fromJson(o as Map<String, dynamic>))
        .toList(),
  );
}
