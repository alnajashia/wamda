import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class MatchingSquaresGame extends StatefulWidget {
  const MatchingSquaresGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MatchingSquaresGame> createState() => _State();
}

class _Pattern {
  _Pattern(this.shape, this.color, this.dots, this.turns);
  final int shape;
  final Color color;
  final int dots;
  final double turns;
  bool sameAs(_Pattern o) =>
      shape == o.shape && color == o.color && dots == o.dots && turns == o.turns;
}

class _State extends State<MatchingSquaresGame> {
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
  static const _totalRounds = 10;

  bool _ready = true;
  int _round = 0;
  List<_Pattern> _cells = [];
  int _pairA = 0;
  int _pairB = 1;
  final Set<int> _picked = {};
  int _mistakes = 0;
  int _score = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  int get _gridN => _round < 4 ? 3 : 4;

  _Pattern _randomPattern() => _Pattern(
    _rand.nextInt(_shapes.length),
    _colors[_rand.nextInt(_colors.length)],
    _rand.nextInt(4),
    _rand.nextInt(4) * 0.25,
  );

  void _newRound() {
    final n = _gridN * _gridN;
    final pair = _randomPattern();
    _cells = [pair];
    while (_cells.length < n - 1) {
      final p = _randomPattern();
      if (_cells.any((c) => c.sameAs(p))) continue;
      _cells.add(p);
    }
    _cells.add(pair);
    _cells.shuffle(_rand);
    _pairA = _cells.indexOf(pair);
    _pairB = _cells.lastIndexOf(pair);
    _picked.clear();
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _tap(int i) {
    if (_picked.contains(i)) {
      setState(() => _picked.remove(i));
      return;
    }
    _picked.add(i);
    if (_picked.length == 2) {
      final ok = _picked.contains(_pairA) && _picked.contains(_pairB);
      if (ok) {
        HapticFeedback.lightImpact();
        _score += 30;
        _round++;
        if (_round >= _totalRounds) {
          _stopwatch.stop();
          final taps = _totalRounds * 2 + _mistakes * 2;
          widget.onFinish(
            GameResult(
              score: _score,
              maxScore: 300,
              accuracy: taps == 0 ? 100 : _totalRounds * 2 / taps * 100,
              xp: 10 + _score ~/ 10,
              durationSec: _stopwatch.elapsed.inSeconds,
              detailAr: 'أكملت $_totalRounds جولات • محاولات خاطئة: $_mistakes',
            ),
          );
          return;
        }
        setState(_newRound);
        return;
      } else {
        HapticFeedback.mediumImpact();
        _mistakes++;
        _score = max(0, _score - 5);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          setState(_picked.clear);
        });
      }
    }
    setState(() {});
  }

  Widget _patternView(_Pattern p) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransition(
          turns: AlwaysStoppedAnimation(p.turns),
          child: Icon(_shapes[p.shape], color: p.color, size: 30),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var d = 0; d < p.dots; d++)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: p.color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'مربعان فقط متطابقان تماماً (الشكل واللون والنقاط والاتجاه). اضغط عليهما معاً. $_totalRounds جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1} من $_totalRounds  •  النتيجة: $_score'),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _cells.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridN,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                final picked = _picked.contains(i);
                return Material(
                  color: picked ? Colors.amber.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(12),
                    child: _patternView(_cells[i]),
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
