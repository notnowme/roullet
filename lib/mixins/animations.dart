import 'package:flutter/material.dart';

mixin PopupAnimation<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late final AnimationController bgController;
  late final AnimationController cardController;
  late final AnimationController contentController;

  late final Animation<double> bgFade;
  late final Animation<double> cardScale;
  late final Animation<Offset> cardSlide;
  late final Animation<double> contentFade;
  late final Animation<double> emojiPop;

  void initPopupAnimation() {
    // 배경
    bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    bgFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: bgController, curve: Curves.easeOut),
    );

    // 카드
    cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    cardSlide =
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: cardController, curve: Curves.easeOutBack),
        );
    cardScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: cardController, curve: Curves.easeOutBack),
    );

    // 내용
    contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: contentController, curve: Curves.easeOut),
    );
    emojiPop = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1.3), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 20),
    ]).animate(contentController);
  }

  Future<void> playPopupAnimation() async {
    bgController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    cardController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    contentController.forward();
  }

  void disposePopupAnimation() {
    bgController.dispose();
    cardController.dispose();
    contentController.dispose();
  }
}
