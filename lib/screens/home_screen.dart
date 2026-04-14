import 'dart:io';
import 'dart:ui' as ui;

import 'package:flame/game.dart' hide Matrix4;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/enums.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/common/router/app_router.dart';
import 'package:toruru/common/widgets/bounce_button.dart';
import 'package:toruru/common/widgets/dialog_alert.dart';
import 'package:toruru/common/widgets/native_ad_banner.dart';
import 'package:toruru/common/widgets/responsive_widget.dart';
import 'package:toruru/data/default_maps.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/mixins/animations.dart';
import 'package:toruru/mixins/hooks.dart';
import 'package:toruru/mixins/native_ad.dart';
import 'package:toruru/models/ball_skin.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/models/map_select_model.dart';
import 'package:toruru/screens/providers/rollit_provider.dart';
import 'package:toruru/screens/providers/settings_provider.dart';
import 'package:toruru/screens/rollit_game.dart';

part 'widgets/header.dart';
part 'widgets/game_area.dart';
part 'widgets/winner_overlay.dart';
part 'widgets/empty_state.dart';
part 'widgets/control_panel.dart';
part 'widgets/leaderboard.dart';
part 'widgets/map_selector.dart';
part 'widgets/track_overlay.dart';
part 'widgets/game_time_overlay.dart';
part 'widgets/participant_preview.dart';
part 'widgets/home_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final game = ref.watch(rollitGameProvider);
    ref.watch(settingsProvider);
    ref.watch(ballIndicesProvider);
    ref.listen(cameraModeProvider, (prev, next) {
      if (prev != next) {
        game?.setCameraMode(next);
      }
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showDialog(
          context: context,
          builder: (ctx) {
            return DialogAlert(
              title: ErrorType.exit.label(context),
              body: '',
              cb1: () {
                context.pop();
              },
              cb2: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                }
              },
            );
          },
        );
      },
      child: ResponsiveBuilder(
        builder: (context, layout) {
          return Scaffold(
            // resizeToAvoidBottomInset: false,
            backgroundColor: AppColor.bgPrimary,
            body: SafeArea(
              child: Column(
                children: [
                  if (game == null) _HomeHeader(layout: layout),
                  if (game != null) _Header(layout: layout),
                  Expanded(
                    child: game != null
                        ? _GameArea(layout: layout)
                        : _EmptyState(layout: layout),
                  ),
                  if (game == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: BounceButton(
                        onTap: () {
                          context.pushNamed(RouterType.gameSelect.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: AppUI.accentButton(),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.start,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
