import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class NumberChallengeGame extends StatefulWidget {
  const NumberChallengeGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<NumberChallengeGame> createState() => _State();
}

class _State extends State<NumberChallengeGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 12;
  List<String> _shown = []; // sequence tokens, '?' for missing
  List<int> _options = [];
  int _answer = 0;
  int? _picked;
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _start = Stopwatch();

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  /// Generates a sequence of 5 terms; returns (terms, answerIndex).
  (List<int>, int) _generate() {
    final level = (_round - 1) ~/ 4; // 0,1,2
    final types = level == 0
        ? ['add', 'mul']
        : level == 1
            ? ['add', 'mul', 'alt', 'square']
            : ['mul', 'alt', 'square', 'fib', 'addGrow'];
    final type = types[_rand.nextInt(types.length)];
    final seq = <int>[];
    switch (type) {
      case 'add':
        final start = 2 + _rand.nextInt(20);
        final step = 2 + _rand.nextInt(9);
        for (var i = 0; i < 5; i++) {
          seq.add(start + step * i);
        }
      case 'mul':
        final start = 1 + _rand.nextInt(5);
        final f = 2 + _rand.nextInt(2); // 2 or 3
        var v = start;
        for (var i = 0; i < 5; i++) {
          seq.add(v);
          v *= f;
        }
      case 'alt': // +a, ×b alternating
        final a = 1 + _rand.nextInt(6);
        final b = 2;
        var v = 1 + _rand.nextInt(6);
        for (var i = 0; i < 5; i++) {
          seq.add(v);
          v = i.isEven ? v + a : v * b;
        }
      case 'square':
        final start = 1 + _rand.nextInt(4);
        for (var i = 0; i < 5; i++) {
          seq.add((start + i) * (start + i));
        }
      case 'fib':
        var a = 1 + _rand.nextInt(5);
        var b = a + _rand.nextInt(5);
        for (var i = 0; i < 5; i++) {
          seq.add(a);
          final t = a + b;
          a = b;
          b = t;
        }
      default: // addGrow: +1, +2, +3...
        var v = 1 + _rand.nextInt(10);
        for (var i = 0; i < 5; i++) {
          seq.add(v);
          v += i + 1;
        }
    }
    // missing position: last term usually, sometimes middle
    final missing = _rand.nextInt(4) == 0 ? 1 + _rand.nextInt(3) : 4;
    return (seq, missing);
  }

  void _nextRound() {
    _round++;
    final (seq, missing) = _generate();
    _answer = seq[missing];
    _shown = [
      for (var i = 0; i < seq.length; i++) i == missing ? '؟' : '${seq[i]}',
    ];
    final opts = <int>{_answer};
    var guard = 0;
    while (opts.length < 4 && guard++ < 50) {
      final delta = (_rand.nextInt(9) - 4) * (1 + _rand.nextInt(3));
      final v = _answer + delta;
      if (v > 0 && v != _answer) opts.add(v);
    }
    _options = opts.toList()..shuffle(_rand);
    _picked = null;
    setState(() {});
  }

  void _pick(int v) {
    if (_picked != null) return;
    setState(() => _picked = v);
    if (v == _answer) {
      _correct++;
      _score += 15;
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _rounds * 15,
            accuracy: _correct / _rounds * 100,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'صحيح: $_correct من $_rounds',
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
            'اكتشف نمط المتتالية واختر الرقم الناقص. الأنماط: جمع، ضرب، تناوب، مربعات، فيبوناتشي. 12 جولة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة $_round من $_rounds  •  النقاط: $_score',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                for (final t in _shown)
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t == '؟' ? const Color(0xFFF2A93B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14213D),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('ما الرقم الناقص؟'),
          const Spacer(),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.4,
            ),
            itemBuilder: (_, i) {
              final v = _options[i];
              Color bg = Colors.white;
              if (_picked != null && v == _answer) bg = Colors.green.shade200;
              if (_picked == v && v != _answer) bg = Colors.red.shade200;
              return Material(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => _pick(v),
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: Text(
                      '$v',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14213D),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
