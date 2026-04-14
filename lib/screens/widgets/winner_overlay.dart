part of '../home_screen.dart';

class _WinnerOverlay extends ConsumerStatefulWidget {
  const _WinnerOverlay({required this.layout});
  final ResponsiveLayout layout;

  @override
  ConsumerState<_WinnerOverlay> createState() => _WinnerOverlayState();
}

class _WinnerOverlayState extends ConsumerState<_WinnerOverlay>
    with TickerProviderStateMixin, PopupAnimation {
  @override
  void initState() {
    super.initState();
    initPopupAnimation();
    playPopupAnimation();
  }

  @override
  void dispose() {
    disposePopupAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final condition = ref.watch(gameOptionProvider.select((s) => s.condition));
    final winner = ref.watch(winnerProvider);
    final layout = widget.layout;

    return AnimatedBuilder(
      animation: bgController,
      builder: (context, _) {
        return Container(
          color: Colors.black.withValues(alpha: 0.72 * bgFade.value),
          child: Center(
            child: SlideTransition(
              position: cardSlide,
              child: ScaleTransition(
                scale: cardScale,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  constraints: BoxConstraints(
                    maxWidth: layout.controlPanelMaxWidth,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.bgCard.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColor.accent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.accent.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 36,
                    ),
                    child: FadeTransition(
                      opacity: contentFade,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ScaleTransition(
                            scale: emojiPop,
                            child: Text(
                              condition == WinCondition.last ? '🐢' : '🏆',
                              style: TextStyle(fontSize: 52 * layout.fontScale),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppLocalizations.of(context)!.victory,
                            style: TextStyle(
                              color: AppColor.accent,
                              fontSize: 16 * layout.fontScale,
                              // letterSpacing: 4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            winner ?? '',
                            style: TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 24 * layout.fontScale,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: GestureDetector(
                              onTap: () => resetAll(ref),
                              child: Container(
                                decoration: AppUI.neonButton(
                                  color: AppColor.accent,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.gameRest,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16 * layout.fontScale,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
