import 'package:toruru/models/map_data.dart';

final defaultMaps = [
  lavaCaveMap,
  rollerCoaster,
];

// final hellFunnelMap = MapData(
//   name: '지옥의 깔때기',
//   id: 'hellFunnel',
//   objects: [
//     // 상단 페그 구역
//     MapObject(type: MapObjectType.pegZone, ry: 0.01, endRy: 0.16, density: 1.0),
//     MapObject(
//       type: MapObjectType.elasticRope,
//       rx: 0.3,
//       ry: 0.5,
//       exitRx: 0.6,
//       exitRy: 0.6,
//       boostForce: 30.0,
//     ),
//     MapObject(
//       type: MapObjectType.accelField,
//       rx: 0.3,
//       ry: 0.5,
//       fieldRadius: 0.17,
//       multiplier: 1.5,
//     ),
//     MapObject(
//       type: MapObjectType.decelField,
//       rx: 0.7,
//       ry: 0.5,
//       fieldRadius: 0.17,
//       multiplier: 0.4,
//     ),
//     // 깔때기 왼쪽
//     MapObject(
//       type: MapObjectType.mapLine,
//       points: [
//         [0, 0.16],
//         [0.15, 0.24],
//         [0.35, 0.3],
//         [0.45, 0.32],
//       ],
//     ),
//     // 깔때기 오른쪽
//     MapObject(
//       type: MapObjectType.mapLine,
//       points: [
//         [1.0, 0.16],
//         [0.85, 0.24],
//         [0.65, 0.3],
//         [0.55, 0.32],
//       ],
//     ),

//     // 판자들
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.2,
//       ry: 0.36,
//       size: 0.25,
//       angle: 0.5,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.8,
//       ry: 0.36,
//       size: 0.25,
//       angle: -0.5,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.5,
//       ry: 0.42,
//       size: 0.3,
//       angle: 0.0,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.2,
//       ry: 0.48,
//       size: 0.25,
//       angle: -0.4,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.8,
//       ry: 0.48,
//       size: 0.25,
//       angle: 0.4,
//     ),

//     // 회전 장애물
//     MapObject(
//       type: MapObjectType.rotatingObject,
//       rx: 0.5,
//       ry: 0.52,
//       size: 0.3,
//       speed: 1.5,
//     ),
//     // 이동 장애물
//     MapObject(
//       type: MapObjectType.movingObject,
//       rx: 0.5,
//       ry: 0.58,
//       size: 0.2,
//       horizontal: true,
//       range: 0.25,
//       speed: 0.1,
//     ),

//     // 두 번째 깔때기
//     MapObject(
//       type: MapObjectType.mapLine,
//       points: [
//         [0, 0.62],
//         [0.1, 0.68],
//         [0.4, 0.72],
//         [0.48, 0.74],
//       ],
//     ),
//     MapObject(
//       type: MapObjectType.mapLine,
//       points: [
//         [1.0, 0.62],
//         [0.9, 0.68],
//         [0.6, 0.72],
//         [0.52, 0.74],
//       ],
//     ),

//     // 바운스패드
//     MapObject(
//       type: MapObjectType.bouncePad,
//       rx: 0.3,
//       ry: 0.78,
//       size: 0.2,
//       boostForce: 40.0,
//     ),
//     MapObject(
//       type: MapObjectType.bouncePad,
//       rx: 0.7,
//       ry: 0.78,
//       size: 0.2,
//       boostForce: 40.0,
//     ),

//     // 원형 장애물
//     MapObject(type: MapObjectType.circleBumper, rx: 0.5, ry: 0.82, size: 0.05),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.2, ry: 0.84, size: 0.035),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.8, ry: 0.84, size: 0.035),

//     // 하단 페그 구역
//     MapObject(type: MapObjectType.pegZone, ry: 0.88, endRy: 0.95, density: 1.5),
//   ],
// );

// final pinballChaosMap = MapData(
//   name: '핀볼 카오스',
//   id: 'pinballChaos',
//   objects: [
//     // 지그재그 판자 8개
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.3,
//       ry: 0.04,
//       size: 0.5,
//       angle: 0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.7,
//       ry: 0.095,
//       size: 0.5,
//       angle: -0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.3,
//       ry: 0.15,
//       size: 0.5,
//       angle: 0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.7,
//       ry: 0.205,
//       size: 0.5,
//       angle: -0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.3,
//       ry: 0.26,
//       size: 0.5,
//       angle: 0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.7,
//       ry: 0.315,
//       size: 0.5,
//       angle: -0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.3,
//       ry: 0.37,
//       size: 0.5,
//       angle: 0.35,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.7,
//       ry: 0.425,
//       size: 0.5,
//       angle: -0.35,
//     ),

