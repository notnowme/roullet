part of '../home_screen.dart';

class _ParticipantPreview extends ConsumerStatefulWidget {
  const _ParticipantPreview({required this.indices});

  final List<int> indices;

  @override
  ConsumerState<_ParticipantPreview> createState() =>
      _ParticipantPreviewState();
}

class _ParticipantPreviewState extends ConsumerState<_ParticipantPreview>
    with TickerProviderStateMixin, PopupAnimation {
  @override
  void initState() {
    super.initState();
    initPopupAnimation();
    playPopupAnimation();
  }

  @override
  void dispose() {
    disposePopupAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = ref.watch(parsedNamesProvider);
    final skin = ref.watch(settingsProvider.select((s) => s.ballSkin));
    final indices = widget.indices;

    return AnimatedBuilder(
      animation: bgController,
      builder: (ctx, _) {
        return Scaffold(
          backgroundColor: AppColor.bgElevated.withValues(alpha: 0.05),
          body: Center(
            child: ScaleTransition(
              scale: cardScale,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                constraints: const BoxConstraints(maxWidth: 360),
                decoration: AppUI.neonOutline(
                  color: AppColor.bgElevated,
                  opacity: 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.chanllenger,
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(names.length, (i) {
                      final idx = indices[i];
                      final color = _getBallColor(skin, idx);
                      final skinLabel = _getBallLabel(skin, idx, context);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            _BallPreview(color: color, skin: skin, index: i),
                            const SizedBox(width: 12),
                            if (skinLabel != null) ...[
                              Text(
                                skinLabel,
                                style: TextStyle(
                                  color: color.withValues(alpha: 0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '—',
                                style: TextStyle(
                                  color: AppColor.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: Text(
                                names[i],
                                style: const TextStyle(
                                  color: AppColor.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        context.pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: AppUI.neonButton(color: AppColor.accent),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.start,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBallColor(BallSkin skin, int idx) {
    return switch (skin) {
      BallSkin.solarSystem => planets[idx].baseColor,
      BallSkin.sports => sportsBalls[idx].trailColor,
      BallSkin.fruit => fruits[idx].trailColor,
      BallSkin.marble || BallSkin.pixel || BallSkin.slime => marbleColors[idx],
    };
  }

  String? _getBallLabel(BallSkin skin, int idx, BuildContext context) {
    return switch (skin) {
      BallSkin.solarSystem => planets[idx].name(context),
      BallSkin.sports => sportsBalls[idx].name(context),
      BallSkin.fruit => fruits[idx].name(context),
      BallSkin.marble || BallSkin.pixel || BallSkin.slime => null,
    };
  }
}

class _BallPreview extends StatelessWidget {
  const _BallPreview({
    required this.color,
    required this.skin,
    required this.index,
  });

  final Color color;
  final BallSkin skin;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _BallPreviewPainter(color: color, skin: skin, index: index),
    );
  }
}

class _BallPreviewPainter extends CustomPainter {
  _BallPreviewPainter({
    required this.color,
    required this.skin,
    required this.index,
  });

  final Color color;
  final BallSkin skin;
  final int index;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    // 기본 그라데이션 구체
    final gradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 0.9,
      colors: [
        Color.lerp(color, Colors.white, 0.35)!,
        color,
        Color.lerp(color, Colors.black, 0.3)!,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);

    // 하이라이트
    final highlight = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.45),
        radius: 0.5,
        colors: [
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, highlight);
  }

  @override
  bool shouldRepaint(covariant _BallPreviewPainter old) =>
      old.color != color || old.skin != skin || old.index != index;
}
