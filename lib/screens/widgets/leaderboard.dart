part of '../home_screen.dart';

class _LeaderBoardWidget extends StatelessWidget {
  const _LeaderBoardWidget({
    required this.rankingNotifier,
    required this.atTop,
    required this.onTogglePosition,
    this.fontScale = 1.0,
  });

  final ValueNotifier<List<String>> rankingNotifier;
  final bool atTop;
  final VoidCallback onTogglePosition;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: rankingNotifier,
      builder: (context, ranking, _) {
        return Container(
          color: Colors.black.withValues(alpha: 0.75),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '🏁 ${AppLocalizations.of(context)!.ranking}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * fontScale,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTogglePosition,
                    child: Icon(
                      atTop ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ...ranking.asMap().entries.map((entry) {
                final i = entry.key;
                final name = entry.value;
                final medals = ['🥇', '🥈', '🥉'];
                final medal = i < 3
                    ? medals[i]
                    : '${i + 1}${AppLocalizations.of(context)!.rank}';

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, -0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Padding(
                    key: ValueKey(name),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text(
                            medal,
                            style: TextStyle(fontSize: 14 * fontScale),
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: i == 0
                                ? const Color(0xFFFFD700)
                                : Colors.white70,
                            fontSize: 14 * fontScale,
                            fontWeight: i == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
