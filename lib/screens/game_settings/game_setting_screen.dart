import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/common/widgets/bounce_button.dart';
import 'package:toruru/common/widgets/glass_card.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/mixins/reward_ad.dart';
import 'package:toruru/models/ball_skin.dart';
import 'package:toruru/screens/providers/settings_provider.dart';
import 'package:toruru/screens/providers/skin_unlock_provider.dart';

part 'skin_selector.dart';
part 'max_players.dart';

class GameSettingScreen extends ConsumerWidget {
  const GameSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColor.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColor.bgCard.withValues(alpha: 0.9),
                border: const Border(
                  bottom: BorderSide(color: AppColor.borderLight),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColor.textPrimary,
                      size: 22,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 설정 목록
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 물리
                  _SectionTitle(title: AppLocalizations.of(context)!.physics),
                  GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _SettingsSlider(
                          label: AppLocalizations.of(context)!.gravity,
                          value: settings.gravity,
                          min: 10,
                          max: 50,
                          icon: '🌍',
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .update(settings.copyWith(gravity: v)),
                        ),
                        _SettingsSlider(
                          isBallSize: true,
                          label: AppLocalizations.of(context)!.ballSize,
                          value: settings.ballSize * 100,
                          min: 0.01,
                          max: 0.05,
                          icon: '⚽',
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .update(
                                settings.copyWith(
                                  ballSize: v / 100,
                                ),
                              ),
                        ),
                        _SettingsSlider(
                          label: AppLocalizations.of(context)!.maxSpeed,
                          value: settings.maxSpeed,
                          min: 10,
                          max: 50,
                          icon: '💨',
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .update(settings.copyWith(maxSpeed: v)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 연출
                  _SectionTitle(title: AppLocalizations.of(context)!.effects),
                  GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _SettingsToggle(
                          label: AppLocalizations.of(context)!.trail,
                          icon: '✨',
                          value: settings.showTrail,
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .update(settings.copyWith(showTrail: v)),
                        ),
                        _SettingsToggle(
                          label: AppLocalizations.of(context)!.slowMotion,
                          icon: '🎬',
                          value: settings.slowMotion,
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .update(settings.copyWith(slowMotion: v)),
                        ),
                        _SettingsToggle(
                          label: AppLocalizations.of(context)!.countdown,
                          icon: '⏱️',
                          value: settings.countdown,
                          onChanged: (v) => ref
                              .read(settingsProvider.notifier)
                              .update(settings.copyWith(countdown: v)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const _MaxPlayers(),
                  const SizedBox(height: 16),

                  // 스킨
                  _SectionTitle(title: AppLocalizations.of(context)!.ballSkins),
                  _SkinSelector(
                    selectedSkin: settings.ballSkin,
                    onSelect: (skin) => ref
                        .read(settingsProvider.notifier)
                        .update(settings.copyWith(ballSkin: skin)),
                  ),

                  const SizedBox(height: 16),
                  BounceButton(
                    onTap: () {
                      ref.read(settingsProvider.notifier).reset();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: AppUI.neonOutline(
                        color: AppColor.danger,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.optionsBack,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 공통 위젯 ──────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColor.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsSlider extends StatelessWidget {
  const _SettingsSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.icon,
    required this.onChanged,
    this.isBallSize = false,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String icon;
  final ValueChanged<double> onChanged;
  final bool isBallSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                activeTrackColor: AppColor.accent,
                inactiveTrackColor: AppColor.border,
                thumbColor: AppColor.accent,
                overlayColor: AppColor.accent.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: value.clamp(
                  isBallSize ? min * 100 : min,
                  isBallSize ? max * 100 : max,
                ),
                min: isBallSize ? min * 100 : min,
                max: isBallSize ? max * 100 : max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toStringAsFixed(1),
              style: const TextStyle(color: AppColor.textMuted, fontSize: 11),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColor.accent,
            inactiveTrackColor: AppColor.border,
          ),
        ],
      ),
    );
  }
}
