import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toruru/common/utils/app_storage.dart';
import 'package:toruru/models/ball_skin.dart';

class SkinUnlockNotifier extends Notifier<Set<BallSkin>> {
  static const _key = 'unlocked_skins';

  @override
  Set<BallSkin> build() => _load();

  Set<BallSkin> _load() {
    final raw = AppStorage.instance.getString(_key);
    if (raw == null) return {BallSkin.marble};
    try {
      final list = (jsonDecode(raw) as List).cast<String>();
      final skins = list
          .map((name) => BallSkin.values.firstWhere(
                (s) => s.name == name,
                orElse: () => BallSkin.marble,
              ))
          .toSet();
      skins.add(BallSkin.marble); // 기본 스킨은 항상 해방
      return skins;
    } catch (_) {
      return {BallSkin.marble};
    }
  }

  bool isUnlocked(BallSkin skin) => state.contains(skin);

  /// 광고 시청 후 호출
  void unlockSkin(BallSkin skin) {
    if (state.contains(skin)) return;
    state = {...state, skin};
    _save();
  }

  void _save() {
    final list = state.map((s) => s.name).toList();
    AppStorage.instance.setString(_key, jsonEncode(list));
  }
}

final skinUnlockProvider =
    NotifierProvider<SkinUnlockNotifier, Set<BallSkin>>(
  SkinUnlockNotifier.new,
);