//     // 범퍼 밀집 구간
//     MapObject(type: MapObjectType.circleBumper, rx: 0.2, ry: 0.30, size: 0.025),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.5, ry: 0.28, size: 0.025),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.8, ry: 0.30, size: 0.025),
//     MapObject(
//       type: MapObjectType.circleBumper,
//       rx: 0.35,
//       ry: 0.35,
//       size: 0.025,
//     ),
//     MapObject(
//       type: MapObjectType.circleBumper,
//       rx: 0.65,
//       ry: 0.35,
//       size: 0.025,
//     ),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.1, ry: 0.40, size: 0.025),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.5, ry: 0.38, size: 0.025),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.9, ry: 0.40, size: 0.025),
//     MapObject(
//       type: MapObjectType.circleBumper,
//       rx: 0.25,
//       ry: 0.45,
//       size: 0.025,
//     ),
//     MapObject(
//       type: MapObjectType.circleBumper,
//       rx: 0.75,
//       ry: 0.45,
//       size: 0.025,
//     ),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.5, ry: 0.50, size: 0.025),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.2, ry: 0.53, size: 0.025),
//     MapObject(type: MapObjectType.circleBumper, rx: 0.8, ry: 0.53, size: 0.025),

//     // 회전 + 이동 장애물
//     MapObject(
//       type: MapObjectType.rotatingObject,
//       rx: 0.5,
//       ry: 0.58,
//       size: 0.35,
//       speed: 2.0,
//     ),
//     MapObject(
//       type: MapObjectType.movingObject,
//       rx: 0.5,
//       ry: 0.64,
//       size: 0.2,
//       horizontal: true,
//       range: 0.3,
//       speed: 0.12,
//     ),

//     // V자 트랩 (4단)
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.25,
//       ry: 0.68,
//       size: 0.35,
//       angle: 0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.75,
//       ry: 0.68,
//       size: 0.35,
//       angle: -0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.25,
//       ry: 0.72,
//       size: 0.35,
//       angle: 0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.75,
//       ry: 0.72,
//       size: 0.35,
//       angle: -0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.25,
//       ry: 0.76,
//       size: 0.35,
//       angle: 0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.75,
//       ry: 0.76,
//       size: 0.35,
//       angle: -0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.25,
//       ry: 0.80,
//       size: 0.35,
//       angle: 0.45,
//     ),
//     MapObject(
//       type: MapObjectType.plank,
//       rx: 0.75,
//       ry: 0.80,
//       size: 0.35,
//       angle: -0.45,
//     ),

//     // 삼각형
//     MapObject(type: MapObjectType.triangle, rx: 0.5, ry: 0.82, size: 0.06),
//     MapObject(type: MapObjectType.triangle, rx: 0.2, ry: 0.85, size: 0.04),
//     MapObject(type: MapObjectType.triangle, rx: 0.8, ry: 0.85, size: 0.04),

//     // 바운스패드
//     MapObject(
//       type: MapObjectType.bouncePad,
//       rx: 0.5,
//       ry: 0.88,
//       size: 0.3,
//       boostForce: 50.0,
//     ),

//     // 하단 페그 구역
//     MapObject(type: MapObjectType.pegZone, ry: 0.91, endRy: 0.96, density: 2.0),
//   ],
// );

