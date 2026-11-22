import 'package:flutter/material.dart';
import '../app/theme.dart';

enum GameCategory {
  speed,
  flexibility,
  memory,
  math,
  language,
  problem,
  focus,
  creativity,
}

extension GameCategoryX on GameCategory {
  String get labelAr => switch (this) {
    GameCategory.speed => 'السرعة والانتباه',
    GameCategory.flexibility => 'المرونة العقلية',
    GameCategory.memory => 'الذاكرة',
    GameCategory.math => 'الرياضيات',
    GameCategory.language => 'اللغة',
    GameCategory.problem => 'حل المشكلات',
    GameCategory.focus => 'التركيز',
    GameCategory.creativity => 'الإبداع',
  };
  String get labelEn => switch (this) {
    GameCategory.speed => 'Speed',
    GameCategory.flexibility => 'Flexibility',
    GameCategory.memory => 'Memory',
    GameCategory.math => 'Math',
    GameCategory.language => 'Language',
    GameCategory.problem => 'Problem Solving',
    GameCategory.focus => 'Focus',
    GameCategory.creativity => 'Creativity',
  };
  Color get color => switch (this) {
    GameCategory.speed => WamdaColors.speed,
    GameCategory.flexibility => WamdaColors.flexibility,
    GameCategory.memory => WamdaColors.memory,
    GameCategory.math => WamdaColors.math,
    GameCategory.language => WamdaColors.language,
    GameCategory.problem => WamdaColors.problem,
    GameCategory.focus => WamdaColors.focus,
    GameCategory.creativity => WamdaColors.creativity,
  };
  IconData get icon => switch (this) {
    GameCategory.speed => Icons.bolt,
    GameCategory.flexibility => Icons.swap_horiz,
    GameCategory.memory => Icons.psychology,
    GameCategory.math => Icons.calculate,
    GameCategory.language => Icons.translate,
    GameCategory.problem => Icons.extension,
    GameCategory.focus => Icons.center_focus_strong,
    GameCategory.creativity => Icons.lightbulb,
  };
}

class GameDef {
  const GameDef({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.instructionsAr,
    required this.category,
    required this.difficulty,
    required this.minutes,
    required this.sourceRepo,
    required this.sourceFile,
    required this.license,
    required this.icon,
  });
  final String id;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String instructionsAr;
  final GameCategory category;
  final int difficulty;
  final int minutes;
  final String sourceRepo;
  final String sourceFile;
  final String license;
  final IconData icon;
}

class GameResult {
  const GameResult({
    required this.score,
    required this.maxScore,
    required this.accuracy,
    required this.xp,
    required this.durationSec,
    required this.detailAr,
  });
  final int score;
  final int maxScore;
  final double accuracy;
  final int xp;
  final int durationSec;
  final String detailAr;
}

class HistoryEntry {
  const HistoryEntry({
    required this.gameId,
    required this.score,
    required this.accuracy,
    required this.xp,
    required this.dateIso,
  });
  final String gameId;
  final int score;
  final double accuracy;
  final int xp;
  final String dateIso;
  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'score': score,
    'accuracy': accuracy,
    'xp': xp,
    'dateIso': dateIso,
  };
  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
    gameId: j['gameId'] as String,
    score: (j['score'] as num).toInt(),
    accuracy: (j['accuracy'] as num).toDouble(),
    xp: (j['xp'] as num).toInt(),
    dateIso: j['dateIso'] as String,
  );
}
