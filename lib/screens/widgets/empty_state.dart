part of '../home_screen.dart';

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.layout,
  });

  final ResponsiveLayout layout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 32,
          ),
          SizedBox(
            width: 128,
            height: 128,
            child: Image.asset(
              'assets/images/logo.png',
              cacheWidth: 128,
              gaplessPlayback: true,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.appTitle,
            style: TextStyle(
              color: AppColor.accent,
              fontSize: 32 * layout.fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.appSubtitle,
            style: TextStyle(
              color: AppColor.textPrimary,
              fontSize: 20 * layout.fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(
            height: 32 * layout.fontScale,
          ),
          Text(
            AppLocalizations.of(context)!.homeDesc01,
            style: TextStyle(
              color: AppColor.textSecondary,
              fontSize: 18 * layout.fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 12 * layout.fontScale,
          ),
          Text(
            AppLocalizations.of(context)!.homeDesc02,
            style: TextStyle(
              color: AppColor.textSecondary,
              fontSize: 16 * layout.fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
