import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/widgets/responsive_widget.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/screens/home_screen.dart';

class GameSelectScreen extends StatelessWidget {
  const GameSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        return Scaffold(
          backgroundColor: AppColor.bgPrimary,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const _SettingHeader(),
                  ControlPanel(
                    layout: layout,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingHeader extends StatelessWidget {
  const _SettingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: () {
              context.pop();
            },
          ),
          Text(
            AppLocalizations.of(context)!.mapSelect,
            style: const TextStyle(
              color: AppColor.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
