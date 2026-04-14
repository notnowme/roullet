import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  /// 배너 광고
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9214589741';
    } else if (Platform.isIOS) {
      return '';
    }
    return null;
  }

  /// 네이티브 광고
  static String? get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9272111666743424/6896938269';
    } else if (Platform.isIOS) {
      return '';
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad LOADED'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad Fail: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad OPEND'),
    onAdClosed: (ad) => debugPrint('Ad CLOSED'),
  );

  static final NativeAdListener nativeAdListener = NativeAdListener(
    onAdLoaded: (ad) => debugPrint('Ad LOADED'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad Fail: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad OPEND'),
    onAdClosed: (ad) => debugPrint('Ad CLOSED'),
  );
}
