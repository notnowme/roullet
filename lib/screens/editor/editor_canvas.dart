part of 'editor_screen.dart';

class _EditorCanvas extends ConsumerStatefulWidget {
  const _EditorCanvas();

  @override
  ConsumerState<_EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends ConsumerState<_EditorCanvas> {
  final _transformController = TransformationController();

  double? _previewRx;
  double? _previewRy;
  bool _moveMode = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Offset _screenToRatio(
    Offset screenPos,
    double canvasWidth,
    double canvasHeight,
  ) {
    final matrix = Matrix4.inverted(_transformController.value);
    final transformed = MatrixUtils.transformPoint(matrix, screenPos);
    return Offset(
      (transformed.dx / canvasWidth).clamp(0.0, 1.0),
      (transformed.dy / canvasHeight).clamp(0.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        // 게임과 동일한 높이 비율 계산
        final screenSize = MediaQuery.of(context).size;
        final aspectRatio = screenSize.height / screenSize.width;
        final heightRatio = (aspectRatio * 25).clamp(20.0, 40.0);
        final canvasHeight = canvasWidth * heightRatio;

        return Column(
          children: [
            _CanvasToolRow(
              moveMode: _moveMode,
              onToggleMode: () => setState(() => _moveMode = !_moveMode),
              onResetZoom: () =>
                  _transformController.value = Matrix4.identity(),
            ),
            Expanded(
              child: Listener(
                onPointerMove: state.placingType != null
                    ? (event) {
                        final ratio = _screenToRatio(
                          event.localPosition,
                          canvasWidth,
                          canvasHeight,
                        );
                        setState(() {
                          _previewRx = ratio.dx;
                          _previewRy = ratio.dy;
                        });
                      }
                    : null,
                onPointerUp: state.placingType != null
                    ? (event) {
                        setState(() {
                          _previewRx = null;
                          _previewRy = null;
                        });
                      }
                    : null,
                child: InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 0.1,
                  maxScale: 3.0,
                  constrained: false,
                  boundaryMargin: EdgeInsets.symmetric(
                    horizontal: canvasWidth * 0.5,
                    vertical: canvasHeight * 0.1,
                  ),
                  panEnabled: !_moveMode,
                  child: GestureDetector(
                    onTapUp: (details) {
                      final rx = (details.localPosition.dx / canvasWidth).clamp(
                        0.0,
                        1.0,
                      );
                      final ry = (details.localPosition.dy / canvasHeight)
                          .clamp(0.0, 1.0);
                      ref
                          .read(editorProvider.notifier)
                          .onCanvasTap(rx, ry, context);
                    },
                    child: SizedBox(
                      width: canvasWidth,
                      height: canvasHeight,
                      child: CustomPaint(
                        painter: _CanvasPainter(
                          mapData: state.mapData,
                          selectedId: state.selectedObjectId,
                          tempPoints: state.tempPoints,
                          step: state.step,
                          previewType: state.placingType,
                          previewRx: _previewRx,
                          previewRy: _previewRy,
                        ),
                        child: Stack(
                          children: [
                            for (final obj in state.mapData.objects)
                              if (obj.type != MapObjectType.mapLine &&
                                  obj.type != MapObjectType.pegZone)
                                _DragHandle(
                                  obj: obj,
                                  canvasWidth: canvasWidth,
                                  canvasHeight: canvasHeight,
                                  isSelected: obj.id == state.selectedObjectId,
                                  enabled: _moveMode,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── 캔버스 도구 행 ─────────────────────────────────────────────────

class _CanvasToolRow extends StatelessWidget {
  const _CanvasToolRow({
    required this.moveMode,
    required this.onToggleMode,
    required this.onResetZoom,
  });

  final bool moveMode;
  final VoidCallback onToggleMode;
  final VoidCallback onResetZoom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: AppColor.bgCard.withValues(alpha: 0.5),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggleMode,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: AppUI.neonToggle(
                isSelected: moveMode,
                activeColor: AppColor.warning,
                borderRadius: 6,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    moveMode ? Icons.open_with : Icons.pan_tool,
                    color: moveMode ? AppColor.warning : AppColor.textMuted,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    moveMode
                        ? AppLocalizations.of(context)!.move
                        : AppLocalizations.of(context)!.scroll,
                    style: TextStyle(
                      color: moveMode ? AppColor.warning : AppColor.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onResetZoom,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.zoomRest,
                style: const TextStyle(color: AppColor.textMuted, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 드래그 핸들 ────────────────────────────────────────────────────

class _DragHandle extends ConsumerWidget {
  const _DragHandle({
    required this.obj,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.isSelected,
    this.enabled = true,
  });

  final MapObject obj;
  final double canvasWidth;
  final double canvasHeight;
  final bool isSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final x = obj.rx * canvasWidth;
    final y = obj.ry * canvasHeight;
    final handleSize = isSelected ? 32.0 : 24.0;

    return Positioned(
      left: x - handleSize / 2,
      top: y - handleSize / 2,
      child: GestureDetector(
        onTap: () => ref.read(editorProvider.notifier).selectObject(obj.id),
        onPanUpdate: enabled
            ? (details) {
                final newRx = ((x + details.delta.dx) / canvasWidth).clamp(
                  0.0,
                  1.0,
                );
                final newRy = ((y + details.delta.dy) / canvasHeight).clamp(
                  0.0,
                  1.0,
                );
                ref
                    .read(editorProvider.notifier)
                    .moveObject(obj.id, newRx, newRy);
              }
            : null,
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppColor.accent.withValues(alpha: 0.4)
                : enabled
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: isSelected
                  ? AppColor.accent
                  : enabled
                  ? Colors.white54
                  : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              _DragHandle._icon(obj.type),
              style: TextStyle(
                fontSize: 12,
                color: enabled ? null : Colors.white38,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _icon(MapObjectType type) => switch (type) {
    MapObjectType.peg => '⚫',
    MapObjectType.pegZone => '⬛',
    MapObjectType.circleBumper => '🟠',
    MapObjectType.triangle => '🔺',
    MapObjectType.plank => '📏',
    MapObjectType.rotatingObject => '🔄',
    MapObjectType.movingObject => '↔️',
    MapObjectType.bouncePad => '⬆️',
    MapObjectType.breakableWall => '🧱',
    MapObjectType.accelField => '🔴',
    MapObjectType.decelField => '🔵',
    MapObjectType.wormhole => '🔮',
    MapObjectType.mapLine => '〰️',
    MapObjectType.wall => '🧱',
    MapObjectType.flipper => '🏓',
    MapObjectType.elasticRope => '🪢',
  };
}

// ─── 캔버스 페인터 ──────────────────────────────────────────────────

class _CanvasPainter extends CustomPainter {
  final MapData mapData;
  final String? selectedId;
  final List<List<double>> tempPoints;
  final PlacementStep step;
  final MapObjectType? previewType;
  final double? previewRx;
  final double? previewRy;

  _CanvasPainter({
    required this.mapData,
    this.selectedId,
    this.tempPoints = const [],
    this.step = PlacementStep.none,
    this.previewType,
    this.previewRx,
    this.previewRy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawGoal(canvas, size);

    for (final obj in mapData.objects) {
      _drawObject(canvas, size, obj);
    }

    if (tempPoints.isNotEmpty) {
      _drawTempPoints(canvas, size);
    }

    if (previewType != null && previewRx != null && previewRy != null) {
      _drawGhost(canvas, size);
    }
  }

  void _drawGhost(Canvas canvas, Size size) {
    final x = previewRx! * size.width;
    final y = previewRy! * size.height;

    canvas.drawCircle(
      Offset(x, y),
      20,
      Paint()..color = AppColor.accent.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      Offset(x, y),
      20,
      Paint()
        ..color = AppColor.accent.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final icon = _typeIcon(previewType!);
    final tp = TextPainter(
      text: TextSpan(text: icon, style: const TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));

    final coordTp = TextPainter(
      text: TextSpan(
        text:
            '(${previewRx!.toStringAsFixed(2)}, ${previewRy!.toStringAsFixed(2)})',
        style: TextStyle(
          color: AppColor.accent.withValues(alpha: 0.7),
          fontSize: 9,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    coordTp.paint(canvas, Offset(x - coordTp.width / 2, y + 24));
  }

  String _typeIcon(MapObjectType type) => _DragHandle._icon(type);

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.borderLight
      ..strokeWidth = 0.5;

    const gridCount = 20;
    for (int i = 0; i <= gridCount; i++) {
      final x = size.width * i / gridCount;
      final y = size.height * i / gridCount;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final centerPaint = Paint()
      ..color = AppColor.border
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      centerPaint,
    );

    // 외곽선 강조
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = AppColor.accent.withValues(alpha: 0.5)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );

    final cornerPaint = Paint()
      ..color = AppColor.accent.withValues(alpha: 0.7)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    const c = 20.0;
    canvas.drawLine(Offset.zero, const Offset(c, 0), cornerPaint);
    canvas.drawLine(Offset.zero, const Offset(0, c), cornerPaint);
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - c, 0),
      cornerPaint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, c), cornerPaint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(c, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - c),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - c, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - c),
      cornerPaint,
    );
    final String langCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final text = switch (langCode) {
      'ko' => '맵 범위',
      'ja' => 'マップ範囲',
      _ => 'Map area',
    };
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColor.accent.withValues(alpha: 0.4),
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, const Offset(6, 4));
  }

  void _drawGoal(Canvas canvas, Size size) {
    final goalW = size.width;
    final goalY = size.height - 25.0;

    canvas.drawRect(
      Rect.fromLTWH(0, goalY, goalW, size.height - goalY),
      Paint()..color = AppColor.success.withValues(alpha: 0.12),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, goalY, goalW, size.height - goalY),
      Paint()
        ..color = AppColor.success.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: '🏁 GOAL',
        style: TextStyle(
          color: AppColor.success.withValues(alpha: 0.6),
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((goalW - tp.width) / 2, goalY + 4));
  }

  void _drawObject(Canvas canvas, Size size, MapObject obj) {
    final x = obj.rx * size.width;
    final y = obj.ry * size.height;
    final s = obj.size * size.width;
    final isSelected = obj.id == selectedId;

    switch (obj.type) {
      case MapObjectType.peg:
        canvas.drawCircle(Offset(x, y), s, Paint()..color = AppColor.textMuted);

      case MapObjectType.circleBumper:
        canvas.drawCircle(
          Offset(x, y),
          s,
          Paint()..color = AppColor.warning.withValues(alpha: 0.3),
        );
        canvas.drawCircle(
          Offset(x, y),
          s,
          Paint()
            ..color = AppColor.warning
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );

      case MapObjectType.triangle:
        final ts = s;
        final path = Path()
          ..moveTo(x, y - ts)
          ..lineTo(x - ts, y + ts)
          ..lineTo(x + ts, y + ts)
          ..close();
        canvas.drawPath(
          path,
          Paint()..color = AppColor.accentSub.withValues(alpha: 0.2),
        );
        canvas.drawPath(
          path,
          Paint()
            ..color = AppColor.accentSub
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );

      case MapObjectType.plank:
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(obj.angle);
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: s, height: 4),
          Paint()..color = AppColor.danger.withValues(alpha: 0.7),
        );
        canvas.restore();

      case MapObjectType.rotatingObject:
        final p = Paint()..color = AppColor.accentSub;
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s, height: 4),
          p,
        );
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 4, height: s),
          p,
        );
        canvas.drawCircle(
          Offset(x, y),
          s * 0.4,
          Paint()
            ..color = AppColor.accentSub.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

      case MapObjectType.movingObject:
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s, height: 5),
          Paint()..color = const Color(0xFF29B6F6),
        );
        final range = obj.range * (obj.horizontal ? size.width : size.height);
        final ap = Paint()
          ..color = const Color(0xFF29B6F6).withValues(alpha: 0.3)
          ..strokeWidth = 1;
        if (obj.horizontal) {
          canvas.drawLine(Offset(x - range, y), Offset(x + range, y), ap);
        } else {
          canvas.drawLine(Offset(x, y - range), Offset(x, y + range), ap);
        }

      case MapObjectType.bouncePad:
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s, height: 6),
          Paint()..color = AppColor.danger,
        );

      case MapObjectType.breakableWall:
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s, height: 6),
          Paint()..color = AppColor.accentSub.withValues(alpha: 0.6),
        );
        final tp = TextPainter(
          text: TextSpan(
            text: '${obj.maxHits}',
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));

      case MapObjectType.accelField:
        canvas.drawCircle(
          Offset(x, y),
          obj.fieldRadius * size.width,
          Paint()..color = AppColor.danger.withValues(alpha: 0.08),
        );
        canvas.drawCircle(
          Offset(x, y),
          obj.fieldRadius * size.width,
          Paint()
            ..color = AppColor.danger.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

      case MapObjectType.decelField:
        canvas.drawCircle(
          Offset(x, y),
          obj.fieldRadius * size.width,
          Paint()..color = AppColor.accent.withValues(alpha: 0.08),
        );
        canvas.drawCircle(
          Offset(x, y),
          obj.fieldRadius * size.width,
          Paint()
            ..color = AppColor.accent.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

      case MapObjectType.flipper:
        canvas.save();
        canvas.translate(x, y);
        canvas.drawCircle(
          Offset.zero,
          3,
          Paint()..color = Colors.white.withValues(alpha: 0.4),
        );
        canvas.rotate(obj.isLeft ? 0.4 : -0.4);
        final fr = Rect.fromCenter(
          center: Offset(obj.isLeft ? s / 2 : -s / 2, 0),
          width: s,
          height: 4,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(fr, const Radius.circular(2)),
          Paint()..color = AppColor.danger.withValues(alpha: 0.6),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(fr, const Radius.circular(2)),
          Paint()
            ..color = AppColor.danger
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        canvas.restore();

      case MapObjectType.elasticRope:
        final ex = obj.exitRx * size.width;
        final ey = obj.exitRy * size.height;
        final ropeThickness = 0.12 * 3 * size.width / 20;
        final anchorRadius = 0.2 * size.width / 20;
        canvas.drawLine(
          Offset(x, y),
          Offset(ex, ey),
          Paint()
            ..color = const Color(0xFFFFA726).withValues(alpha: 0.7)
            ..strokeWidth = ropeThickness
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawCircle(
          Offset(x, y),
          anchorRadius,
          Paint()..color = const Color(0xFFFFA726),
        );
        canvas.drawCircle(
          Offset(ex, ey),
          anchorRadius,
          Paint()..color = const Color(0xFFFFA726),
        );

      case MapObjectType.wormhole:
        canvas.drawCircle(
          Offset(x, y),
          obj.fieldRadius * size.width,
          Paint()..color = const Color(0xFF9C27B0).withValues(alpha: 0.15),
        );
        canvas.drawCircle(
          Offset(x, y),
          obj.fieldRadius * size.width,
          Paint()
            ..color = const Color(0xFF9C27B0).withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
        final ex = obj.exitRx * size.width;
        final ey = obj.exitRy * size.height;
        canvas.drawCircle(
          Offset(ex, ey),
          obj.fieldRadius * size.width,
          Paint()..color = const Color(0xFF9C27B0).withValues(alpha: 0.08),
        );
        canvas.drawCircle(
          Offset(ex, ey),
          obj.fieldRadius * size.width,
          Paint()
            ..color = const Color(0xFF9C27B0).withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        canvas.drawLine(
          Offset(x, y),
          Offset(ex, ey),
          Paint()
            ..color = const Color(0xFF9C27B0).withValues(alpha: 0.2)
            ..strokeWidth = 1,
        );

      case MapObjectType.mapLine:
        if (obj.points.length >= 2) {
          final path = Path();
          path.moveTo(
            obj.points.first[0] * size.width,
            obj.points.first[1] * size.height,
          );
          for (final p in obj.points.skip(1)) {
            path.lineTo(p[0] * size.width, p[1] * size.height);
          }
          canvas.drawPath(
            path,
            Paint()
              ..color = AppColor.accent
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
          for (final p in obj.points) {
            canvas.drawCircle(
              Offset(p[0] * size.width, p[1] * size.height),
              3,
              Paint()..color = AppColor.accent,
            );
          }
        }

      case MapObjectType.pegZone:
        final endY = obj.endRy * size.height;
        canvas.drawRect(
          Rect.fromLTRB(0, y, size.width, endY),
          Paint()..color = Colors.white.withValues(alpha: 0.04),
        );
        canvas.drawRect(
          Rect.fromLTRB(0, y, size.width, endY),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

      case MapObjectType.wall:
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s, height: 3),
          Paint()..color = Colors.white.withValues(alpha: 0.4),
        );
    }

    if (isSelected &&
        obj.type != MapObjectType.mapLine &&
        obj.type != MapObjectType.pegZone) {
      canvas.drawCircle(
        Offset(x, y),
        18,
        Paint()
          ..color = AppColor.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  void _drawTempPoints(Canvas canvas, Size size) {
    if (tempPoints.isEmpty) return;
    final paint = Paint()
      ..color = AppColor.accentSub
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final dotPaint = Paint()..color = AppColor.accentSub;

    if (step == PlacementStep.mapLinePoints && tempPoints.length >= 2) {
      final path = Path();
      path.moveTo(
        tempPoints.first[0] * size.width,
        tempPoints.first[1] * size.height,
      );
      for (final p in tempPoints.skip(1)) {
        path.lineTo(p[0] * size.width, p[1] * size.height);
      }
      canvas.drawPath(path, paint);
    }

    for (final p in tempPoints) {
      canvas.drawCircle(
        Offset(p[0] * size.width, p[1] * size.height),
        5,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter old) => true;
}
