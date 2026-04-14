part of '../home_screen.dart';

class _TrackingOverlay extends StatefulWidget {
  const _TrackingOverlay({
    required this.game,
    required this.cameraMode,
  });

  final RollitGame game;
  final CameraMode cameraMode;

  @override
  State<_TrackingOverlay> createState() => _TrackingOverlayState();
}

class _TrackingOverlayState extends State<_TrackingOverlay> {
  String _name = '';
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return false;
      setState(() {
        _name = widget.game.trackingBallName;
        _color = widget.game.trackingBallColor;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameraMode == CameraMode.editor || _name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey('${_name}_$_color'),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _color.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: _color.withValues(alpha: 0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 공 미니 아이콘
                // Container(
                //   width: 24,
                //   height: 24,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: _color,
                //     boxShadow: [
                //       BoxShadow(
                //         color: _color.withValues(alpha: 0.4),
                //         blurRadius: 6,
                //       ),
                //     ],
                //   ),
                //   child: Center(
                //     child: Text(
                //       _name.isNotEmpty ? _name[0] : '',
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 8),
                // 이름 + 모드
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _name,
                            style: TextStyle(
                              color: _color,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' ${AppLocalizations.of(context)!.following}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
