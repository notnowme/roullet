import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/models/map_storage.dart';

enum PlacementStep {
  none,
  single,
  wormholeEntry,
  wormholeExit,
  mapLinePoints,
  pegZoneStart,
  pegZoneEnd,
  ropeStart,
  ropeEnd,
}

class EditorState {
  final MapData mapData;
  final String? selectedObjectId;
  final MapObjectType? placingType;
  final PlacementStep step;
  final List<List<double>> tempPoints; // mapLine 점, 웜홀 입구 좌표 등
  final String? guideMessage;

  const EditorState({
    required this.mapData,
    this.selectedObjectId,
    this.placingType,
    this.step = PlacementStep.none,
    this.tempPoints = const [],
    this.guideMessage,
  });

  EditorState copyWith({
    MapData? mapData,
    String? Function()? selectedObjectId,
    MapObjectType? Function()? placingType,
    PlacementStep? step,
    List<List<double>>? tempPoints,
    String? Function()? guideMessage,
  }) {
    return EditorState(
      mapData: mapData ?? this.mapData,
      selectedObjectId: selectedObjectId != null
          ? selectedObjectId()
          : this.selectedObjectId,
      placingType: placingType != null ? placingType() : this.placingType,
      step: step ?? this.step,
      tempPoints: tempPoints ?? this.tempPoints,
      guideMessage: guideMessage != null ? guideMessage() : this.guideMessage,
    );
  }

  MapObject? get selectedObject {
    if (selectedObjectId == null) return null;
    try {
      return mapData.objects.firstWhere((o) => o.id == selectedObjectId);
    } catch (_) {
      return null;
    }
  }
}

class EditorNotifier extends Notifier<EditorState> {
  @override
  EditorState build() {
    final String langCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final defaultName = switch (langCode) {
      'ko' => '새 맵',
      'ja' => '新規マップ',
      _ => 'New Map',
    };
    return EditorState(
      mapData: MapData(
        name: defaultName,
        id: '${DateTime.now().millisecondsSinceEpoch}',
        objects: [],
      ),
    );
  }

  /// 기존 맵 불러오기
  void loadMap(MapData map) {
    state = EditorState(mapData: map);
  }

  /// 맵 이름 변경
  void setName(String name) {
    state = state.copyWith(
      mapData: MapData(
        name: name,
        id: state.mapData.id,
        objects: state.mapData.objects,
        goalWidthRatio: state.mapData.goalWidthRatio,
        goalYRatio: state.mapData.goalYRatio,
      ),
    );
  }

  /// 배치
  void startPlacing(MapObjectType type, BuildContext context) {
    PlacementStep step;
    String guide;

    switch (type) {
      case MapObjectType.mapLine:
        step = PlacementStep.mapLinePoints;
        guide = AppLocalizations.of(context)!.guideWallLine01;
      case MapObjectType.pegZone:
        step = PlacementStep.pegZoneStart;
        guide = AppLocalizations.of(context)!.guidePegZone01;
      case MapObjectType.wormhole:
        step = PlacementStep.wormholeEntry;
        guide = AppLocalizations.of(context)!.guideWormHole01;
      case MapObjectType.elasticRope:
        step = PlacementStep.ropeStart; // 새 스텝 필요
        guide = AppLocalizations.of(context)!.guideRope01;
      default:
        step = PlacementStep.single;
        guide =
            '${_typeIcon(type)} ${AppLocalizations.of(context)!.guideTapDefault}';
    }

    state = state.copyWith(
      placingType: () => type,
      step: step,
      tempPoints: [],
      guideMessage: () => guide,
      selectedObjectId: () => null,
    );
  }

  /// 배치 취소
  void cancelPlacing() {
    state = state.copyWith(
      placingType: () => null,
      step: PlacementStep.none,
      tempPoints: [],
      guideMessage: () => null,
    );
  }

