import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toruru/screens/providers/rollit_provider.dart';

mixin class HooksMixin {
  void scrollToMapCard(BuildContext ctx, WidgetRef ref, int index) {
    final scrollController = ref.read(homeMapListScrollProvider);
    final screenWidth = MediaQuery.of(ctx).size.width;
    final itemWidth = 120.0;
    final margin = 10.0;
    final totalItemWidth = itemWidth + margin;

    // 아이템의 시작점 좌표에서 화면 절반을 빼고, 아이템 절반만큼 다시 더함
    final targetOffset =
        ((index + 4) * totalItemWidth) - (screenWidth / 2) + (itemWidth / 2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        targetOffset.clamp(0.0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }
}
