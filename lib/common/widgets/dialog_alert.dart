import 'package:flutter/material.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/themes.dart';
import 'package:toruru/l10n/app_localizations.dart';
import 'package:toruru/mixins/animations.dart';

class DialogAlert extends StatefulWidget {
  const DialogAlert({
    super.key,
    required this.title,
    required this.body,
    this.titleColor = AppColor.textPrimary,
    this.cb1,
    this.cb2,
  });

  final String title;
  final String body;
  final Color titleColor;
  final VoidCallback? cb1;
  final VoidCallback? cb2;

  @override
  State<DialogAlert> createState() => _DialogAlertState();
}

class _DialogAlertState extends State<DialogAlert>
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
                  vertical: 8,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                decoration: AppUI.neonOutline(
                  color: AppColor.bgElevated,
                  opacity: 0.9,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.titleColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.body,
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _ActionButtons(cb1: widget.cb1, cb2: widget.cb2),
                    const SizedBox(
                      height: 24,
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
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.cb1,
    required this.cb2,
  });

  final VoidCallback? cb1;
  final VoidCallback? cb2;

  @override
  Widget build(BuildContext context) {
    return cb2 == null
        ? GestureDetector(
            onTap: cb1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: AppUI.neonOutline(
                color: AppColor.accent,
                opacity: 1,
                borderRadius: 8,
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        : Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: cb1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: AppUI.neonOutline(
                      color: AppColor.bgPrimary,
                      opacity: 1,
                      borderRadius: 8,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: cb2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: AppUI.neonOutline(
                      color: AppColor.accent,
                      opacity: 1,
                      borderRadius: 8,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
