import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class WamdaStore {
  WamdaStore._();
  static final WamdaStore instance = WamdaStore._();
  SharedPreferences? _prefs;
  bool _loaded = false;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _loaded = true;
  }

  SharedPreferences get _p {
    if (!_loaded || _prefs == null) throw StateError('WamdaStore not loaded');
    return _prefs!;
  }

  int get totalXp => _p.getInt('totalXp') ?? 0;
  int get level => totalXp ~/ 100 + 1;
  int get xpInLevel => totalXp % 100;
  String? get lastPlayDate => _p.getString('lastPlayDate');
  int get streakDays => _p.getInt('streakDays') ?? 0;

  int bestScore(String gameId) => _p.getInt('best_$gameId') ?? 0;
  int playCount(String gameId) => _p.getInt('plays_$gameId') ?? 0;

  Set<String> get favorites => (_p.getStringList('favorites') ?? []).toSet();
  bool isFavorite(String gameId) => favorites.contains(gameId);

  Future<void> toggleFavorite(String gameId) async {
    final favs = favorites;
    if (favs.contains(gameId)) {
      favs.remove(gameId);
    } else {
      favs.add(gameId);
    }
    await _p.setStringList('favorites', favs.toList());
  }

  List<HistoryEntry> get history {
    final raw = _p.getStringList('history') ?? [];
    return raw
        .map(
          (s) => HistoryEntry.fromJson(jsonDecode(s) as Map<String, dynamic>),
        )
        .toList();
  }

  int get totalPlays => history.length;

  List<HistoryEntry> get todayHistory {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return history.where((h) => h.dateIso.startsWith(today)).toList();
  }

  Set<String> get todayPlayedGameIds =>
      todayHistory.map((h) => h.gameId).toSet();

  Future<bool> recordResult(
    String gameId,
    int score,
    double accuracy,
    int xpEarned,
  ) async {
    final isBest = score > bestScore(gameId);
    if (isBest) await _p.setInt('best_$gameId', score);
    await _p.setInt('plays_$gameId', playCount(gameId) + 1);
    await _p.setInt('totalXp', totalXp + xpEarned);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last = lastPlayDate;
    if (last != today) {
      if (last != null) {
        final yesterday = DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String()
            .substring(0, 10);
        if (last == yesterday) {
          await _p.setInt('streakDays', streakDays + 1);
        } else {
          await _p.setInt('streakDays', 1);
        }
      } else {
        await _p.setInt('streakDays', 1);
      }
      await _p.setString('lastPlayDate', today);
    }
    final entry = HistoryEntry(
      gameId: gameId,
      score: score,
      accuracy: accuracy,
      xp: xpEarned,
      dateIso: DateTime.now().toIso8601String(),
    );
    final hist = history;
    hist.insert(0, entry);
    final trimmed = hist.take(50).map((h) => jsonEncode(h.toJson())).toList();
    await _p.setStringList('history', trimmed);
    return isBest;
  }

  Future<void> resetAll() async {
    await _p.clear();
  }
}
