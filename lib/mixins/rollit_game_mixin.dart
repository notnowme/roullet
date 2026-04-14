import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/enums.dart';
import 'package:toruru/components/balls.dart';
import 'package:toruru/models/ball_skin.dart';
import 'package:toruru/components/particles.dart';
import 'package:toruru/components/slots.dart';
import 'package:toruru/models/map_builder.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/common/utils/game_audio.dart';
import 'package:toruru/screens/rollit_game.dart';

mixin RollitEvent on Forge2DGame, HasGameReference<RollitGame> {
  DeviceType getDeviceType(double shortSide, double ratio) {
    if (shortSide >= 600 && shortSide < 820 && ratio > 0.65 && ratio < 1.1) {
      return DeviceType.foldOpen;
    } else if (shortSide >= 280 && shortSide <= 400 && ratio < 0.55) {
      return DeviceType.foldClose;
    } else if (shortSide >= 720) {
      return DeviceType.tablet;
    } else {
      return DeviceType.normal;
    }
  }

  /// 반응형 줌 계산
  double calcZoom(Vector2 screenSize) {
    final shortSide = screenSize.x < screenSize.y ? screenSize.x : screenSize.y;
    final ratio = screenSize.x / screenSize.y;

    DeviceType type = getDeviceType(shortSide, ratio);

    return switch (type) {
      DeviceType.foldOpen => 20.0 * (screenSize.x / 360.0).clamp(1.2, 2.0),
      DeviceType.foldClose => 20.0 * (screenSize.x / 360.0).clamp(0.7, 1.2),
      DeviceType.tablet => 20.0 * (screenSize.x / 360.0).clamp(1.5, 2.8),
      DeviceType.normal => 20.0 * (screenSize.x / 360.0).clamp(0.8, 1.5),
    };
  }

  /// 골 지점 그리기
  void placeSlots() {
    final goalWidth = game.worldWidth;
    final goalX = 0.0;
    final goalTopY = game.worldHeight - 3.0;

    world.add(
      Slot(
        index: 0,
        label: 'GOAL',
        x: goalX,
        width: goalWidth,
        topY: goalTopY,
        bottomY: game.worldHeight,
      ),
    );

    // 골의 양쪽 벽
    // 골 위 벽 (가로 전체)
    // world.add(
    //   Wall(
    //     Vector2(0, goalTopY),
    //     Vector2(game.worldWidth, goalTopY),
    //   ),
    // );
  }

  /// 공 그리기
  void dropBullets() {
    final rng = math.Random();
    final ballRadius = game.worldWidth * game.settings.ballSize;
    final skin = game.settings.ballSkin;
    final count = game.names.length;

    final indices = game.ballIndices;

    for (int i = 0; i < count; i++) {
      final x = game.worldWidth / 2 + (i - count / 2) * ballRadius * 2.5;
      final idx = indices[i];

      final Color ballColor;
      final int pIndex;
      final double ballRestitution;
      final double ballDensity;
      switch (skin) {
        case BallSkin.solarSystem:
          final planet = planets[idx];
          ballColor = planet.baseColor;
          pIndex = idx;
          ballRestitution = planet.restitution;
          ballDensity = planet.density;
        case BallSkin.sports:
          final sport = sportsBalls[idx];
          ballColor = sport.trailColor;
          pIndex = idx;
          ballRestitution = sport.restitution;
          ballDensity = sport.density;
        case BallSkin.fruit:
          final fruit = fruits[idx];
          ballColor = fruit.trailColor;
          pIndex = idx;
          ballRestitution = fruit.restitution;
          ballDensity = fruit.density;
        case BallSkin.marble:
        case BallSkin.pixel:
        case BallSkin.slime:
          ballColor = marbleColors[idx];
          pIndex = -1;
          ballRestitution = skin.defaultRestitution;
          ballDensity = skin.defaultDensity;
      }

      world.add(
        Ball(
          Vector2(x, 1.5),
          radius: ballRadius,
          color: ballColor,
          name: game.names[i],
          planetIndex: pIndex,
          restitution: ballRestitution,
          density: ballDensity,
          initVelocity: Vector2(
            (rng.nextDouble() - 0.5) * 3.0,
            5.0,
          ),
        ),
      );
    }
  }

  /// 순위
  void updateRanking() {
    final balls = world.children
        .whereType<Ball>()
        .where((b) => b.isLoaded)
        .toList();
    balls.sort((a, b) => b.body.position.y.compareTo(a.body.position.y));
    final newRanking = balls.map((b) => b.name).toList();
    if (!listEquals(game.rankingNotifier.value, newRanking)) {
      game.rankingNotifier.value = List.from(newRanking);
    }
  }

  /// 공 멈추는 거 방지
  void unstuckBalls(double dt) {
    for (final ball in world.children.whereType<Ball>().where(
      (b) => b.isLoaded,
    )) {
      final speed = ball.body.linearVelocity.length;

      if (speed < 1.5) {
        ball.stuckTimer += dt;
        if (ball.stuckTimer > 2.5) {
          ball.stuckTimer = 0;
          ball.body.applyLinearImpulse(
            Vector2(
              (math.Random().nextDouble() - 0.2) * 5.0,
              5.0,
            ),
          );
        }
      } else {
        ball.stuckTimer = 0;
      }
    }
  }

  /// 카메라 설정
  void setCameraMode(CameraMode mode) {
    game.cameraMode = mode;
    if (mode == CameraMode.editor) {
      final zoomOut = game.size.y / game.worldHeight;
      camera.viewfinder.zoom = zoomOut;
      camera.viewfinder.position = Vector2(
        game.worldWidth / 2,
        game.worldHeight / 2,
      );
    } else {
      camera.viewfinder.zoom = calcZoom(game.size);

      // 공 위치로 즉시 이동
      // final balls = world.children.whereType<Ball>().where((b) => b.isLoaded);
      // if (balls.isNotEmpty) {
      //   final targetY = switch (mode) {
      //     CameraMode.followLast =>
      //       balls.map((b) => b.body.position.y).reduce((a, b) => a > b ? a : b),
      //     CameraMode.followFirst =>
      //       balls.map((b) => b.body.position.y).reduce((a, b) => a < b ? a : b),
      //     _ =>
      //       balls.map((b) => b.body.position.y).reduce((a, b) => a + b) /
      //           balls.length,
      //   };
      //   camera.viewfinder.position = Vector2(
      //     game.worldWidth / 2,
      //     targetY - (game.size.y / calcZoom(game.size)) * 0.5,
      //   );
      // }
    }
  }

  String _trackingBallName = '';
  Color _trackingBallColor = Colors.white;

  String get trackingBallName => _trackingBallName;
  Color get trackingBallColor => _trackingBallColor;

  void followLowestBall(double dt) {
    final balls = world.children
        .whereType<Ball>()
        .where((b) => b.isLoaded)
        .toList();
    if (balls.isEmpty) return;

    final lowest = balls.reduce(
      (a, b) => a.body.position.y > b.body.position.y ? a : b,
    );

    if (_updateCameraEvents(dt, balls, currentTarget: lowest)) return;

    _trackingBallName = lowest.name;
    _trackingBallColor = lowest.color;

    _moveCameraTo(
      Vector2(
        game.worldWidth / 2,
        lowest.body.position.y - (size.y / calcZoom(size)) * 0.1,
      ),
      dt,
    );
  }

  void followHighestBall(double dt) {
    final balls = world.children
        .whereType<Ball>()
        .where((b) => b.isLoaded)
        .toList();
    if (balls.isEmpty) return;

    final highest = balls.reduce(
      (a, b) => a.body.position.y < b.body.position.y ? a : b,
    );

    if (_updateCameraEvents(dt, balls, currentTarget: highest)) return;

    _trackingBallName = highest.name;
    _trackingBallColor = highest.color;

    _moveCameraTo(
      Vector2(
        game.worldWidth / 2,
        highest.body.position.y - (size.y / calcZoom(size)) * 0.1,
      ),
      dt,
    );
  }

  // ── 카메라 이벤트 감지 (모든 카메라 모드 공통) ──
  double _eventFocusTimer = 0.0;
  Ball? _eventBall;
  String _eventLabel = '';
  Color _eventColor = Colors.white;

  static const double _teleportFocusDuration = 3.5;
  static const double _goalFocusDuration = 4.0;
  static const double _teleportThreshold = 5.0;
  static const double _goalProximityRatio = 0.05; // 골까지 전체 높이의 5%

  /// 이벤트 감지(골 인접 / 텔레포트)를 수행하고, 포커스 중이면 true 반환.
  /// [currentTarget] 가 제공되면 해당 공이 이미 골 인접일 때는 가로채지 않음.
  bool _updateCameraEvents(double dt, List<Ball> balls, {Ball? currentTarget}) {
    _eventFocusTimer = (_eventFocusTimer - dt).clamp(0.0, double.infinity);

    final goalY = game.worldHeight - 3.0;
    final goalThreshold = game.worldHeight * _goalProximityRatio;

    // ── 골 인접 감지 (최우선) ──
    Ball? closestToGoal;
    double closestDist = double.infinity;
    for (final ball in balls) {
      final dist = _goalY - ball.body.position.y;
      if (dist > 0 && dist < goalThreshold && dist < closestDist) {
        closestDist = dist;
        closestToGoal = ball;
      }
    }

    if (closestToGoal != null) {
      // 이미 추적 중인 공이 골 인접이면 가로채지 않음
      if (currentTarget != null && currentTarget == closestToGoal) {
        _eventFocusTimer = 0;
        return false;
      }
      _eventBall = closestToGoal;
      _eventFocusTimer = _goalFocusDuration;
      _eventLabel = '${closestToGoal.name} ⚡';
      _eventColor = AppColor.success;
    }

    // ── 텔레포트 감지 (골 포커스 중이 아닐 때만) ──
    if (_eventFocusTimer <= 0 || _eventColor != AppColor.success) {
      for (final ball in balls) {
        if (ball.prevPosition.isZero()) {
          ball.prevPosition.setFrom(ball.body.position);
          continue;
        }
        final moved = ball.body.position.distanceTo(ball.prevPosition);
        if (moved > _teleportThreshold) {
          _eventBall = ball;
          _eventFocusTimer = _teleportFocusDuration;
          _eventLabel = '${ball.name} ⚡';
          _eventColor = const Color(0xFF9C27B0);
          ball.teleportFlash = 1.0;
        }
        ball.prevPosition.setFrom(ball.body.position);
      }
    } else {
      // 골 포커스 중에도 prevPosition은 갱신
      for (final ball in balls) {
        ball.prevPosition.setFrom(ball.body.position);
      }
    }

    // 이벤트 추적 중이던 공이 골인해서 제거된 경우 즉시 포커스 해제
    if (_eventBall != null && !_eventBall!.isMounted) {
      _eventBall = null;
      _eventFocusTimer = 0;
    }

    if (_eventFocusTimer > 0 && _eventBall != null) {
      _trackingBallName = _eventLabel;
      _trackingBallColor = _eventColor;
      _moveCameraTo(
        Vector2(
          game.worldWidth / 2,
          _eventBall!.body.position.y - (size.y / calcZoom(size)) * 0.1,
        ),
        dt,
      );
      return true;
    }
    return false;
  }

  void followBattle(double dt) {
    final balls = world.children
        .whereType<Ball>()
        .where((b) => b.isLoaded)
        .toList();
    if (balls.isEmpty) return;

    if (_updateCameraEvents(dt, balls)) return;

    // ── 격전지 탐색 ──
    final ys = balls.map((b) => b.body.position.y).toList();
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    final range = (maxY - minY).clamp(1.0, double.infinity);
    const segments = 10;
    final segSize = range / segments;

    int maxCount = 0;
    double battleY = (minY + maxY) / 2;

    for (int i = 0; i < segments; i++) {
      final segStart = minY + i * segSize;
      final segEnd = segStart + segSize;
      final count = ys.where((y) => y >= segStart && y < segEnd).length;
      if (count > maxCount) {
        maxCount = count;
        battleY = (segStart + segEnd) / 2;
      }
    }

    // 밀집 구간이 없으면 승리 조건에 따라 추적
    if (maxCount <= 1) {
      if (game.winCondition == WinCondition.first) {
        final lowest = balls.reduce(
          (a, b) => a.body.position.y > b.body.position.y ? a : b,
        );
        _trackingBallName = lowest.name;
        _trackingBallColor = lowest.color;
        _moveCameraTo(
          Vector2(
            game.worldWidth / 2,
            lowest.body.position.y - (size.y / calcZoom(size)) * 0.1,
          ),
          dt,
        );
      } else {
        final highest = balls.reduce(
          (a, b) => a.body.position.y < b.body.position.y ? a : b,
        );
        _trackingBallName = highest.name;
        _trackingBallColor = highest.color;
        _moveCameraTo(
          Vector2(
            game.worldWidth / 2,
            highest.body.position.y - (size.y / calcZoom(size)) * 0.1,
          ),
          dt,
        );
      }
      return;
    }

    _trackingBallName = '격전지 ($maxCount명)';
    _trackingBallColor = AppColor.warning;
    _moveCameraTo(Vector2(game.worldWidth / 2, battleY), dt);
  }

  void _moveCameraTo(Vector2 target, double dt) {
    final current = camera.viewfinder.position;

    // 지수 감쇠 보간 — 프레임레이트 독립적이고 부드러운 추적
    const smoothSpeed = 60.0;
    final t = 1.0 - math.exp(-smoothSpeed * dt);
    camera.viewfinder.position = Vector2(
      current.x + (target.x - current.x) * t,
      current.y + (target.y - current.y) * t,
    );
  }

  /// 맵을 배치
  Future<void> buildMap(MapData mapData) async {
    final builder = MapBuilder(
      mapData: mapData,
      worldWidth: game.worldWidth,
      worldHeight: game.worldHeight,
    );

    final components = builder.build();

    for (int i = 0; i < components.length; i++) {
      world.add(components[i]);
    }
  }

  /// 보이는 공 수
  int get visibleBalCount {
    final rect = camera.visibleWorldRect;
    return world.children.whereType<Ball>().where((b) => b.isLoaded).where((
      ball,
    ) {
      final pos = ball.body.position;
      return rect.contains(Offset(pos.x, pos.y));
    }).length;
  }

  /// 도착 확인
  void checkGoalArrival() {
    if (game.winCondition == WinCondition.last) {
      final lastCheck = world.children
          .whereType<Ball>()
          .where((b) => b.isLoaded)
          .toList();
      if (lastCheck.length == 1) {
        onBallArrived(lastCheck.last.name);
      }
    }
    for (final ball in world.children.whereType<Ball>().where(
      (b) => b.isLoaded,
    )) {
      if (ball.body.position.y >= _goalY) {
        onBallArrived(ball.name);
        // 이벤트 카메라가 이 공을 추적 중이었다면 즉시 해제 → 다음 대상으로 전환
        if (_eventBall == ball) {
          _eventBall = null;
          _eventFocusTimer = 0;
        }
        // 다음 프레임에 퇴출
        Future.microtask(() => ball.removeFromParent());
      }
    }
  }

  double slowMotionFactor = 1.0;
  double get _goalY => game.worldHeight - 3.0;

  /// 골 전에 느리게
  void checkSlowMotion() {
    final slowZoneStart = _goalY - game.worldHeight * 0.03; // 골 3% 위부터

    final balls = world.children.whereType<Ball>().where((b) => b.isLoaded);
    if (balls.isEmpty) return;

    // 가장 앞선 공의 y좌표
    final lowestY = balls
        .map((b) => b.body.position.y)
        .reduce((a, b) => a > b ? a : b);

    if (lowestY >= slowZoneStart && lowestY < _goalY) {
      // 골에 가까울수록 느려짐 (1.0 → 0.3)
      final progress = (lowestY - slowZoneStart) / (_goalY - slowZoneStart);
      slowMotionFactor = 1.0 - (progress * 0.7);
    } else {
      // 서서히 원래 속도로 복귀
      slowMotionFactor = (slowMotionFactor + 0.02).clamp(0.0, 1.0);
    }
  }

  /// 교착 상태 (게임 시간이 너무 길어지면) 강제로 진행시키기
  double _gameTimer = 0;
  double _lastForceEventTime = 0;
  static const double _forceEventInterval = 30.0;
  static const double _maxGameTime = 120.0;

  void checkGameTimeout(double dt) {
    _gameTimer += dt;

    if (_gameTimer - _lastForceEventTime > _forceEventInterval) {
      _lastForceEventTime = _gameTimer;

      // 모든 공에 아랫쪽으로 강하게
      final balls = world.children.whereType<Ball>().where((b) => b.isLoaded);
      for (final ball in balls) {
        ball.body.applyLinearImpulse(
          Vector2(
            (math.Random().nextDouble() - 0.5) * 8.0,
            15.0,
          ),
        );
      }

      // 최대 시간 초과 시 가장 앞선 공 강제 당첨?
      if (_gameTimer > _maxGameTime) {
        final balls = world.children
            .whereType<Ball>()
            .where((b) => b.isLoaded)
            .toList();
        if (balls.isNotEmpty) {
          balls.sort((a, b) => b.body.position.y.compareTo(a.body.position.y));
          onBallArrived(balls.first.name);
        }
      }
    }
  }

  /// 도착
  void onBallArrived(String name) {
    if (game.arrivals.contains(name)) return;
    game.arrivals.add(name);

    GameAudio.instance.playGoalArrive();
    world.add(
      GameParticles.goalCelebration(
        position: Vector2(game.worldWidth / 2, _goalY),
      ),
    );

    // 승자 판별 로직 분리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWinCondition(name);
    });
  }

  void _checkWinCondition(String name) {
    final arrivalsCount = game.arrivals.length;
    final totalPlayers = game.names.length;

    switch (game.winCondition) {
      // 1등부터 n명
      case WinCondition.firstToNums:
        if (arrivalsCount == game.winnerNums) {
          game.onWinner(game.arrivals.take(game.winnerNums).join(', '));
        }
        break;

      // 1등
      case WinCondition.first:
        if (game.winnerNums == 2 && arrivalsCount == 1) {
          game.onWinner(name);
        }
        break;

      // 꼴등부터 n명
      case WinCondition.lastToNums:
        // 도착할 때마다 winners에 추가
        game.winners.add(name);
        if (game.winners.length == totalPlayers - game.winnerNums) {
          // 전체 리스트에서 도착한 리스트 중복되지 않는 것만 빼기
          final winners = game.names
              .where((n) => !game.winners.contains(n))
              .join(', ');
          game.onWinner(winners);
        }
        break;

      // 꼴등
      case WinCondition.last:
        if (arrivalsCount == totalPlayers) {
          game.onWinner(game.arrivals.last);
        }
        break;
    }
  }
}
