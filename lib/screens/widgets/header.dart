part of '../home_screen.dart';

class _Header extends StatelessWidget {
  final ResponsiveLayout layout;

  const _Header({
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: layout.headerHeight,
      color: const Color(0xFF13132A),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Row(
        children: [
          // Text(
          //   '또르르 - Roll it roullet!',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16 * layout.fontScale,
          //   ),
          // ),
          // const SizedBox(width: 8),
          // 카메라 모드 버튼들
          ...[
            (
              '⬇️',
              CameraMode.followLast,
              AppLocalizations.of(context)!.cameraFirst,
            ),
            (
              '⬆️',
              CameraMode.followFirst,
              AppLocalizations.of(context)!.cameraLast,
            ),
            // ('⚔️', CameraMode.followBattle, '격전지'),
            ('🗺️', CameraMode.editor, AppLocalizations.of(context)!.cameraAll),
          ].map(
            (e) => _CamButton(
              icon: e.$1,
              mode: e.$2,
              label: e.$3,
              layout: layout,
            ),
          ),
          const Spacer(),
          _ShowLeaderboardToggle(layout: layout),
          const SizedBox(width: 6),
          Consumer(
            builder: (context, ref, child) {
              return TextButton(
                onPressed: () => resetAll(ref),
                child: Text(
                  AppLocalizations.of(context)!.gameRest,
                  style: TextStyle(
                    color: AppColor.danger,
                    fontSize: 14 * layout.fontScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CamButton extends ConsumerWidget {
  const _CamButton({
    required this.icon,
    required this.mode,
    required this.label,
    required this.layout,
  });

  final String icon;
  final CameraMode mode;
  final String label;
  final ResponsiveLayout layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraMode = ref.watch(cameraModeProvider);
    final isSelected = cameraMode == mode;
    return GestureDetector(
      onTap: () {
        ref.read(cameraModeProvider.notifier).setMode(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(left: 8),
        padding: layout.buttonPadding,
        decoration: AppUI.neonToggle(
          isSelected: isSelected,
          activeColor: AppColor.accent,
          borderRadius: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: 12 * layout.fontScale)),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColor.textMuted,
                fontSize: 14 * layout.fontScale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowLeaderboardToggle extends ConsumerWidget {
  const _ShowLeaderboardToggle({
    required this.layout,
  });

  final ResponsiveLayout layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShow = ref.watch(showLeaderboardProvider);
    return GestureDetector(
      onTap: () {
        ref.read(showLeaderboardProvider.notifier).toggle();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: layout.buttonPadding,
        decoration: AppUI.neonToggle(
          isSelected: isShow,
          activeColor: AppColor.accentSub,
          borderRadius: 8,
        ),
        child: Text(
          '🏁',
          style: TextStyle(
            fontSize: 20 * layout.fontScale,
            color: isShow ? AppColor.accentSub : AppColor.textMuted,
          ),
        ),
      ),
    );
  }
}
