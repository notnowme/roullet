import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/enums.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/common/widgets/bounce_button.dart';
import 'package:toruru/common/widgets/dialog_alert.dart';
import 'package:toruru/common/widgets/glass_card.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/mixins/reward_ad.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/models/map_select_model.dart';
import 'package:toruru/models/map_storage.dart';
import 'package:toruru/screens/providers/rollit_provider.dart';
import 'package:toruru/screens/providers/settings_provider.dart';

class MapListScreen extends ConsumerStatefulWidget {
  const MapListScreen({super.key});

  @override
  ConsumerState<MapListScreen> createState() => _MapListScreenState();
}

class _MapListScreenState extends ConsumerState<MapListScreen> {
  List<MapData> _maps = [];

  @override
  void initState() {
    super.initState();
    _loadMaps();
  }

  void _loadMaps() {
    setState(() {
      _maps = MapStorage.loadAll();
    });
  }

  Future<void> _createNew() async {
    final counts = ref.read(settingsProvider.select((s) => s.customMapCounts));
    final currentCounts = MapStorage.loadAll().length;
    if (currentCounts == counts) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            title: ErrorType.warning.label(context),
            body: AppLocalizations.of(context)!.mapAdTitle(counts),
            cb1: () {
              context.pop();
            },
          );
        },
      );
      return;
    }
    final result = await context.pushNamed<MapData>('editor');
    if (result != null) {
      MapStorage.save(result);
      _loadMaps();
    }
  }

  Future<void> _editMap(MapData map) async {
    final result = await context.pushNamed<MapData>('editor', extra: map);
    if (result != null) {
      MapStorage.save(result);
      _loadMaps();
    }
  }

  void _deleteMap(MapData map) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.bgElevated,
        title: Text(
          AppLocalizations.of(context)!.mapDelete,
          style: const TextStyle(color: AppColor.textPrimary),
        ),
        content: Text(
          AppLocalizations.of(context)!.mapDeleteName(map.name),
          style: const TextStyle(color: AppColor.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColor.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              MapStorage.delete(map.id);
              Navigator.pop(ctx);
              _loadMaps();
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: AppColor.danger),
            ),
          ),
        ],
      ),
    );
  }

  void _playMap(MapData map, int index) =>
      context.pop(MapSelectModel(index: index, map: map));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _MapListHeader(
              onBack: () {
                ref.read(customMapProvider.notifier).update();
                context.pop();
              },
              onCreateNew: _createNew,
            ),
            Expanded(
              child: _maps.isEmpty
                  ? const _EmptyMapList()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _maps.length + 1,
                      itemBuilder: (_, i) {
                        if (i == _maps.length) {
                          return const _MaxCountMapAd();
                        }
                        return _MapListCard(
                          map: _maps[i],
                          onPlay: () => _playMap(_maps[i], i),
                          onEdit: () => _editMap(_maps[i]),
                          onDelete: () => _deleteMap(_maps[i]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// -- 광고 --

class _MaxCountMapAd extends ConsumerStatefulWidget {
  const _MaxCountMapAd();

  @override
  ConsumerState<_MaxCountMapAd> createState() => _MaxCountMapAdState();
}

class _MaxCountMapAdState extends ConsumerState<_MaxCountMapAd>
    with RewardedAdMixin {
  @override
  Widget build(BuildContext context) {
    final currentCustoMaxMapCount = ref.watch(
      settingsProvider.select((s) => s.customMapCounts),
    );
    final canWatched = currentCustoMaxMapCount < 10;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                // 이름 + 설명
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.mapAdTitle(currentCustoMaxMapCount),
                        style: const TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      if (canWatched) ...[
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.mapAdDesc,
                          style: const TextStyle(
                            color: AppColor.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                BounceButton(
                  onTap: () {
                    showRewardedAd(
                      onRewardEarned: (reward) {
                        // 시청 완료
                        final currentCustoMaxMapCount = ref.read(
                          settingsProvider.select((s) => s.customMapCounts),
                        );
                        final settings = ref.read(settingsProvider);
                        ref
                            .read(settingsProvider.notifier)
                            .update(
                              settings.copyWith(
                                customMapCounts: currentCustoMaxMapCount + 2,
                              ),
                            );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7B6CF6),
                          Color(0xFF9B8FFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.adReward,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 헤더 ───────────────────────────────────────────────────────────

class _MapListHeader extends StatelessWidget {
  const _MapListHeader({
    required this.onBack,
    required this.onCreateNew,
  });

  final VoidCallback onBack;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.bgCard.withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(color: AppColor.borderLight),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.textPrimary,
              size: 22,
            ),
            onPressed: onBack,
          ),
          Text(
            AppLocalizations.of(context)!.customMap,
            style: const TextStyle(
              color: AppColor.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onCreateNew,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: AppUI.accentButton(borderRadius: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.newMap,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 빈 상태 ────────────────────────────────────────────────────────

class _EmptyMapList extends StatelessWidget {
  const _EmptyMapList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🗺️', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.noMap,
            style: const TextStyle(color: AppColor.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.noMapDesc,
            style: const TextStyle(color: AppColor.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── 맵 카드 ────────────────────────────────────────────────────────

class _MapListCard extends StatelessWidget {
  const _MapListCard({
    required this.map,
    required this.onPlay,
    required this.onEdit,
    required this.onDelete,
  });

  final MapData map;
  final VoidCallback onPlay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final objectCount = map.objects.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 14,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPlay,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColor.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🗺️', style: TextStyle(fontSize: 18)),
                          Text(
                            '$objectCount',
                            style: const TextStyle(
                              color: AppColor.accent,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          map.name,
                          style: const TextStyle(
                            color: AppColor.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${AppLocalizations.of(context)!.mapObject} ${AppLocalizations.of(context)!.mapCount(objectCount)}',
                          style: const TextStyle(
                            color: AppColor.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: AppColor.accentSub,
                      size: 20,
                    ),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColor.danger,
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
