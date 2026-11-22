import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class MatchingShapesGame extends StatefulWidget {
  const MatchingShapesGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MatchingShapesGame> createState() => _State();
}

class _Cell {
  _Cell(this.shape, this.color);
  final int shape;
  final Color color;
}

class _State extends State<MatchingShapesGame> {
  static const _shapes = [
    Icons.circle,
    Icons.square,
    Icons.change_history,
    Icons.star,
    Icons.favorite,
    Icons.hexagon,
  ];
  static const _colors = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
    Color(0xFF7C5CBF),
    Color(0xFFD6336C),
  ];
  static const _totalRounds = 8;

  bool _ready = true;
  int _round = 0;
  int _targetShape = 0;
  Color _targetColor = _colors[0];
  List<_Cell> _cells = [];
  final Set<int> _found = {};
  int _targetsTotal = 0;
  int _mistakes = 0;
  int _score = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  int get _gridN => _round < 3 ? 4 : (_round < 6 ? 5 : 6);

  void _newRound() {
    _targetShape = _rand.nextInt(_shapes.length);
    _targetColor = _colors[_rand.nextInt(_colors.length)];
    final n = _gridN * _gridN;
    _targetsTotal = 3 + _rand.nextInt(3) + _round ~/ 3;
    _cells = [];
    final targetIdx = <int>{};
    while (targetIdx.length < _targetsTotal) {
      targetIdx.add(_rand.nextInt(n));
    }
    for (var i = 0; i < n; i++) {
      if (targetIdx.contains(i)) {
        _cells.add(_Cell(_targetShape, _targetColor));
      } else {
        int s;
        Color c;
        do {
          s = _rand.nextInt(_shapes.length);
          c = _colors[_rand.nextInt(_colors.length)];
        } while (s == _targetShape && c == _targetColor);
        _cells.add(_Cell(s, c));
      }
    }
    _found.clear();
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _tap(int i) {
    if (_found.contains(i)) return;
    final cell = _cells[i];
    if (cell.shape == _targetShape && cell.color == _targetColor) {
      HapticFeedback.lightImpact();
      _found.add(i);
      _score += 15;
      if (_found.length >= _targetsTotal) {
        _round++;
        if (_round >= _totalRounds) {
          _stopwatch.stop();
          final taps = _score ~/ 15 + _mistakes;
          widget.onFinish(
            GameResult(
              score: _score,
              maxScore: 800,
              accuracy: taps == 0 ? 100 : (_score ~/ 15) / taps * 100,
              xp: 10 + _score ~/ 10,
              durationSec: _stopwatch.elapsed.inSeconds,
              detailAr: 'أكملت $_totalRounds جولات • أخطاء: $_mistakes',
            ),
          );
          return;
        }
        setState(_newRound);
        return;
      }
    } else {
      HapticFeedback.mediumImpact();
      _mistakes++;
      _score = max(0, _score - 5);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اضغط على كل الأشكال المطابقة للهدف تماماً (الشكل واللون). $_totalRounds جولات متدرجة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1} من $_totalRounds  •  النتيجة: $_score'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('الهدف: '),
              Icon(_shapes[_targetShape], color: _targetColor, size: 34),
              Text('  •  وجدت ${_found.length} من $_targetsTotal'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _cells.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridN,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (_, i) {
                final cell = _cells[i];
                final found = _found.contains(i);
                return Material(
                  color: found ? Colors.green.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(10),
                    child: Icon(
                      _shapes[cell.shape],
                      color: found ? Colors.grey : cell.color,
                      size: 30,
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
