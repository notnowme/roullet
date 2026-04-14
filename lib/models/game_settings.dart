import 'package:toruru/models/ball_skin.dart';

class GameSettings {
  final double gravity;
  final double ballSize; // 배율 (1.0 = 기본)
  final double ballRestitution;
  final double ballDensity;
  final double maxSpeed;
  final bool showTrail;
  final bool slowMotion;
  final bool countdown;
  final BallSkin ballSkin;
  final int playCounts;
  final int playerCounts;
  final int customMapCounts;

  const GameSettings({
    this.gravity = 25,
    this.ballSize = 0.03,
    this.ballRestitution = 0.6,
    this.ballDensity = 0.3,
    this.maxSpeed = 25,
    this.showTrail = true,
    this.slowMotion = true,
    this.countdown = true,
    this.ballSkin = BallSkin.marble,
    this.playCounts = 10,
    this.playerCounts = 5,
    this.customMapCounts = 3,
  });

  GameSettings copyWith({
    double? gravity,
    double? ballSize,
    double? ballRestitution,
    double? ballDensity,
    double? maxSpeed,
    bool? showTrail,
    bool? slowMotion,
    bool? countdown,
    BallSkin? ballSkin,
    int? playCounts,
    int? playerCounts,
    int? customMapCounts,
  }) {
    return GameSettings(
      gravity: gravity ?? this.gravity,
      ballSize: ballSize ?? this.ballSize,
      ballRestitution: ballRestitution ?? this.ballRestitution,
      ballDensity: ballDensity ?? this.ballDensity,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      showTrail: showTrail ?? this.showTrail,
      slowMotion: slowMotion ?? this.slowMotion,
      countdown: countdown ?? this.countdown,
      ballSkin: ballSkin ?? this.ballSkin,
      playCounts: playCounts ?? this.playCounts,
      playerCounts: playerCounts ?? this.playerCounts,
      customMapCounts: customMapCounts ?? this.customMapCounts,
    );
  }

  Map<String, dynamic> toJson() => {
    'gravity': gravity,
    'ballSize': ballSize,
    'ballRestitution': ballRestitution,
    'ballDensity': ballDensity,
    'maxSpeed': maxSpeed,
    'showTrail': showTrail,
    'slowMotion': slowMotion,
    'countdown': countdown,
    'ballSkin': ballSkin.name,
    'playCounts': playCounts,
    'playerCounts': playerCounts,
    'customMapCounts': customMapCounts,
  };

  factory GameSettings.fromJson(Map<String, dynamic> json) => GameSettings(
    gravity: (json['gravity'] as num?)?.toDouble() ?? 25,
    ballSize: (json['ballSize'] as num?)?.toDouble() ?? 0.03,
    ballRestitution: (json['ballRestitution'] as num?)?.toDouble() ?? 0.6,
    ballDensity: (json['ballDensity'] as num?)?.toDouble() ?? 0.3,
    maxSpeed: (json['maxSpeed'] as num?)?.toDouble() ?? 25,
    showTrail: json['showTrail'] as bool? ?? true,
    slowMotion: json['slowMotion'] as bool? ?? true,
    countdown: json['countdown'] as bool? ?? true,
    ballSkin: BallSkin.values.firstWhere(
      (s) => s.name == json['ballSkin'],
      orElse: () => BallSkin.marble,
    ),
    playCounts: json['playCounts'],
    playerCounts: json['playerCounts'],
    customMapCounts: json['customMapCounts'],
  );
}
