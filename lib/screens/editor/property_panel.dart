part of 'editor_screen.dart';

class _PropertyPanel extends ConsumerWidget {
  const _PropertyPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obj = ref.watch(
      editorProvider.select((s) => s.selectedObject),
    );

    if (obj == null) return const SizedBox.shrink();

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더: 아이콘 + 이름 + 액션
              Row(
                children: [
                  Text(
                    _icon(obj.type),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _label(obj.type, context),
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  _ActionIcon(
                    icon: Icons.copy,
                    onTap: () =>
                        ref.read(editorProvider.notifier).duplicateSelected(),
                  ),
                  const SizedBox(width: 8),
                  _ActionIcon(
                    icon: Icons.delete,
                    color: AppColor.danger,
                    onTap: () =>
                        ref.read(editorProvider.notifier).deleteSelected(),
                  ),
                  const SizedBox(width: 8),
                  // 닫기 버튼
                  _ActionIcon(
                    icon: Icons.close,
                    onTap: () =>
                        ref.read(editorProvider.notifier).selectObject(null),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 속성 슬라이더
              ..._buildSliders(ref, obj, context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSliders(
    WidgetRef ref,
    MapObject obj,
    BuildContext context,
  ) {
    final sliders = <Widget>[];

    void update(MapObject updated) {
      ref.read(editorProvider.notifier).updateObject(obj.id, updated);
    }

    // 공통: 위치
    sliders.add(
      _PropSlider(
        label: 'X',
        value: obj.rx,
        min: 0,
        max: 1,
        onChanged: (v) => update(obj.copyWith(rx: v)),
      ),
    );
    sliders.add(
      _PropSlider(
        label: 'Y',
        value: obj.ry,
        min: 0,
        max: 1,
        onChanged: (v) => update(obj.copyWith(ry: v)),
      ),
    );

    // 타입별
    switch (obj.type) {
      case MapObjectType.peg:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.size,
            value: obj.size,
            min: 0.005,
            max: 0.05,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );

      case MapObjectType.circleBumper:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.pi,
            value: obj.size,
            min: 0.01,
            max: 0.1,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );

      case MapObjectType.triangle:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.size,
            value: obj.size,
            min: 0.02,
            max: 0.12,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );

      case MapObjectType.plank:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.meter,
            value: obj.size,
            min: 0.05,
            max: 0.8,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.angle,
            value: obj.angle,
            min: -1.5,
            max: 1.5,
            onChanged: (v) => update(obj.copyWith(angle: v)),
          ),
        );
      // if (obj.type == MapObjectType.conveyorBelt) {
      //   sliders.add(_PropSlider(
      //     label: '속도', value: obj.speed, min: -5, max: 5,
      //     onChanged: (v) => update(obj.copyWith(speed: v)),
      //   ));
      // }

      case MapObjectType.rotatingObject:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.meter,
            value: obj.size,
            min: 0.1,
            max: 0.5,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.speed,
            value: obj.speed,
            min: -2.5,
            max: 2.5,
            onChanged: (v) => update(obj.copyWith(speed: v)),
          ),
        );

      case MapObjectType.movingObject:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.meter,
            value: obj.size,
            min: 0.05,
            max: 0.4,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.speed,
            value: obj.speed,
            min: 0.01,
            max: 0.3,
            onChanged: (v) => update(obj.copyWith(speed: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.zone,
            value: obj.range,
            min: 0.05,
            max: 0.4,
            onChanged: (v) => update(obj.copyWith(range: v)),
          ),
        );

