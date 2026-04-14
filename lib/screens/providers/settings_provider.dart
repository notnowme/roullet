import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toruru/common/utils/app_storage.dart';
import 'package:toruru/models/game_settings.dart';

class SettingsNotifier extends Notifier<GameSettings> {
  static const _key = 'game_settings';

  @override
  GameSettings build() {
    return _load();
  }

  GameSettings _load() {
    final raw = AppStorage.instance.getString(_key);
    if (raw == null) return const GameSettings();
    try {
      return GameSettings.fromJson(jsonDecode(raw));
    } catch (_) {
      return const GameSettings();
    }
  }

  void update(GameSettings settings) {
    state = settings;
    _save(settings);
  }

  void reset() {
    state = const GameSettings();
    _save(state);
  }

  void _save(GameSettings settings) {
    AppStorage.instance.setString(_key, jsonEncode(settings.toJson()));
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, GameSettings>(
  SettingsNotifier.new,
);
