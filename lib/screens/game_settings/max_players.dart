part of 'game_setting_screen.dart';

class _MaxPlayers extends ConsumerStatefulWidget {
  const _MaxPlayers();

  @override
  ConsumerState<_MaxPlayers> createState() => __MaxPlayersState();
}

class __MaxPlayersState extends ConsumerState<_MaxPlayers>
    with RewardedAdMixin {
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(
      settingsProvider.select(
        (s) => s.playerCounts,
      ),
    );
    final isWatched = players == 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title: AppLocalizations.of(context)!.player),
        GlassCard(
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
                            )!.playerAdTitle(players),
                            style: const TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          if (!isWatched) ...[
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context)!.playerAdDesc,
                              style: const TextStyle(
                                color: AppColor.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!isWatched)
                      BounceButton(
                        onTap: () {
                          showRewardedAd(
                            onRewardEarned: (reward) {
                              // 시청 완료
                              final settings = ref.read(settingsProvider);
                              ref
                                  .read(settingsProvider.notifier)
                                  .update(
                                    settings.copyWith(playerCounts: 10),
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
        ),
      ],
    );
  }
}