  /// 캔버스 탭 처리
  void onCanvasTap(double rx, double ry, BuildContext context) {
    switch (state.step) {
      case PlacementStep.none:
        _trySelect(rx, ry);

      case PlacementStep.single:
        _placeSingleObject(rx, ry);

      case PlacementStep.wormholeEntry:
        state = state.copyWith(
          tempPoints: [
            [rx, ry],
          ],
          step: PlacementStep.wormholeExit,
          guideMessage: () => AppLocalizations.of(context)!.guideWormHole02,
        );

      case PlacementStep.wormholeExit:
        _placeWormhole(rx, ry);

      case PlacementStep.mapLinePoints:
        final points = [
          ...state.tempPoints,
          [rx, ry],
        ];
        state = state.copyWith(
          tempPoints: points,
          guideMessage: () =>
              AppLocalizations.of(context)!.guideWallLineIng(points.length),
        );

      case PlacementStep.pegZoneStart:
        state = state.copyWith(
          tempPoints: [
            [rx, ry],
          ],
          step: PlacementStep.pegZoneEnd,
          guideMessage: () => AppLocalizations.of(context)!.guidePegZone02,
        );

      case PlacementStep.pegZoneEnd:
        _placePegZone(rx, ry);

      case PlacementStep.ropeStart:
        state = state.copyWith(
          tempPoints: [
            [rx, ry],
          ],
          step: PlacementStep.ropeEnd,
          guideMessage: () => AppLocalizations.of(context)!.guideRope02,
        );

      case PlacementStep.ropeEnd:
        _placeRope(rx, ry);
    }
  }

  void _placeRope(double rx, double ry) {
    final start = state.tempPoints.first;
    final obj = MapObject(
      type: MapObjectType.elasticRope,
      rx: start[0],
      ry: start[1],
      exitRx: rx,
      exitRy: ry,
      boostForce: 25.0,
    );
    _addObject(obj);
    cancelPlacing();
  }

  void finishMapLine() {
    if (state.tempPoints.length < 2) return;

    final obj = MapObject(
      type: MapObjectType.mapLine,
      rx: state.tempPoints.first[0],
      ry: state.tempPoints.first[1],
      points: List.from(state.tempPoints),
    );

    _addObject(obj);
    cancelPlacing();
  }

  void selectObject(String? id) {
    state = state.copyWith(
      selectedObjectId: () => id,
      placingType: () => null,
      step: PlacementStep.none,
      guideMessage: () => null,
    );
  }

  void moveObject(String id, double rx, double ry) {
    final objects = List<MapObject>.from(state.mapData.objects);
    final idx = objects.indexWhere((o) => o.id == id);
    if (idx < 0) return;

    objects[idx] = objects[idx].copyWith(rx: rx, ry: ry);
    state = state.copyWith(
      mapData: state.mapData.copyWithObjects(objects),
    );
  }

  void updateObject(String id, MapObject updated) {
    final objects = List<MapObject>.from(state.mapData.objects);
    final idx = objects.indexWhere((o) => o.id == id);
    if (idx < 0) return;

    objects[idx] = updated;
    state = state.copyWith(
      mapData: state.mapData.copyWithObjects(objects),
    );
  }

  void deleteSelected() {
    if (state.selectedObjectId == null) return;
    final objects = List<MapObject>.from(state.mapData.objects)
      ..removeWhere((o) => o.id == state.selectedObjectId);
    state = state.copyWith(
      mapData: state.mapData.copyWithObjects(objects),
      selectedObjectId: () => null,
    );
  }

  void duplicateSelected() {
    final obj = state.selectedObject;
    if (obj == null) return;
    final rng = math.Random().nextDouble() * 256;
    final copy = obj.copyWith(
      id: '${DateTime.now().millisecondsSinceEpoch}_dup$rng',
      rx: obj.rx + 0.03,
      ry: obj.ry + 0.001,
    );
    _addObject(copy);
    state = state.copyWith(selectedObjectId: () => copy.id);
  }

  void clearAll() {
    state = state.copyWith(
      mapData: state.mapData.copyWithObjects([]),
      selectedObjectId: () => null,
    );
  }

  Future<void> save() async {
    MapStorage.save(state.mapData);
  }

  void _placeSingleObject(double rx, double ry) {
    final type = state.placingType!;
    final obj = MapObject(
      type: type,
      rx: rx,
      ry: ry,
      size: _defaultSize(type),
      angle: _defaultAngle(type),
      speed: _defaultSpeed(type),
      fieldRadius: _defaultFieldRadius(type),
    );
    _addObject(obj);
    cancelPlacing();
    // state = state.copyWith(selectedObjectId: () => obj.id);
  }

