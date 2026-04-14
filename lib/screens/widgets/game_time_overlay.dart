part of '../home_screen.dart';

class _GameTime extends ConsumerWidget {
  const _GameTime();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(gameTimeProvider).value ?? 0.0;
    return Positioned(
      top: 8,
      right: 10,
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: time),
        duration: const Duration(seconds: 1),
        builder: (context, value, child) {
          return Text(
            value.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }
}
