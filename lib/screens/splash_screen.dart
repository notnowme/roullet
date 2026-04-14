import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // 로고 애니메이션
  late final AnimationController _logoController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  // 공 바운스 애니메이션
  late final AnimationController _ballController;

  // 텍스트 애니메이션
  late final AnimationController _textController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // ─── 로고: 페이드인 + 스케일 ──────────────────────
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // ─── 공: 위에서 떨어져서 통통 튀기 ─────────────────
    _ballController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // ─── 텍스트: 슬라이드업 + 페이드인 ─────────────────
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide =
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));

    // 로고 페이드인
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 300));

    // 공 바운스 시작
    _ballController.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    // 텍스트 등장
    _textController.forward();

    // 잠시 보여주고 홈으로
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      await precacheImage(const AssetImage('assets/images/logo.png'), context);
      if (mounted) {
        context.goNamed('home');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _ballController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 공 + 로고 영역
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 로고 이모지 (배경)
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoFade.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Image.asset(
                            'assets/images/logo.png',
                            cacheWidth: 256,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // "또르르" 텍스트
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appTitle,
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppLocalizations.of(context)!.appSubtitle,
                      style: const TextStyle(
                        color: AppColor.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
