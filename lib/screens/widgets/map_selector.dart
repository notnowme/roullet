part of '../home_screen.dart';

String _mapIcon(String id) => switch (id) {
  'hellFunnel' => '🔥',
  'pinballChaos' => '🎰',
  'lavaCave' => '🌋',
  _ => '🗺️',
};

void _openMapList(BuildContext context, WidgetRef ref) async {
  final result = await context.pushNamed<MapSelectModel>('mapList');
  if (result != null) {
    ref.read(selectedMapProvider.notifier).select(result.map!);
    // scrollToMapCard(context, ref, result.index);
  }
}

class _MapSelector extends ConsumerWidget with HooksMixin {
  const _MapSelector({
    required this.layout,
  });

  final ResponsiveLayout layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMap = ref.watch(selectedMapProvider);
    final customMaps = ref.watch(customMapProvider);
    final scrollController = ref.watch(homeMapListScrollProvider);
    return Column(
      children: [
        _MapList(
          title: AppLocalizations.of(context)!.defaultMap,
          layout: layout,
          mapDatas: defaultMaps,
          selectedMap: selectedMap,
        ),
        _MapList(
          title: AppLocalizations.of(context)!.customMap,
          layout: layout,
          mapDatas: customMaps,
          selectedMap: selectedMap,
          scrollController: scrollController,
          isCustom: true,
        ),
      ],
    );
  }
}

// ----- 맵 리스트 --

class _MapList extends ConsumerWidget {
  const _MapList({
    required this.title,
    required this.layout,
    required this.mapDatas,
    required this.selectedMap,
    this.scrollController,
    this.isCustom = false,
  });

