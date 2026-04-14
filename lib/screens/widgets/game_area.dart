part of '../home_screen.dart';

class _GameArea extends ConsumerStatefulWidget {
  const _GameArea({
    required this.layout,
  });

  final ResponsiveLayout layout;

  @override
  ConsumerState<_GameArea> createState() => _GameAreaState();
}

class _GameAreaState extends ConsumerState<_GameArea> with NativeBannerAdMixin {
  @override
  Widget build(BuildContext context) {
    final game = ref.watch(rollitGameProvider);
    final isShow = ref.watch(showLeaderboardProvider);
    final winner = ref.watch(winnerProvider);
    final cameraMode = ref.watch(cameraModeProvider);
    final leaderboardAtTop = ref.watch(leaderboardAtTopProvider);
    ref.watch(settingsProvider);
    if (widget.layout.showLeaderboardSide && isShow) {
      return Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                GameWidget(game: game!),
                _TrackingOverlay(game: game, cameraMode: cameraMode),
                const _GameTime(),
                if (winner != null) _WinnerOverlay(layout: widget.layout),
                if (winner != null && isNatvieAdLoaded)
                  Positioned(
                    left: 0,
                    bottom: 20,
                    child: NativeAdBanner(ad: nativeAd!),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: widget.layout.leaderboardWidth,
            child: _LeaderBoardWidget(
              rankingNotifier: game.rankingNotifier,
              atTop: true,
              onTogglePosition: () {},
              fontScale: widget.layout.fontScale,
            ),
          ),
        ],
      );
    }
    return Stack(
      children: [
        GameWidget(game: game!),
        _TrackingOverlay(game: game, cameraMode: cameraMode),

        const _GameTime(),
        if (isShow)
          Positioned(
            top: leaderboardAtTop ? 0 : null,
            bottom: leaderboardAtTop ? null : 0,
            left: 0,
            right: 0,
            child: _LeaderBoardWidget(
              rankingNotifier: game.rankingNotifier,
              atTop: leaderboardAtTop,
              onTogglePosition: () =>
                  ref.read(leaderboardAtTopProvider.notifier).toggle(),
              fontScale: widget.layout.fontScale,
            ),
          ),
        if (winner != null) _WinnerOverlay(layout: widget.layout),
        if (winner != null && isNatvieAdLoaded)
          Positioned(
            left: 0,
            bottom: 20,
            child: NativeAdBanner(ad: nativeAd!),
          ),
      ],
    );
  }
}
