import 'package:bounce_tapper/bounce_tapper.dart';
import 'package:flutter/material.dart';

class BounceButton extends StatelessWidget {
  const BounceButton({
    super.key,
    this.radius = 12,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final double radius;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return BounceTapper(
      onTap: onTap,
      highlightBorderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}
