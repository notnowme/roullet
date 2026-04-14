import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/router/app_router.dart';
import 'package:toruru/common/utils/app_storage.dart';
import 'package:toruru/firebase_options.dart';
import 'package:toruru/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppStorage.init();
  await MobileAds.instance.initialize();

  runApp(const ProviderScope(child: Toruru()));
}

class Toruru extends StatelessWidget {
  const Toruru({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColor.bgPrimary,
        brightness: Brightness.dark,
      ),
    );
  }
}