  void _placeWormhole(double rx, double ry) {
    final entry = state.tempPoints.first;
    final obj = MapObject(
      type: MapObjectType.wormhole,
      rx: entry[0],
      ry: entry[1],
      exitRx: rx,
      exitRy: ry,
      fieldRadius: 0.08,
    );
    _addObject(obj);
    cancelPlacing();
    // state = state.copyWith(selectedObjectId: () => obj.id);
  }

  void _placePegZone(double rx, double ry) {
    final start = state.tempPoints.first;
    final obj = MapObject(
      type: MapObjectType.pegZone,
      rx: 0,
      ry: start[1],
      endRy: ry,
      density: 1.0,
    );
    _addObject(obj);
    cancelPlacing();
    // state = state.copyWith(selectedObjectId: () => obj.id);
  }

  void _trySelect(double rx, double ry) {
    const threshold = 0.05;
    MapObject? closest;
    double closestDist = double.infinity;

    for (final obj in state.mapData.objects) {
      double dist;

      if (obj.type == MapObjectType.pegZone) {
        // pegZone: y가 범위 안에 있으면 선택
        if (ry >= obj.ry && ry <= obj.endRy) {
          dist = 0;
        } else {
          continue;
        }
      } else if (obj.type == MapObjectType.mapLine) {
        // mapLine: 아무 점이나 가까우면 선택
        double minDist = double.infinity;
        for (final p in obj.points) {
          final d = _distance(p[0], p[1], rx, ry);
          if (d < minDist) minDist = d;
        }
        dist = minDist;
      } else {
        dist = _distance(obj.rx, obj.ry, rx, ry);
      }

      if (dist < threshold && dist < closestDist) {
        closest = obj;
        closestDist = dist;
      }
    }

    state = state.copyWith(
      selectedObjectId: () => closest?.id,
    );
  }

  void _addObject(MapObject obj) {
    final objects = [...state.mapData.objects, obj];
    state = state.copyWith(
      mapData: state.mapData.copyWithObjects(objects),
    );
  }

  double _distance(double x1, double y1, double x2, double y2) {
    final dx = x1 - x2;
    final dy = y1 - y2;
    return (dx * dx + dy * dy);
  }

  double _defaultSize(MapObjectType type) => switch (type) {
    MapObjectType.peg => 0.015,
    MapObjectType.circleBumper => 0.035,
    MapObjectType.triangle => 0.05,
    MapObjectType.plank => 0.2,
    MapObjectType.rotatingObject => 0.2,
    MapObjectType.movingObject => 0.2,
    MapObjectType.bouncePad => 0.15,
    // MapObjectType.conveyorBelt => 0.3,
    MapObjectType.breakableWall => 1.0,
    _ => 0.05,
  };

  double _defaultAngle(MapObjectType type) => switch (type) {
    MapObjectType.plank => 0.3,
    // MapObjectType.conveyorBelt => 0.0,
    _ => 0,
  };

  double _defaultSpeed(MapObjectType type) => switch (type) {
    MapObjectType.rotatingObject => 1.5,
    MapObjectType.movingObject => 0.1,
    // MapObjectType.conveyorBelt => 3.0,
    _ => 0,
  };

  double _defaultFieldRadius(MapObjectType type) => switch (type) {
    MapObjectType.accelField => 0.12,
    MapObjectType.decelField => 0.15,
    // MapObjectType.magnet => 0.1,
    MapObjectType.wormhole => 0.08,
    _ => 0,
  };

  String _typeIcon(MapObjectType type) => switch (type) {
    MapObjectType.peg => '⚫',
    MapObjectType.circleBumper => '🟠',
    MapObjectType.triangle => '🔺',
    MapObjectType.plank => '📏',
    MapObjectType.rotatingObject => '🔄',
    MapObjectType.movingObject => '↔️',
    MapObjectType.bouncePad => '⬆️',
    MapObjectType.breakableWall => '🧱',
    MapObjectType.accelField => '🔴',
    MapObjectType.decelField => '🔵',
    // MapObjectType.magnet => '🧲',
    MapObjectType.wormhole => '🔮',
    // MapObjectType.conveyorBelt => '⏩',
    MapObjectType.mapLine => '〰️',
    MapObjectType.pegZone => '⬛',
    MapObjectType.wall => '🧱',
    MapObjectType.flipper => '🏓',
    MapObjectType.elasticRope => '🪢',
  };
}

final editorProvider =
    NotifierProvider.autoDispose<EditorNotifier, EditorState>(
      EditorNotifier.new,
    );
