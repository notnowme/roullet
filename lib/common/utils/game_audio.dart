import 'package:flame_audio/flame_audio.dart';

class GameAudio {
  GameAudio._();
  static final instance = GameAudio._();

  static const countdownBeep = 'countdown_beep.wav';
  static const countdownGo = 'countdown_go.wav';
  static const goalArrive = 'goal_arrive.wav';

  final Set<String> _loaded = {};

  Future<void> preload() async {
    for (final file in [countdownBeep, countdownGo, goalArrive]) {
      try {
        await FlameAudio.audioCache.load(file);
        _loaded.add(file);
      } catch (_) {
        // 개별 파일 없으면 해당 파일만 스킵
      }
    }
  }

  void playCountdownBeep() => _play(countdownBeep);
  void playCountdownGo() => _play(countdownGo);
  void playGoalArrive() => _play(goalArrive);

  void _play(String file) {
    if (!_loaded.contains(file)) return;
    try {
      FlameAudio.play(file);
    } catch (_) {}
  }
}