  final String title;
  final ScrollController? scrollController;
  final ResponsiveLayout layout;
  final List<MapData> mapDatas;
  final MapData selectedMap;
  final bool isCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기본 맵
        Text(
          title,
          style: TextStyle(
            color: AppColor.textMuted,
            fontSize: 14 * layout.fontScale,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 120,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0.0, 0.03, 0.92, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              itemCount: mapDatas.length + 1,
              itemBuilder: (_, i) {
                if (i == mapDatas.length) {
                  return isCustom
                      ? _NewMapCard(
                          onTap: () => _openMapList(context, ref),
                        )
                      : const SizedBox.shrink();
                }
                final map = mapDatas[i];
                return Container(
                  key: ValueKey<int>(i),
                  child: _MapCard(
                    map: map,
                    isSelected: selectedMap.id == map.id,
                    icon: isCustom ? '🗺️' : _mapIcon(map.id),
                    onTap: () {
                      ref.read(selectedMapProvider.notifier).select(map);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 맵 카드 ────────────────────────────────────────────────────────
class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.map,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  final MapData map;
  final bool isSelected;
  final String icon;
  final VoidCallback onTap;

  Color _neonColor(String mapId) => switch (mapId) {
    'hellFunnel' => const Color(0xFFFF6B6B), // 빨강
    'pinballChaos' => const Color(0xFF7B6CF6), // 보라
    'lavaCave' => const Color(0xFFFFA726), // 주황
    _ => const Color(0xFF4ECDC4), // 민트 (커스텀 맵)
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 120,
        margin: EdgeInsets.only(
          right: 10,
          top: isSelected ? 0 : 8, // 선택되면 위로 올라옴
          bottom: isSelected ? 8 : 0,
        ),
        // transform: isSelected
        //     ? (Matrix4.identity()..scaleByDouble(1.05, 1.05, 1.0, 1.0)) // 살짝 확대
        //     : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.08),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.04),
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? _neonColor(map.id).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  // 네온 글로우 (바깥쪽)
                  BoxShadow(
                    color: _neonColor(map.id).withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  // 네온 글로우 (안쪽 가까이)
                  BoxShadow(
                    color: _neonColor(map.id).withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                  // 깊이감
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Column(
              children: [
                // 미니 맵 미리보기
                Expanded(
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: _MiniMapPainter(map: map),
                        size: Size.infinite,
                      ),
                      // 상단 그라데이션 오버레이 (깊이감)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.06),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 하단 정보
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              map.name,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColor.textPrimary
                                    : AppColor.textSecondary,
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 새 맵 카드 ─────────────────────────────────────────────────────
class _NewMapCard extends StatelessWidget {
  const _NewMapCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 10, top: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_rounded,
                  color: AppColor.textMuted,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.editor,
                  style: const TextStyle(
                    color: AppColor.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 미니 맵 페인터 ─────────────────────────────────────────────────
class _MiniMapPainter extends CustomPainter {
  final MapData map;

  _MiniMapPainter({required this.map});

  // 미리보기에 보여줄 y 범위 (0~0.4 = 상위 40%)
  static const double _previewStart = 0.0;
  static const double _previewEnd = 0.4;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColor.bgPrimary,
    );

    final yRange = _previewEnd - _previewStart;

    for (final obj in map.objects) {
      // y가 미리보기 범위 밖이면 스킵
      if (obj.ry < _previewStart || obj.ry > _previewEnd) {
        if (obj.type != MapObjectType.mapLine &&
            obj.type != MapObjectType.pegZone) {
          continue;
        }
      }

      final x = obj.rx * size.width;
      final y = ((obj.ry - _previewStart) / yRange) * size.height;

      switch (obj.type) {
        case MapObjectType.peg:
          canvas.drawCircle(
            Offset(x, y),
            1.5,
            Paint()..color = AppColor.textMuted.withValues(alpha: 0.5),
          );

        case MapObjectType.pegZone:
          final startY = ((obj.ry - _previewStart) / yRange) * size.height;
          final endY = ((obj.endRy - _previewStart) / yRange) * size.height;
          if (endY < 0 || startY > size.height) continue;
          canvas.drawRect(
            Rect.fromLTRB(
              0,
              startY.clamp(0, size.height),
              size.width,
              endY.clamp(0, size.height),
            ),
            Paint()..color = Colors.white.withValues(alpha: 0.05),
          );

        case MapObjectType.circleBumper:
          canvas.drawCircle(
            Offset(x, y),
            (obj.size * size.width * 0.5).clamp(1.5, 6),
            Paint()..color = AppColor.warning.withValues(alpha: 0.4),
          );

        case MapObjectType.triangle:
          canvas.drawCircle(
            Offset(x, y),
            2,
            Paint()..color = AppColor.accentSub.withValues(alpha: 0.4),
          );

        case MapObjectType.plank:
          canvas.save();
          canvas.translate(x, y);
          canvas.rotate(obj.angle);
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: obj.size * size.width,
              height: 2,
            ),
            Paint()..color = AppColor.danger.withValues(alpha: 0.5),
          );
          canvas.restore();

        case MapObjectType.rotatingObject:
          final s = obj.size * size.width * 0.4;
          final paint = Paint()
            ..color = AppColor.accentSub.withValues(alpha: 0.5)
            ..strokeWidth = 1.5;
          canvas.drawLine(Offset(x - s, y), Offset(x + s, y), paint);
          canvas.drawLine(Offset(x, y - s), Offset(x, y + s), paint);

        case MapObjectType.movingObject:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, y),
              width: obj.size * size.width,
              height: 2,
            ),
            Paint()..color = const Color(0xFF29B6F6).withValues(alpha: 0.5),
          );

        case MapObjectType.bouncePad:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, y),
              width: obj.size * size.width,
              height: 2,
            ),
            Paint()..color = AppColor.danger.withValues(alpha: 0.6),
          );

        case MapObjectType.breakableWall:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, y),
              width: obj.size * size.width,
              height: 2,
            ),
            Paint()..color = AppColor.accentSub.withValues(alpha: 0.4),
          );

        case MapObjectType.mapLine:
          if (obj.points.length >= 2) {
            final path = Path();
            final first = obj.points.first;
            path.moveTo(
              first[0] * size.width,
              ((first[1] - _previewStart) / yRange) * size.height,
            );
            for (final p in obj.points.skip(1)) {
              path.lineTo(
                p[0] * size.width,
                ((p[1] - _previewStart) / yRange) * size.height,
              );
            }
            canvas.drawPath(
              path,
              Paint()
                ..color = AppColor.accent.withValues(alpha: 0.4)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1,
            );
          }

        case MapObjectType.accelField:
          canvas.drawCircle(
            Offset(x, y),
            obj.fieldRadius * size.width,
            Paint()..color = AppColor.danger.withValues(alpha: 0.1),
          );

        case MapObjectType.decelField:
          canvas.drawCircle(
            Offset(x, y),
            obj.fieldRadius * size.width,
            Paint()..color = AppColor.accent.withValues(alpha: 0.1),
          );

        // case MapObjectType.magnet:
        //   canvas.drawCircle(
        //     Offset(x, y),
        //     obj.fieldRadius * size.width,
        //     Paint()..color = AppColor.danger.withValues(alpha: 0.1),
        //   );

        case MapObjectType.wormhole:
          canvas.drawCircle(
            Offset(x, y),
            3,
            Paint()..color = const Color(0xFF9C27B0).withValues(alpha: 0.5),
          );
          final ex = obj.exitRx * size.width;
          final ey = ((obj.exitRy - _previewStart) / yRange) * size.height;
          canvas.drawCircle(
            Offset(ex, ey),
            3,
            Paint()..color = const Color(0xFF9C27B0).withValues(alpha: 0.3),
          );

        case MapObjectType.wall:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, y),
              width: obj.size * size.width,
              height: 1.5,
            ),
            Paint()..color = Colors.white.withValues(alpha: 0.3),
          );

        case MapObjectType.flipper:
          canvas.save();
          canvas.translate(x, y);
          final miniAngle = obj.isLeft ? 0.4 : -0.4;
          canvas.rotate(miniAngle);
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(
                obj.isLeft
                    ? obj.size * size.width * 0.5
                    : -obj.size * size.width * 0.5,
                0,
              ),
              width: obj.size * size.width,
              height: 2,
            ),
            Paint()..color = AppColor.danger.withValues(alpha: 0.5),
          );
          canvas.restore();

        case MapObjectType.elasticRope:
          final ey = ((obj.exitRy - _previewStart) / yRange) * size.height;
          if (y > size.height && ey > size.height) continue;
          if (y < 0 && ey < 0) continue;
          final ex = obj.exitRx * size.width;
          canvas.drawLine(
            Offset(x, y),
            Offset(ex, ey),
            Paint()
              ..color = const Color(0xFFFFA726).withValues(alpha: 0.5)
              ..strokeWidth = 1.5
              ..strokeCap = StrokeCap.round,
          );
          canvas.drawCircle(
            Offset(x, y),
            2,
            Paint()..color = const Color(0xFFFFA726).withValues(alpha: 0.6),
          );
          canvas.drawCircle(
            Offset(ex, ey),
            2,
            Paint()..color = const Color(0xFFFFA726).withValues(alpha: 0.6),
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MiniMapPainter old) => old.map != map;
}
