import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/common/router/app_router.dart';
import 'package:toruru/common/widgets/bounce_button.dart';
import 'package:toruru/common/widgets/dialog_alert.dart';
import 'package:toruru/common/widgets/native_ad_banner.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/mixins/native_ad.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with NativeBannerAdMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _SettingHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    AppLocalizations.of(context)!.gameSettings,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  BounceButton(
                    onTap: () {
                      context.pushNamed(RouterType.gameSettings.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: AppUI.neonOutline(
                        color: AppColor.accent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.physicsSettings,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    AppLocalizations.of(context)!.policy,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  BounceButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return DialogAlert(
                            title: AppLocalizations.of(context)!.policyAlert,
                            body: '',
                            cb1: () {
                              context.pop();
                            },
                            cb2: () async {
                              final Uri url = Uri.parse(
                                'https://inexpensive-marscapone-c0a.notion.site/Roll-it-roullet-3306535394598007828bd113a3bb9d06',
                              );
                              try {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );

                                context.pop();
                              } catch (e) {
                                print(e);
                              }
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: AppUI.neonOutline(
                        color: AppColor.accent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.servicePolicy,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: const TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    '1.0.0',
                    style: TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (isNatvieAdLoaded) NativeAdBanner(ad: nativeAd!),
                ],
              ),
            ),
          ],
        ),
      ),
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
            AppLocalizations.of(context)!.settings,
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
