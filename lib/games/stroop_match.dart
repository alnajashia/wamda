import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class _ColorDef {
  const _ColorDef(this.name, this.color);
  final String name;
  final Color color;
}

const _colors = [
  _ColorDef('أحمر', Color(0xFFE53935)),
  _ColorDef('أزرق', Color(0xFF1E88E5)),
  _ColorDef('أخضر', Color(0xFF43A047)),
  _ColorDef('أصفر', Color(0xFFF9A825)),
  _ColorDef('بنفسجي', Color(0xFF8E24AA)),
];

class StroopMatchGame extends StatefulWidget {
  const StroopMatchGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<StroopMatchGame> createState() => _State();
}

class _State extends State<StroopMatchGame> {
  bool _ready = true;
  int _round = 0;
  int _wordIdx = 0;
  int _inkIdx = 0;
  List<int> _choices = [];
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _start = Stopwatch();
  DateTime _roundStart = DateTime.now();

  bool get _inkMode => (_round ~/ 5) % 2 == 0;
  int get _level => min(5, 1 + _round ~/ 5);

  void _newRound() {
    _wordIdx = _rand.nextInt(5);
    if (_level > 2) {
      do {
        _inkIdx = _rand.nextInt(5);
      } while (_inkIdx == _wordIdx);
    } else {
      _inkIdx = _rand.nextInt(5);
    }
    final answer = _inkMode ? _inkIdx : _wordIdx;
    final set = <int>{answer};
    while (set.length < 4) {
      set.add(_rand.nextInt(5));
    }
    _choices = set.toList()..shuffle(_rand);
    _roundStart = DateTime.now();
    setState(() {});
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _newRound();
  }

  void _choose(int idx) {
    final answer = _inkMode ? _inkIdx : _wordIdx;
    final reaction =
        DateTime.now().difference(_roundStart).inMilliseconds / 1000.0;
    if (idx == answer) {
      HapticFeedback.lightImpact();
      _correct++;
      final bonus = 5 - reaction.floor();
      _score += 10 + (bonus > 0 ? bonus : 0) + _level;
    } else {
      HapticFeedback.mediumImpact();
    }
    _round++;
    if (_round >= 15) {
      _start.stop();
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: 300,
          accuracy: _correct / 15 * 100,
          xp: 10 + _score ~/ 5,
          durationSec: _start.elapsed.inSeconds,
          detailAr: 'أجبت بشكل صحيح على $_correct من 15',
        ),
      );
    } else {
      _newRound();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اختر اللون المطلوب: أحياناً لون الحبر وأحياناً الكلمة المكتوبة. انتبه للتعليمات أعلى الشاشة. 15 جولة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة ${_round + 1} من 15  •  النقاط: $_score  •  المستوى: $_level',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0E7C6B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _inkMode ? 'اختر لون الحبر' : 'اختر الكلمة المكتوبة',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _colors[_wordIdx].name,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: _colors[_inkIdx].color,
            ),
          ),
          const Spacer(),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            children: [
              for (final c in _choices)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _colors[c].color,
                    ),
                    onPressed: () => _choose(c),
                    child: Text(_colors[c].name),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
