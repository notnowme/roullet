import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/utils/mobile_ads.dart';

mixin NativeBannerAdMixin<T extends StatefulWidget> on State<T> {
  NativeAd? nativeAd;
  bool isNatvieAdLoaded = false;
  @override
  void initState() {
    super.initState();
    _createAd();
  }

  void _createAd() {
    nativeAd = NativeAd(
      adUnitId: AdMobService.nativeAdUnitId!,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('Native Ad LOADED');
          setState(() {
            isNatvieAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Native Ad Fail: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: AppColor.bgCard,
        cornerRadius: 16,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColor.accent,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textPrimary,
          backgroundColor: AppColor.bgCard,
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textSecondary,
          backgroundColor: AppColor.bgCard,
          style: NativeTemplateFontStyle.normal,
          size: 14,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textMuted,
          backgroundColor: AppColor.bgCard,
          style: NativeTemplateFontStyle.normal,
          size: 12,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    nativeAd?.dispose();
    super.dispose();
  }
}
