import 'package:toruru/common/constants/enums.dart';

class GameOptionModel {
  final List<String> names;
  final WinCondition condition;
  final int winnerNums;

  const GameOptionModel({
    required this.names,
    required this.condition,
    required this.winnerNums,
  });

  GameOptionModel copyWith({
    List<String>? names,
    WinCondition? condition,
    int? winnderNums,
  }) {
    return GameOptionModel(
      names: names ?? this.names,
      condition: condition ?? this.condition,
      winnerNums: winnderNums?.clamp(2, 10) ?? winnerNums,
    );
  }
}
