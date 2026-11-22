import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class DangerPathGame extends StatefulWidget {
  const DangerPathGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<DangerPathGame> createState() => _State();
}

class _State extends State<DangerPathGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 6;
  int _size = 4;
  Set<int> _path = {}; // safe cells
  int _pos = -1; // player cell index
  int _startCell = 0;
  int _goalCell = 0;
  Set<int> _revealedDanger = {};
  bool _showing = false;
  int _lives = 3;
  int _score = 0;
  int _completed = 0;
  int _steps = 0;
  int _dangerHits = 0;
  bool _roundOver = false;
  final _rand = Random();
  final _start = Stopwatch();

  int _idx(int r, int c) => r * _size + c;

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  void _nextRound() {
    _round++;
    _size = 4 + (_round - 1) ~/ 2; // 4,4,5,5,6,6
    _lives = 3;
    _revealedDanger = {};
    _roundOver = false;
    // random walk from top row to bottom row
    var col = _rand.nextInt(_size);
    var row = 0;
    _startCell = _idx(row, col);
    _path = {_startCell};
    var guard = 0;
    while (row < _size - 1 && guard++ < 500) {
      final moves = <int>[];
      moves.add(_idx(row + 1, col)); // down always possible
      if (col > 0) moves.add(_idx(row, col - 1));
      if (col < _size - 1) moves.add(_idx(row, col + 1));
      final next = moves[_rand.nextInt(moves.length)];
      row = next ~/ _size;
      col = next % _size;
      _path.add(next);
    }
    _goalCell = _idx(_size - 1, col);
    _pos = _startCell;
    setState(() => _showing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showing = false);
    });
  }

  bool _adjacent(int a, int b) {
    final ar = a ~/ _size, ac = a % _size;
    final br = b ~/ _size, bc = b % _size;
    return (ar - br).abs() + (ac - bc).abs() == 1;
  }

  void _tap(int i) {
    if (_showing || _roundOver) return;
    if (!_adjacent(_pos, i)) return;
    if (_path.contains(i)) {
      setState(() => _pos = i);
      _steps++;
      HapticFeedback.selectionClick();
      if (i == _goalCell) {
        _completed++;
        _score += 30 + _lives * 10;
        _roundOver = true;
        HapticFeedback.lightImpact();
        _advance();
      }
    } else {
      _lives--;
      _dangerHits++;
      setState(() => _revealedDanger.add(i));
      HapticFeedback.mediumImpact();
      if (_lives <= 0) {
        _roundOver = true;
        _advance();
      }
    }
  }

  void _advance() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        final total = _steps + _dangerHits;
        final acc = total == 0 ? 0.0 : _steps / total * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _rounds * 60,
            accuracy: acc,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'أكملت $_completed من $_rounds مسارات',
          ),
        );
      } else {
        _nextRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'سيظهر المسار الآمن 3 ثوانٍ ثم يختفي. امشِ خطوة خطوة من الأعلى إلى الهدف دون الوقوع في الخطر. لديك 3 قلوب كل جولة. 6 جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة $_round من $_rounds  •  النقاط: $_score  •  ${'❤' * _lives}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(_showing ? 'احفظ المسار الآمن...' : 'امشِ نحو الهدف الذهبي'),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _size * _size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _size,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (_, i) {
                Color bg = Colors.white;
                IconData? icon;
                Color iconColor = Colors.white;
                if (_showing && _path.contains(i)) bg = const Color(0xFF0E7C6B);
                if (_revealedDanger.contains(i)) {
                  bg = Colors.red.shade400;
                  icon = Icons.warning_amber;
                }
                if (i == _goalCell) {
                  bg = const Color(0xFFF2A93B);
                  icon = Icons.flag;
                  iconColor = const Color(0xFF14213D);
                }
                if (i == _pos) {
                  bg = const Color(0xFF14213D);
                  icon = Icons.person;
                }
                final canStep = !_showing && !_roundOver && _adjacent(_pos, i);
                return Material(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: icon != null
                          ? Icon(icon, color: iconColor, size: 22)
                          : (canStep
                              ? const Icon(Icons.circle, size: 8, color: Colors.black26)
                              : null),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
