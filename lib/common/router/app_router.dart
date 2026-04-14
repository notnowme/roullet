import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/screens/editor/editor_screen.dart';
import 'package:toruru/screens/editor/map_list_screen.dart';
import 'package:toruru/screens/game_settings/game_setting_screen.dart';
import 'package:toruru/screens/game_select/game_select_screen.dart';
import 'package:toruru/screens/home_screen.dart';
import 'package:toruru/screens/settings/setting_screen.dart';
import 'package:toruru/screens/splash_screen.dart';

enum RouterType {
  spalsh('splash', '/splash'),
  home('home', '/'),
  maps('mapList', '/mapList'),
  settings('settings', '/settings'),
  gameSettings('gameSettings', '/game'),
  gameSelect('gameSelect', '/select'),
  editor('editor', '/editor')
  ;

  final String routeName;
  final String routePath;
  const RouterType(this.routeName, this.routePath);
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
  routes: [
    GoRoute(
      path: RouterType.spalsh.routePath,
      name: RouterType.spalsh.routeName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: SplashScreen(),
        );
      },
    ),
    GoRoute(
      path: RouterType.home.routePath,
      name: RouterType.home.routeName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: HomeScreen(),
        );
      },
    ),
    GoRoute(
      path: RouterType.maps.routePath,
      name: RouterType.maps.routeName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: MapListScreen(),
        );
      },
    ),
    GoRoute(
      path: RouterType.editor.routePath,
      name: RouterType.editor.routeName,
      pageBuilder: (context, state) {
        final map = state.extra as MapData?;
        return NoTransitionPage(
          child: EditorScreen(
            initialMap: map,
          ),
        );
      },
    ),
    GoRoute(
      path: RouterType.gameSelect.routePath,
      name: RouterType.gameSelect.routeName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: GameSelectScreen(),
        );
      },
    ),
    GoRoute(
      path: RouterType.settings.routePath,
      name: RouterType.settings.routeName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: SettingScreen(),
        );
      },
      routes: [
        GoRoute(
          path: RouterType.gameSettings.routePath,
          name: RouterType.gameSettings.routeName,
          builder: (context, state) {
            return const GameSettingScreen();
          },
          // pageBuilder: (context, state) {
          //   return const NoTransitionPage(
          //     child: GameSettingScreen(),
          //   );
          // },
        ),
      ],
    ),
  ],
);
