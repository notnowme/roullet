part of 'editor_screen.dart';

class _ObjectPalette extends ConsumerStatefulWidget {
  const _ObjectPalette();

  @override
  ConsumerState<_ObjectPalette> createState() => _ObjectPaletteState();
}

class _ObjectPaletteState extends ConsumerState<_ObjectPalette> {
  // 팔레트에 표시할 오브젝트 그룹

  List<String> _getTabs(BuildContext context) => [
    AppLocalizations.of(context)!.objectDefault,
    AppLocalizations.of(context)!.objectSecond,
    AppLocalizations.of(context)!.objectSpecial,
  ];
  static const _groups = [
    // 기본
    [
      MapObjectType.peg,
      MapObjectType.pegZone,
      MapObjectType.plank,
      MapObjectType.wall,
      MapObjectType.mapLine,
    ],
    // 장애물
    [
      MapObjectType.circleBumper,
      MapObjectType.triangle,
      MapObjectType.rotatingObject,
      MapObjectType.movingObject,
      MapObjectType.breakableWall,
      MapObjectType.flipper,
    ],
    // 특수
    [
      MapObjectType.bouncePad,
      MapObjectType.accelField,
      MapObjectType.decelField,
      MapObjectType.wormhole,
      MapObjectType.elasticRope,
    ],
  ];
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final placingType = ref.watch(editorProvider.select((e) => e.placingType));
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgCard.withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(color: AppColor.borderLight),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 탭 바
          Row(
            children: [
              for (int i = 0; i < _getTabs(context).length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _tabIndex == i
                                ? AppColor.accent
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        _getTabs(context)[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _tabIndex == i
                              ? AppColor.textPrimary
                              : AppColor.textMuted,
                          fontSize: 16,
                          fontWeight: _tabIndex == i
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          // 아이템 목록
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              itemCount: _groups[_tabIndex].length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final type = _groups[_tabIndex][i];
                return _PaletteItem(
                  type: type,
                  isSelected: placingType == type,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteItem extends ConsumerWidget {
  const _PaletteItem({
    required this.type,
    required this.isSelected,
  });

  final MapObjectType type;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final notifier = ref.read(editorProvider.notifier);
        if (isSelected) {
          notifier.cancelPlacing();
        } else {
          notifier.startPlacing(type, context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: AppUI.neonToggle(
          isSelected: isSelected,
          activeColor: AppColor.accent,
          borderRadius: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_icon(type), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(
              _label(type, context),
              style: TextStyle(
                color: isSelected ? AppColor.textPrimary : AppColor.textMuted,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