      case MapObjectType.bouncePad:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.width,
            value: obj.size,
            min: 0.05,
            max: 0.4,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.strength,
            value: obj.boostForce,
            min: 10,
            max: 80,
            onChanged: (v) => update(obj.copyWith(boostForce: v)),
          ),
        );

      case MapObjectType.breakableWall:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.width,
            value: obj.size,
            min: 0.2,
            max: 1.0,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.hp,
            value: obj.maxHits.toDouble(),
            min: 1,
            max: 10,
            onChanged: (v) => update(obj.copyWith(maxHits: v.round())),
          ),
        );

      case MapObjectType.accelField || MapObjectType.decelField:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.zone,
            value: obj.fieldRadius,
            min: 0.05,
            max: 0.3,
            onChanged: (v) => update(obj.copyWith(fieldRadius: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.ratio,
            value: obj.multiplier,
            min: obj.type == MapObjectType.accelField ? 1.1 : 0.1,
            max: obj.type == MapObjectType.accelField ? 3.0 : 0.9,
            onChanged: (v) => update(obj.copyWith(multiplier: v)),
          ),
        );

      // case MapObjectType.magnet:
      //   sliders.add(_PropSlider(
      //     label: '범위', value: obj.fieldRadius, min: 0.05, max: 0.3,
      //     onChanged: (v) => update(obj.copyWith(fieldRadius: v)),
      //   ));
      //   sliders.add(_PropSlider(
      //     label: '힘', value: obj.multiplier, min: -10, max: 10,
      //     onChanged: (v) => update(obj.copyWith(multiplier: v)),
      //   ));

      case MapObjectType.wormhole:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.zone,
            value: obj.fieldRadius,
            min: 0.03,
            max: 0.15,
            onChanged: (v) => update(obj.copyWith(fieldRadius: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: '${AppLocalizations.of(context)!.exit} X',
            value: obj.exitRx,
            min: 0,
            max: 1,
            onChanged: (v) => update(obj.copyWith(exitRx: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: '${AppLocalizations.of(context)!.exit} Y',
            value: obj.exitRy,
            min: 0,
            max: 1,
            onChanged: (v) => update(obj.copyWith(exitRy: v)),
          ),
        );

      case MapObjectType.pegZone:
        sliders.add(
          _PropSlider(
            label: '${AppLocalizations.of(context)!.endPoint} Y',
            value: obj.endRy,
            min: obj.ry,
            max: 1.0,
            onChanged: (v) => update(obj.copyWith(endRy: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.nums,
            value: obj.density,
            min: 0.5,
            max: 3.0,
            onChanged: (v) => update(obj.copyWith(density: v)),
          ),
        );

      case MapObjectType.flipper:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.meter,
            value: obj.size,
            min: 0.1,
            max: 0.5,
            onChanged: (v) => update(obj.copyWith(size: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.interval,
            value: obj.interval,
            min: 1.0,
            max: 5.0,
            onChanged: (v) => update(obj.copyWith(interval: v)),
          ),
        );
        sliders.add(
          _ToggleRow(
            label: AppLocalizations.of(context)!.where,
            value: obj.isLeft,
            trueLabel: AppLocalizations.of(context)!.isLeft,
            falseLabel: AppLocalizations.of(context)!.isRight,
            onChanged: (v) => update(obj.copyWith(isLeft: v)),
          ),
        );
      case MapObjectType.elasticRope:
        sliders.add(
          _PropSlider(
            label: AppLocalizations.of(context)!.restitution,
            value: obj.boostForce,
            min: 10,
            max: 50,
            onChanged: (v) => update(obj.copyWith(boostForce: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: '${AppLocalizations.of(context)!.endPoint} X',
            value: obj.exitRx,
            min: 0,
            max: 1,
            onChanged: (v) => update(obj.copyWith(exitRx: v)),
          ),
        );
        sliders.add(
          _PropSlider(
            label: '${AppLocalizations.of(context)!.endPoint} Y',
            value: obj.exitRy,
            min: 0,
            max: 1,
            onChanged: (v) => update(obj.copyWith(exitRy: v)),
          ),
        );

      case MapObjectType.mapLine:
        for (int i = 0; i < obj.points.length; i++) {
          sliders.add(
            _PropSlider(
              label: 'P${i + 1} X',
              value: obj.points[i][0],
              min: 0,
              max: 1,
              onChanged: (v) {
                final newPoints = [
                  for (int j = 0; j < obj.points.length; j++)
                    j == i
                        ? [v, obj.points[j][1]]
                        : List<double>.from(obj.points[j]),
                ];
                update(obj.copyWith(points: newPoints));
              },
            ),
          );
          sliders.add(
            _PropSlider(
              label: 'P${i + 1} Y',
              value: obj.points[i][1],
              min: 0,
              max: 1,
              onChanged: (v) {
                final newPoints = [
                  for (int j = 0; j < obj.points.length; j++)
                    j == i
                        ? [obj.points[j][0], v]
                        : List<double>.from(obj.points[j]),
                ];
                update(obj.copyWith(points: newPoints));
              },
            ),
          );
        }
        sliders.add(
          _MapLinePointActions(
            onAddPoint: () {
              final last = obj.points.last;
              final newPoints = [
                ...obj.points,
                [last[0] + 0.03, last[1]],
              ];
              update(obj.copyWith(points: newPoints));
            },
            onRemovePoint: obj.points.length > 2
                ? () {
                    final newPoints = List<List<double>>.from(obj.points)
                      ..removeLast();
                    update(obj.copyWith(points: newPoints));
                  }
                : null,
          ),
        );

      default:
        break;
    }

    return sliders;
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

  static String _label(MapObjectType type, BuildContext context) =>
      switch (type) {
        MapObjectType.peg => AppLocalizations.of(context)!.peg,
        MapObjectType.pegZone => AppLocalizations.of(context)!.pegZone,
        MapObjectType.circleBumper => AppLocalizations.of(context)!.bumper,
        MapObjectType.triangle => AppLocalizations.of(context)!.triangle,
        MapObjectType.plank => AppLocalizations.of(context)!.plank,
        MapObjectType.rotatingObject => AppLocalizations.of(context)!.rotating,
        MapObjectType.movingObject => AppLocalizations.of(
          context,
        )!.movableObject,
        MapObjectType.bouncePad => AppLocalizations.of(context)!.bounce,
        MapObjectType.breakableWall => AppLocalizations.of(
          context,
        )!.breakableObject,
        MapObjectType.accelField => AppLocalizations.of(context)!.accelObject,
        MapObjectType.decelField => AppLocalizations.of(context)!.decelObject,
        MapObjectType.wormhole => AppLocalizations.of(context)!.wormhole,
        MapObjectType.mapLine => AppLocalizations.of(context)!.wallLine,
        MapObjectType.wall => AppLocalizations.of(context)!.wall,
        MapObjectType.flipper => AppLocalizations.of(context)!.flipper,
        MapObjectType.elasticRope => AppLocalizations.of(context)!.rope,
      };
}

// ─── 슬라이더 ───────────────────────────────────────────────────────
class _PropSlider extends StatelessWidget {
  const _PropSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: const TextStyle(color: AppColor.textMuted, fontSize: 11),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                activeTrackColor: AppColor.accent,
                inactiveTrackColor: AppColor.border,
                thumbColor: AppColor.accent,
                overlayColor: AppColor.accent.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text(
              value.toStringAsFixed(2),
              style: const TextStyle(color: AppColor.textMuted, fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 액션 아이콘 ────────────────────────────────────────────────────
class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (color ?? AppColor.textMuted).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? AppColor.textMuted, size: 18),
      ),
    );
  }
}

// ─── 토글 행 ─────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.trueLabel,
    required this.falseLabel,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final String trueLabel;
  final String falseLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: const TextStyle(color: AppColor.textMuted, fontSize: 11),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _toggleButton(trueLabel, value, () => onChanged(true)),
                const SizedBox(width: 6),
                _toggleButton(falseLabel, !value, () => onChanged(false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: active
                ? AppColor.accent.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: active
                  ? AppColor.accent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? AppColor.accent : AppColor.textMuted,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── MapLine 점 추가/삭제 ────────────────────────────────────────
class _MapLinePointActions extends StatelessWidget {
  const _MapLinePointActions({
    required this.onAddPoint,
    this.onRemovePoint,
  });

  final VoidCallback onAddPoint;
  final VoidCallback? onRemovePoint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            child: Row(
              children: [
                _actionButton(
                  AppLocalizations.of(context)!.addPoint,
                  AppColor.accent,
                  onAddPoint,
                ),
                if (onRemovePoint != null) ...[
                  const SizedBox(width: 6),
                  _actionButton(
                    AppLocalizations.of(context)!.delPoint,
                    AppColor.danger,
                    onRemovePoint!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
