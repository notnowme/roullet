import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/common/widgets/responsive_widget.dart';

class NativeAdBanner extends StatelessWidget {
  const NativeAdBanner({
    super.key,
    required this.ad,
  });

  final NativeAd ad;
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, layout) {
        return Container(
          width: layout.leaderboardWidth,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: AppUI.glassCard(
            bgColor: AppColor.bgCard,
            borderRadius: 16,
            borderColor: AppColor.bgCard.withValues(alpha: 0.15),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            height: layout.nativeSmallBannerHeight,
            child: AdWidget(ad: ad),
          ),
        );
      },
    );
  }
}
