part of '../home_screen.dart';

class _HomeHeader extends ConsumerWidget with HooksMixin {
  const _HomeHeader({
    required this.layout,
  });

  final ResponsiveLayout layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // height: layout.headerHeight,
      color: const Color(0xFF13132A),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                cacheWidth: 36,
              ),
            ],
          ),
          Row(
            children: [
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () async {
              //     final result = await context.pushNamed<MapSelectModel>(
              //       RouterType.maps.routeName,
              //     );
              //     if (result != null) {
              //       ref.read(selectedMapProvider.notifier).select(result.map!);
              //       scrollToMapCard(context, ref, result.index);
              //     }
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.all(
              //       6,
              //     ),
              //     child: const Text(
              //       '🗺️',
              //       style: TextStyle(fontSize: 20),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 4,
              // ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.pushNamed<MapSelectModel>(
                    RouterType.settings.routeName,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(
                    6,
                  ),
                  child: const Text(
                    '⚙️',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
