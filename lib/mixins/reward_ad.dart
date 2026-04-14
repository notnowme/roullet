import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin RewardedAdMixin<T extends StatefulWidget> on State<T> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  // 광고 단위 ID
  final String _adUnitId = 'ca-app-pub-9272111666743424/4689472127';

  @override
  void initState() {
    super.initState();
    loadRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  // 1. 광고 미리 로드
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  // 2. 광고 실행 및 보상 처리
  void showRewardedAd({required Function(RewardItem) onRewardEarned}) {
    if (!_isAdLoaded || _rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('광고가 아직 준비되지 않았습니다.')),
      );
      loadRewardedAd(); // 준비 안 됐으면 다시 로드 시도
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd(); // 다음을 위해 다시 로드
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // 보상 지급 콜백 실행
        onRewardEarned(reward);
      },
    );

    _isAdLoaded = false;
  }
}
