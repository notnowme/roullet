part of 'game_setting_screen.dart';

class _SkinSelector extends ConsumerStatefulWidget {
  const _SkinSelector({
    required this.selectedSkin,
    required this.onSelect,
  });

  final BallSkin selectedSkin;
  final ValueChanged<BallSkin> onSelect;

  @override
  ConsumerState<_SkinSelector> createState() => _SkinSelectorState();
}

class _SkinSelectorState extends ConsumerState<_SkinSelector>
    with RewardedAdMixin {
  @override
  Widget build(BuildContext context) {
    final unlockedSkins = ref.watch(skinUnlockProvider);

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: BallSkin.values.map((skin) {
          final isUnlocked = unlockedSkins.contains(skin);
          final isSelected = skin == widget.selectedSkin;

          return _SkinRow(
            skin: skin,
            isUnlocked: isUnlocked,
            isSelected: isSelected,
            onTap: isUnlocked ? () => widget.onSelect(skin) : null,
            onUnlock: () {
              showRewardedAd(
                onRewardEarned: (reward) {
                  ref.read(skinUnlockProvider.notifier).unlockSkin(skin);
                  widget.onSelect(skin);
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

// ── 스킨 선택 위젯 ────────────────────────────────────────────────────────────

class _SkinRow extends StatelessWidget {
  const _SkinRow({
    required this.skin,
    required this.isUnlocked,
    required this.isSelected,
    required this.onUnlock,
    this.onTap,
  });

  final BallSkin skin;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? AppColor.accent.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? AppColor.accent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.05),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // 미리보기
              _SkinPreview(skin: skin, size: 40),
              const SizedBox(width: 12),

              // 이름 + 설명
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skin.getLabel(context),
                      style: TextStyle(
                        color: isSelected
                            ? AppColor.textPrimary
                            : AppColor.textSecondary,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      skin.getdescription(context),
                      style: const TextStyle(
                        color: AppColor.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // 선택됨 / 잠금 표시
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColor.accent, size: 20)
              else if (!isUnlocked)
                BounceButton(
                  onTap: onUnlock,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B6CF6), Color(0xFF9B8FFF)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.adReward,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 스킨 미리보기 ─────────────────────────────────────────────────────────────

class _SkinPreview extends StatelessWidget {
  const _SkinPreview({required this.skin, required this.size});

  final BallSkin skin;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SkinPreviewPainter(skin: skin),
      ),
    );
  }
}

class _SkinPreviewPainter extends CustomPainter {
  const _SkinPreviewPainter({required this.skin});

  final BallSkin skin;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 * 0.85;

    canvas.translate(center.dx, center.dy);

    switch (skin) {
      case BallSkin.marble:
        _paintMarble(canvas, r);
      case BallSkin.solarSystem:
        _paintSolarSystem(canvas, r);
      case BallSkin.sports:
        _paintSports(canvas, r);
      case BallSkin.pixel:
        _paintPixel(canvas, r);
      case BallSkin.slime:
        _paintSlime(canvas, r);
      case BallSkin.fruit:
        _paintFruit(canvas, r);
    }
  }

  void _paintMarble(Canvas canvas, double r) {
    const color = Color(0xFF7B6CF6);

    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 1.0,
          colors: [
            Color.lerp(color, Colors.white, 0.35)!,
            color,
            Color.lerp(color, Colors.black, 0.3)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-r * 0.2, -r * 0.3),
        width: r * 0.9,
        height: r * 0.5,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset(-r * 0.3, -r * 0.35),
      r * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _paintSolarSystem(Canvas canvas, double r) {
    // 지구로 대표 미리보기
    final planet = planets[2]; // 지구

    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 1.0,
          colors: [planet.lightColor, planet.baseColor, planet.darkColor],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );

    // 대륙
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-r * 0.1, -r * 0.1),
        width: r * 0.55,
        height: r * 0.5,
      ),
      Paint()..color = const Color(0xFF2E7D32).withValues(alpha: 0.85),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(r * 0.38, r * 0.22),
        width: r * 0.32,
        height: r * 0.5,
      ),
      Paint()..color = const Color(0xFF2E7D32).withValues(alpha: 0.85),
    );
    canvas.restore();

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-r * 0.2, -r * 0.3),
        width: r * 0.9,
        height: r * 0.5,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );

    // 행성 6개를 작은 점으로 표시
    final dotColors = [
      planets[0].baseColor,
      planets[3].baseColor,
      planets[4].baseColor,
      planets[5].baseColor,
      planets[6].baseColor,
      planets[7].baseColor,
    ];
    for (int i = 0; i < dotColors.length; i++) {
      final angle = (i / dotColors.length) * math.pi * 2 - math.pi / 2;
      final dx = math.cos(angle) * r * 1.45;
      final dy = math.sin(angle) * r * 1.45;
      canvas.drawCircle(
        Offset(dx, dy),
        r * 0.12,
        Paint()..color = dotColors[i],
      );
    }
  }

  void _paintSports(Canvas canvas, double r) {
    // 농구공으로 대표 미리보기
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          radius: 1.0,
          colors: [Color(0xFFFF8F00), Color(0xFFE65100), Color(0xFFBF360C)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    final seam = Paint()
      ..color = Colors.black.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.075
      ..strokeCap = StrokeCap.round;
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-r, 0)
        ..quadraticBezierTo(0, r * 0.18, r, 0),
      seam,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, -r)
        ..cubicTo(-r * 0.35, -r * 0.28, -r * 0.35, r * 0.28, 0, r),
      seam,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, -r)
        ..cubicTo(r * 0.35, -r * 0.28, r * 0.35, r * 0.28, 0, r),
      seam,
    );
    canvas.restore();
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-r * 0.2, -r * 0.3),
        width: r * 0.8,
        height: r * 0.45,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.2),
    );
    // 주변에 다른 스포츠 볼 색 점
    final dots = [
      const Color(0xFFEEEEEE), // 야구
      const Color(0xFFF0F0F0), // 축구
      const Color(0xFFCDDC39), // 테니스
      const Color(0xFF1A237E), // 볼링
      const Color(0xFFE53935), // 당구
    ];
    for (int i = 0; i < dots.length; i++) {
      final a = (i / dots.length) * math.pi * 2 - math.pi / 2;
      canvas.drawCircle(
        Offset(math.cos(a) * r * 1.45, math.sin(a) * r * 1.45),
        r * 0.12,
        Paint()..color = dots[i],
      );
    }
  }

  void _paintPixel(Canvas canvas, double r) {
    const color = Color(0xFF7B6CF6);
    const gridN = 10;
    final pixSize = (r * 2) / gridN;

    for (int row = 0; row < gridN; row++) {
      for (int col = 0; col < gridN; col++) {
        final cx = -r + (col + 0.5) * pixSize;
        final cy = -r + (row + 0.5) * pixSize;
        if (cx * cx + cy * cy > r * r) {
          continue;
        }
        final dist = math.sqrt(cx * cx + cy * cy);
        final Color pix;
        if (dist > r * 0.82) {
          pix = Color.lerp(color, Colors.black, 0.48)!;
        } else if (row <= 2 && col <= 3) {
          pix = Color.lerp(color, Colors.white, 0.62)!;
        } else if (row >= gridN - 3 && col >= gridN - 4) {
          pix = Color.lerp(color, Colors.black, 0.42)!;
        } else {
          pix = color;
        }
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: pixSize * 0.9,
            height: pixSize * 0.9,
          ),
          Paint()..color = pix,
        );
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(
        -r + pixSize * 1.0,
        -r + pixSize * 1.0,
        pixSize * 1.6,
        pixSize * 0.9,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        -r + pixSize * 1.0,
        -r + pixSize * 2.0,
        pixSize * 0.9,
        pixSize * 0.9,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  void _paintSlime(Canvas canvas, double r) {
    // 약간 찌그러진 상태로 미리보기 (찌그러짐 효과 암시)
    canvas.save();
    canvas.scale(0.82, 1.18); // 살짝 세로로 늘어난 상태
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.35),
          radius: 1.0,
          colors: [
            const Color(0xFFA5D6A7).withValues(alpha: 0.82),
            const Color(0xFF66BB6A).withValues(alpha: 0.74),
            const Color(0xFF2E7D32).withValues(alpha: 0.90),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = const Color(0xFF1B5E20).withValues(alpha: 0.60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.11,
    );
    canvas.restore();

    // 하이라이트 (찌그러짐과 별개로 상단에 고정)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-r * 0.18, -r * 0.30),
        width: r * 0.72,
        height: r * 0.36,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset(-r * 0.28, -r * 0.36),
      r * 0.10,
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );
  }

  void _paintFruit(Canvas canvas, double r) {
    // 딸기로 대표 미리보기
    // 글로우
    canvas.drawCircle(
      Offset.zero,
      r * 1.5,
      Paint()
        ..color = const Color(0xFFFF1744).withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // 구체
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.28, -0.38),
          colors: [Color(0xFFFF8A80), Color(0xFFFF1744), Color(0xFFB71C1C)],
          stops: [0.0, 0.50, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 100)),
    );
    // 꼭지 잎
    final calP = Paint()..color = const Color(0xFF388E3C);
    for (int j = 0; j < 4; j++) {
      final a = j * math.pi / 2 + math.pi / 4;
      canvas.save();
      canvas.translate(
        math.cos(a) * r * 0.16,
        -r * 0.78 + math.sin(a) * r * 0.10,
      );
      canvas.rotate(a + math.pi / 2);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -r * 0.12),
          width: r * 0.13,
          height: r * 0.24,
        ),
        calP,
      );
      canvas.restore();
    }
    // 씨앗
    final dotP = Paint()
      ..color = const Color(0xFFFFF176).withValues(alpha: 0.90);
    for (int j = 0; j < 12; j++) {
      final a = j * 2.399;
      final rd = math.sqrt((j + 0.5) / 12) * r * 0.70;
      final sx = rd * math.cos(a);
      final sy = rd * math.sin(a) + r * 0.04;
      if (sy < r * 0.62) {
        canvas.save();
        canvas.translate(sx, sy);
        canvas.rotate(a);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: r * 0.055,
            height: r * 0.09,
          ),
          dotP,
        );
        canvas.restore();
      }
    }
    // 하이라이트
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-r * 0.20, -r * 0.30),
        width: r * 0.88,
        height: r * 0.46,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawCircle(
      Offset(-r * 0.30, -r * 0.35),
      r * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.70),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