final lavaCaveMap = MapData(
  name: 'Lava Cave',
  id: 'lavaCave',
  objects: [
    // 왼쪽 동굴 벽
    MapObject(
      type: MapObjectType.mapLine,
      points: [
        [0, 0],
        [0.1, 0.1],
        [0.25, 0.18],
        [0.05, 0.26],
        [0.2, 0.36],
        [0.0, 0.46],
        [0.15, 0.56],
        [0.3, 0.66],
        [0.1, 0.76],
        [0.2, 0.84],
        [0.05, 0.92],
        [0, 1.0],
      ],
    ),
    // 오른쪽 동굴 벽
    MapObject(
      type: MapObjectType.mapLine,
      points: [
        [1.0, 0],
        [0.9, 0.1],
        [0.75, 0.18],
        [0.95, 0.26],
        [0.8, 0.36],
        [1.0, 0.46],
        [0.85, 0.56],
        [0.7, 0.66],
        [0.9, 0.76],
        [0.8, 0.84],
        [0.95, 0.92],
        [1.0, 1.0],
      ],
    ),

    // 상단 판자
    MapObject(
      type: MapObjectType.plank,
      rx: 0.5,
      ry: 0.06,
      size: 0.3,
      angle: 0.0,
    ),
    MapObject(
      type: MapObjectType.plank,
      rx: 0.3,
      ry: 0.13,
      size: 0.25,
      angle: 0.3,
    ),
    MapObject(
      type: MapObjectType.plank,
      rx: 0.7,
      ry: 0.13,
      size: 0.25,
      angle: -0.3,
    ),

    // 회전 장애물
    MapObject(
      type: MapObjectType.rotatingObject,
      rx: 0.5,
      ry: 0.22,
      size: 0.28,
      speed: -1.8,
    ),

    // 원형 장애물 (상단)
    MapObject(type: MapObjectType.circleBumper, rx: 0.5, ry: 0.33, size: 0.04),
    MapObject(type: MapObjectType.circleBumper, rx: 0.25, ry: 0.4, size: 0.03),
    MapObject(type: MapObjectType.circleBumper, rx: 0.75, ry: 0.4, size: 0.03),

    // 이동 장애물 (수직)
    MapObject(
      type: MapObjectType.movingObject,
      rx: 0.5,
      ry: 0.48,
      size: 0.2,
      horizontal: false,
      range: 0.04,
      speed: 0.015,
    ),

    // 원형 장애물 (중단)
    MapObject(type: MapObjectType.circleBumper, rx: 0.5, ry: 0.56, size: 0.05),
    MapObject(type: MapObjectType.circleBumper, rx: 0.2, ry: 0.62, size: 0.025),
    MapObject(type: MapObjectType.circleBumper, rx: 0.8, ry: 0.62, size: 0.025),

    // 삼각형 (종유석)
    MapObject(type: MapObjectType.triangle, rx: 0.5, ry: 0.68, size: 0.05),
    MapObject(type: MapObjectType.triangle, rx: 0.3, ry: 0.74, size: 0.035),
    MapObject(type: MapObjectType.triangle, rx: 0.7, ry: 0.74, size: 0.035),

    // 페그 구역
    MapObject(type: MapObjectType.pegZone, ry: 0.78, endRy: 0.9, density: 1.2),

    // 바운스패드
    MapObject(
      type: MapObjectType.bouncePad,
      rx: 0.5,
      ry: 0.86,
      size: 0.25,
      boostForce: 35.0,
    ),

    // 하단 좁은 통로
    MapObject(
      type: MapObjectType.mapLine,
      points: [
        [0.35, 0.91],
        [0.35, 0.95],
        [0.5, 0.96],
        [0.65, 0.95],
        [0.65, 0.91],
      ],
    ),

    // 웜홀
    MapObject(
      type: MapObjectType.wormhole,
      rx: 0.5,
      ry: 0.957, // 입구: 하단 구석
      exitRx: 0.5,
      exitRy: 0.2, // 출구: 상단 반대편 → 뒤로 돌아감
      fieldRadius: 0.1,
    ),

    // 최하단 페그
    MapObject(
      type: MapObjectType.pegZone,
      ry: 0.96,
      endRy: 0.975,
      density: 2.0,
    ),
  ],
);

final rollerCoaster = MapData(
  name: 'Pinball Chaos',
  id: 'rollerCoaster',
  objects: [
    // 출발: 페그로 흩어지기
    MapObject(type: MapObjectType.pegZone, ry: 0.02, endRy: 0.12, density: 1.0),

    // 전반: 지그재그 판자 (좌우로 흘러감)
    MapObject(
      type: MapObjectType.plank,
      rx: 0.25,
      ry: 0.18,
      size: 0.35,
      angle: 0.3,
    ),
    MapObject(
      type: MapObjectType.plank,
      rx: 0.75,
      ry: 0.25,
      size: 0.35,
      angle: -0.3,
    ),
    MapObject(
      type: MapObjectType.plank,
      rx: 0.25,
      ry: 0.32,
      size: 0.35,
      angle: 0.3,
    ),

    // 중반: 회전 장애물 (역전 포인트)
    MapObject(
      type: MapObjectType.rotatingObject,
      rx: 0.5,
      ry: 0.42,
      size: 0.3,
      speed: 1.5,
    ),
    // 빈 공간 (가속)

    // 후반: 바운스패드 + 좁은 깔때기
    MapObject(
      type: MapObjectType.bouncePad,
      rx: 0.5,
      ry: 0.6,
      size: 0.25,
      boostForce: 30.0,
    ),
    MapObject(
      type: MapObjectType.mapLine,
      points: [
        [0, 0.65],
        [0.35, 0.75],
      ],
    ),
    MapObject(
      type: MapObjectType.mapLine,
      points: [
        [1.0, 0.65],
        [0.65, 0.75],
      ],
    ),

    // 마무리: 밀집 페그 → 골
    MapObject(type: MapObjectType.pegZone, ry: 0.8, endRy: 0.93, density: 1.5),
  ],
);
