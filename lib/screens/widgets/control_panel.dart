part of '../home_screen.dart';

class ControlPanel extends ConsumerStatefulWidget {
  const ControlPanel({super.key, required this.layout});
  final ResponsiveLayout layout;

  @override
  ConsumerState<ControlPanel> createState() => ControlPanelState();
}

class ControlPanelState extends ConsumerState<ControlPanel> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: ref.read(namesInputProvider),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _startGame(bool canStart) async {
    if (!canStart) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            title: ErrorType.warning.label(context),
            body: AppLocalizations.of(context)!.error2minPlayers,
            cb1: () {
              context.pop();
            },
          );
        },
      );
      return;
    }
    final maxPlayers = ref.read(settingsProvider.select((s) => s.playerCounts));
    final options = ref.read(gameOptionProvider);
    final names = ref.read(parsedNamesProvider);
    if (names.length > 10) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            title: ErrorType.warning.label(context),
            body: AppLocalizations.of(context)!.playerAlert(maxPlayers),
            cb1: () {
              context.pop();
            },
          );
        },
      );
      return;
    }
    if (maxPlayers < names.length) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            title: ErrorType.warning.label(context),
            body:
                '${AppLocalizations.of(context)!.playerAlert(maxPlayers)}\n${AppLocalizations.of(context)!.playerAlertDesc}',
            cb1: () {
              context.pop();
            },
            cb2: () {
              context.pushNamed(RouterType.gameSettings.routeName);
              context.pop();
            },
          );
        },
      );
      return;
    }
    if (options.winnerNums >= names.length) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            cb1: () {
              context.pop();
            },
            title: ErrorType.warning.label(context),
            body: AppLocalizations.of(context)!.winnerCountError,
          );
        },
      );
      return;
    }
    if (options.condition == WinCondition.firstToNums &&
        names.length - 1 == options.winnerNums) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            cb1: () {
              context.pop();
            },
            title: ErrorType.warning.label(context),
            body: AppLocalizations.of(context)!.lastWarning,
          );
        },
      );
      return;
    }
    if (options.condition == WinCondition.lastToNums &&
        names.length - options.winnerNums == 1) {
      showDialog(
        context: context,
        builder: (ctx) {
          return DialogAlert(
            cb1: () {
              context.pop();
            },
            title: ErrorType.warning.label(context),
            body: AppLocalizations.of(context)!.firstWarning,
          );
        },
      );
      return;
    }
    final selectedMap = ref.read(selectedMapProvider);
    ref
        .read(gameOptionProvider.notifier)
        .setOptions(
          options.copyWith(names: names),
        );

    final skin = ref.read(settingsProvider).ballSkin;
    ref.read(ballIndicesProvider.notifier).generate(skin, names.length);
    final indices = ref.read(ballIndicesProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ParticipantPreview(indices: indices),
    );
    if (confirmed != true || !mounted) return;

    ref
        .read(rollitGameProvider.notifier)
        .start(
          ref.read(gameOptionProvider),
          selectedMap,
        );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> conditions = [
      {
        'label': '🥇 ${AppLocalizations.of(context)!.winCondition01}',
        'condition': WinCondition.first,
        'color': const Color(0xFFFFD700),
      },
      {
        'label': '🐢 ${AppLocalizations.of(context)!.winCondition02}',
        'condition': WinCondition.last,
        'color': AppColor.accentSub,
      },
      {
        'label': '🥇 ${AppLocalizations.of(context)!.winCondition03}',
        'condition': WinCondition.firstToNums,
        'color': const Color(0xFFFFD700),
      },
      {
        'label': '🐢 ${AppLocalizations.of(context)!.winCondition04}',
        'condition': WinCondition.lastToNums,
        'color': AppColor.accentSub,
      },
    ];

    final game = ref.watch(rollitGameProvider);
    final canStart = ref.watch(
      parsedNamesProvider.select((s) => s.length >= 2),
    );
    final layout = widget.layout;
    return Container(
      height: layout.height - (layout.headerHeight * layout.aspectRatio),
      color: AppColor.bgPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (game == null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 7,
              ),
              color: AppColor.bgElevated,
              child: _MapSelector(
                layout: layout,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  color: AppColor.bgElevated,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.condition,
                        style: TextStyle(
                          color: AppColor.textMuted,
                          fontSize: 14 * layout.fontScale,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: conditions.length,
                          itemBuilder: (context, index) {
                            final item = conditions[index];
                            return Row(
                              children: [
                                _ConditionButton(
                                  label: item['label'],
                                  condition: item['condition'],
                                  layout: layout,
                                  color: item['color'],
                                ),
                                const SizedBox(width: 8),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          _CountButton(
                            label: '-',
                            layout: layout,
                            color: AppColor.border,
                            isCount: true,
                          ),
                          const SizedBox(width: 14),
                          Consumer(
                            builder: (context, ref, child) {
                              final nums = ref.watch(
                                gameOptionProvider.select(
                                  (s) => s.winnerNums,
                                ),
                              );
                              return _CountButton(
                                label: AppLocalizations.of(
                                  context,
                                )!.winCondition03Desc(nums),
                                layout: layout,
                                color: AppColor.accent,
                              );
                            },
                          ),
                          const SizedBox(width: 14),
                          _CountButton(
                            label: '+',
                            layout: layout,
                            color: AppColor.border,
                            isCount: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),

                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14 * layout.fontScale,
                        ),
                        onChanged: (value) {
                          ref.read(namesInputProvider.notifier).update(value);
                        },
                        decoration: AppUI.inputDecoration(hintText: ''),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: GestureDetector(
                          onTap: () => _startGame(canStart),
                          child: Container(
                            decoration: AppUI.neonButton(
                              color: canStart
                                  ? AppColor.accent
                                  : AppColor.accent.withValues(alpha: 0.3),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.start,
                                style: TextStyle(
                                  fontSize: 16 * layout.fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
          if (MediaQuery.of(context).viewInsets.bottom > 0)
            const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _ConditionButton extends ConsumerWidget {
  const _ConditionButton({
    required this.layout,
    required this.label,
    required this.condition,
    this.color = AppColor.accent,
  });

  final String label;
  final WinCondition condition;
  final ResponsiveLayout layout;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(gameOptionProvider.select((s) => s.condition)) == condition;
    return GestureDetector(
      onTap: () {
        final model = ref.read(gameOptionProvider);
        ref
            .read(gameOptionProvider.notifier)
            .setOptions(
              model.copyWith(
                condition: condition,
                winnderNums: 0,
              ),
            );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14,
        ),
        decoration: AppUI.neonToggle(
          isSelected: isSelected,
          activeColor: color,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColor.textMuted,
            fontSize: 13 * layout.fontScale,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _CountButton extends ConsumerWidget {
  const _CountButton({
    required this.layout,
    required this.label,
    this.color = AppColor.accent,
    this.isCount = false,
  });

  final String label;
  final ResponsiveLayout layout;
  final Color color;
  final bool isCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCondition = ref.watch(
      gameOptionProvider.select((s) => s.condition),
    );
    final isSelected =
        (currentCondition == WinCondition.firstToNums) ||
        (currentCondition == WinCondition.lastToNums);
    return GestureDetector(
      onTap: () {
        if (!isSelected) return;
        final model = ref.read(gameOptionProvider);
        if (isCount) {
          final nums = ref.read(
            gameOptionProvider.select((s) => s.winnerNums),
          );
          if (label == '+') {
            ref
                .read(gameOptionProvider.notifier)
                .setOptions(model.copyWith(winnderNums: nums + 1));
          } else {
            ref
                .read(gameOptionProvider.notifier)
                .setOptions(model.copyWith(winnderNums: nums - 1));
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14,
        ),
        decoration: AppUI.neonToggle(
          isSelected: isSelected,
          activeColor: color,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColor.textMuted,
            fontSize: 13 * layout.fontScale,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
