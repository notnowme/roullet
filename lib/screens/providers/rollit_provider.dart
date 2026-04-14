import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toruru/common/constants/colors.dart';
import 'package:toruru/common/constants/enums.dart';
import 'package:toruru/data/default_maps.dart';
import 'package:toruru/models/ball_skin.dart';
import 'package:toruru/models/game_option_model.dart';
import 'package:toruru/models/map_data.dart';
import 'package:toruru/models/map_storage.dart';
import 'package:toruru/screens/providers/settings_provider.dart';
import 'package:toruru/screens/rollit_game.dart';

// ─── 게임 옵션 ──────────────────────────────────────────────────────

class GameOptionNotifier extends Notifier<GameOptionModel> {
  @override
  GameOptionModel build() {
    return const GameOptionModel(
      names: ['고양이', '강아지', '앵무새', '햄스터'],
      condition: WinCondition.first,
      winnerNums: 2,
    );
  }

  void setOptions(GameOptionModel model) => state = model;
}

final gameOptionProvider =
    NotifierProvider.autoDispose<GameOptionNotifier, GameOptionModel>(
      GameOptionNotifier.new,
    );

// ─── 게임 인스턴스 ──────────────────────────────────────────────────

class RollitGameNotifier extends Notifier<RollitGame?> {
  @override
  RollitGame? build() {
    return null;
  }

  void start(GameOptionModel options, MapData mapData) {
    if (options.names.length < 2) return;
    final settings = ref.read(settingsProvider);
    final indices = ref.read(ballIndicesProvider);
    state = RollitGame(
      names: options.names,
      onWinner: (name) => ref.read(winnerProvider.notifier).setWinner(name),
      winCondition: options.condition,
      mapData: mapData,
      settings: settings,
      ballIndices: indices,
      winners: [],
      winnerNums: ref.read(gameOptionProvider.select((s) => s.winnerNums)),
    );
  }

  void reset() => state = null;
}

final rollitGameProvider =
    NotifierProvider.autoDispose<RollitGameNotifier, RollitGame?>(
      RollitGameNotifier.new,
    );

// ─── 우승자 ─────────────────────────────────────────────────────────

class WinnerNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setWinner(String name) => state = name;
}

final winnerProvider = NotifierProvider.autoDispose<WinnerNotifier, String?>(
  WinnerNotifier.new,
);

// ─── 카메라 모드 ────────────────────────────────────────────────────

class CameraModeNotifier extends Notifier<CameraMode> {
  @override
  CameraMode build() => CameraMode.followLast;

  void setMode(CameraMode mode) => state = mode;
}

final cameraModeProvider =
    NotifierProvider.autoDispose<CameraModeNotifier, CameraMode>(
      CameraModeNotifier.new,
    );

// ─── 리더보드 표시 ──────────────────────────────────────────────────

class ShowLeaderboardNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final showLeaderboardProvider =
    NotifierProvider.autoDispose<ShowLeaderboardNotifier, bool>(
      ShowLeaderboardNotifier.new,
    );

// ─── 리더보드 위치 ──────────────────────────────────────────────────

class LeaderboardAtTopNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final leaderboardAtTopProvider =
    NotifierProvider.autoDispose<LeaderboardAtTopNotifier, bool>(
      LeaderboardAtTopNotifier.new,
    );

// ─── 이름 입력 ──────────────────────────────────────────────────────

class NamesInputNotifier extends Notifier<String> {
  @override
  String build() {
    final String langCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return switch (langCode) {
      'ko' => '강아지,고양이,햄스터,카피바라',
      'ja' => 'ねこ,いぬ,さめ,ハムスター',
      _ => 'dog,cat,lion,tiger',
    };
  }

  void update(String value) => state = value;
}

final namesInputProvider =
    NotifierProvider.autoDispose<NamesInputNotifier, String>(
      NamesInputNotifier.new,
    );

final parsedNamesProvider = Provider.autoDispose<List<String>>((ref) {
  return ref
      .watch(namesInputProvider)
      .replaceAll('、', ',')
      .replaceAll('，', ',')
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
});

// ─── 맵 선택 ────────────────────────────────────────────────────────

class SelectedMapNotifier extends Notifier<MapData> {
  @override
  MapData build() => defaultMaps[0];

  void select(MapData map) => state = map;
}

final selectedMapProvider =
    NotifierProvider.autoDispose<SelectedMapNotifier, MapData>(
      SelectedMapNotifier.new,
    );

// ─── 게임 시간 ────────────────────────────────────────────────────────

final gameTimeProvider = StreamProvider.autoDispose<double>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (count) {
    return (count + 1).toDouble();
  }).distinct();
});

// ─── 게임 시간 ────────────────────────────────────────────────────────

final homeMapListScrollProvider = Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

// ─── 공 배정 인덱스 (셔플) ───────────────────────────────────────────

class BallIndicesNotifier extends Notifier<List<int>> {
  @override
  List<int> build() => [];

  List<int> _generateBallIndices(BallSkin skin, int count) {
    final poolSize = switch (skin) {
      BallSkin.solarSystem => planets.length,
      BallSkin.sports => sportsBalls.length,
      BallSkin.fruit => fruits.length,
      BallSkin.marble ||
      BallSkin.pixel ||
      BallSkin.slime => marbleColors.length,
    };
    final pool = List.generate(poolSize, (i) => i)..shuffle(Random());
    return List.generate(count, (i) => pool[i % poolSize]);
  }

  void generate(BallSkin skin, int count) {
    state = _generateBallIndices(skin, count);
  }
}

final ballIndicesProvider =
    NotifierProvider.autoDispose<BallIndicesNotifier, List<int>>(
      BallIndicesNotifier.new,
    );

// -- 커스텀 맵 프로바이더 --
class CustomMapNotifier extends Notifier<List<MapData>> {
  @override
  List<MapData> build() {
    return MapStorage.loadAll();
  }

  void update() {
    state = [...MapStorage.loadAll()];
  }
}

final customMapProvider = NotifierProvider.autoDispose(() {
  return CustomMapNotifier();
});

// ─── 리셋 ───────────────────────────────────────────────────────────

void resetAll(WidgetRef ref) {
  ref.invalidate(rollitGameProvider);
  ref.invalidate(winnerProvider);
  ref.invalidate(cameraModeProvider);
  ref.invalidate(showLeaderboardProvider);
  ref.invalidate(leaderboardAtTopProvider);
  ref.invalidate(ballIndicesProvider);
}
