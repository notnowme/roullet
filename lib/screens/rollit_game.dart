import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toruru/common/constants/enums.dart';
import 'package:toruru/common/utils/game_audio.dart';
import 'package:toruru/components/walls.dart';
import 'package:toruru/mixins/rollit_game_mixin.dart';
import 'package:toruru/models/game_settings.dart';
import 'package:toruru/models/map_data.dart';

class RollitGame extends Forge2DGame
    with HasGameReference<RollitGame>, RollitEvent {
  RollitGame({
    required this.names,
    required this.onWinner,
    required this.mapData,
    required this.settings,
    required this.ballIndices,
    this.onArrival,
    this.winCondition = WinCondition.first,
    required this.winners,
    this.winnerNums = 2,
  }) : super(gravity: Vector2(0, settings.gravity));

  late double worldWidth;
  late double worldHeight;

  final void Function(String winner) onWinner;
  final void Function(List<String> arrivals)? onArrival;
  final List<String> names;
  final MapData mapData;
  final WinCondition winCondition;
  final List<String> arrivals = [];
  final GameSettings settings;
  final List<int> ballIndices;
  final List<String> winners;
  int winnerNums;

  final rankingNotifier = ValueNotifier<List<String>>([]);

  CameraMode cameraMode = CameraMode.followLast;

  double _countdownTimer = 3.0;
  int _countdownValue = 3;
  bool _countdownDone = false;
  bool _ballsDropped = false;

  // 카운트다운 애니메이션 상태
  double _stepElapsed = 0.0; // 현재 숫자가 표시된 후 경과 시간
  int _lastPlayedBeep = -1; // 이미 재생한 비프 추적

  @override
  Color backgroundColor() => const Color(0xFF0D0D1A);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    // if (kDebugMode) {
    //   add(
    //     FpsTextComponent(),
    //   );
    // }

    await GameAudio.instance.preload();

    final zoom = calcZoom(size);
    camera.viewfinder.zoom = zoom;

    worldWidth = size.x / zoom;
    final aspectRatio = size.y / size.x;
    final rawHeight = worldWidth * aspectRatio * 25;
    worldHeight = rawHeight.clamp(worldWidth * 20, worldWidth * 40);

    camera.moveTo(Vector2(worldWidth / 2, size.y / zoom / 2));

    await world.addAll([
      Wall(Vector2(0, 0), Vector2(worldWidth, 0)),
      Wall(Vector2(worldWidth, 0), Vector2(worldWidth, worldHeight)),
      Wall(Vector2(0, worldHeight), Vector2(worldWidth, worldHeight)),
      Wall(Vector2(0, 0), Vector2(0, worldHeight)),
    ]);

    await buildMap(mapData);
    placeSlots();

    _countdownTimer = 3.0;
    _countdownValue = 3;
    _countdownDone = false;
    _ballsDropped = false;
    _stepElapsed = 0.0;
    _lastPlayedBeep = -1;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (cameraMode == CameraMode.editor) {
      final zoomOut = size.y / worldHeight;
      camera.viewfinder.zoom = zoomOut;
      camera.viewfinder.position = Vector2(
        worldWidth / 2,
        worldHeight / 2,
      );
    } else {
      camera.viewfinder.zoom = calcZoom(size);
    }
  }

  @override
  void update(double dt) {
    final showCountDown = settings.countdown;
    if (showCountDown) {
      if (!_countdownDone) {
        _countdownTimer -= dt;
        _stepElapsed += dt;
        final newValue = _countdownTimer.ceil().clamp(0, 3);
        if (newValue != _countdownValue) {
          _countdownValue = newValue;
          _stepElapsed = 0.0;
          // 비프 사운드
          if (newValue > 0 && newValue != _lastPlayedBeep) {
            _lastPlayedBeep = newValue;
            GameAudio.instance.playCountdownBeep();
          }
        }
        if (_countdownTimer <= 0) {
          _countdownDone = true;
          if (!_ballsDropped) {
            _ballsDropped = true;
            GameAudio.instance.playCountdownGo();
            dropBullets();
          }
        }
        return;
      }
    } else if (!showCountDown && !_ballsDropped) {
      dropBullets();
      _countdownDone = true;
      _ballsDropped = true;
    }

    if (settings.slowMotion) {
      checkSlowMotion();
    }
    final adjustedDt = dt * slowMotionFactor;

    super.update(adjustedDt);
    updateRanking();
    unstuckBalls(dt);
    checkGoalArrival();
    // checkGameTimeout(dt);

    switch (cameraMode) {
      case CameraMode.followLast:
        followLowestBall(adjustedDt);
      case CameraMode.followFirst:
        followHighestBall(adjustedDt);
      case CameraMode.followBattle:
        followBattle(adjustedDt);
      case CameraMode.editor:
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!_countdownDone) {
      _renderCountdown(canvas);
    }
  }

  void _renderCountdown(Canvas canvas) {
    final cx = size.x / 2;
    final cy = size.y / 2;

    // 배경 오버레이
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF0D0D1A).withValues(alpha: 0.6),
    );

    // t: 0→1 (각 숫자가 등장한 후 경과 비율)
    final t = _stepElapsed.clamp(0.0, 1.0);

    // ── 링 이펙트: 바깥으로 퍼지면서 사라짐 ──
    final ringRadius = size.x * 0.15 + size.x * 0.3 * t;
    final ringAlpha = (1.0 - t).clamp(0.0, 1.0);
    if (ringAlpha > 0.01) {
      canvas.drawCircle(
        Offset(cx, cy),
        ringRadius,
        Paint()
          ..color =
              (_countdownValue > 0 ? Colors.white : const Color(0xFF4ECDC4))
                  .withValues(alpha: ringAlpha * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0 * (1.0 - t),
      );
    }

    // ── 스케일 펄스: 크게 나타났다가 안정 ──
    // bounceOut 느낌: 초반에 1.3배 → 1.0배로 수렴
    final scaleT = t < 0.3 ? t / 0.3 : 1.0;
    final scale = 1.0 + 0.3 * math.sin(scaleT * math.pi) * (1.0 - scaleT);

    // ── 페이드인 ──
    final textAlpha = t < 0.1 ? t / 0.1 : 1.0;

    final isGo = _countdownValue <= 0;
    final text = isGo ? 'GO!' : '$_countdownValue';
    final baseFontSize = isGo ? size.x * 0.2 : size.x * 0.3;
    final fontSize = baseFontSize * scale;

    final color = isGo
        ? const Color(0xFF4ECDC4).withValues(alpha: textAlpha)
        : Colors.white.withValues(alpha: textAlpha * 0.9);

    // ── 글로우 (텍스트 뒤 블러) ──
    final glowTp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withValues(alpha: textAlpha * 0.4),
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(cx, cy);
    // 글로우
    glowTp.paint(
      canvas,
      Offset(-glowTp.width / 2, -glowTp.height / 2),
    );
    canvas.restore();

    // ── 메인 텍스트 ──
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(cx - tp.width / 2, cy - tp.height / 2),
    );
  }
}
