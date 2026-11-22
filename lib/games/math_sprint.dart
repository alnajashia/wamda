import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class MathSprintGame extends StatefulWidget {
  const MathSprintGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MathSprintGame> createState() => _State();
}

class _State extends State<MathSprintGame> {
  bool _ready = true;
  String _q = '';
  int _answer = 0;
  List<int> _choices = [];
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _timeLeft = 60;
  Timer? _timer;
  final _rand = Random();

  int get _tier => min(3, 1 + _correct ~/ 8);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newQ() {
    final tier = _tier;
    int a, b, result;
    String op;
    if (tier == 1) {
      a = _rand.nextInt(20) + 1;
      b = _rand.nextInt(20) + 1;
      op = _rand.nextBool() ? '+' : '-';
      result = op == '+' ? a + b : a - b;
    } else if (tier == 2) {
      a = _rand.nextInt(50) + 1;
      b = _rand.nextInt(12) + 1;
      final ops = ['+', '-', '×'];
      op = ops[_rand.nextInt(3)];
      result = op == '+' ? a + b : (op == '-' ? a - b : a * b);
    } else {
      final ops = ['+', '-', '×', '÷'];
      op = ops[_rand.nextInt(4)];
      if (op == '÷') {
        b = _rand.nextInt(11) + 2;
        result = _rand.nextInt(12) + 1;
        a = b * result;
      } else if (op == '×') {
        a = _rand.nextInt(15) + 2;
        b = _rand.nextInt(12) + 2;
        result = a * b;
      } else {
        a = _rand.nextInt(100) + 1;
        b = _rand.nextInt(100) + 1;
        result = op == '+' ? a + b : a - b;
      }
    }
    _q = '$a $op $b = ؟';
    _answer = result;
    final set = <int>{result};
    while (set.length < 4) {
      set.add(result + (_rand.nextInt(11) - 5) * (1 + _rand.nextInt(3)));
    }
    _choices = set.toList()..shuffle(_rand);
    setState(() {});
  }

  void _startGame() {
    _ready = false;
    _newQ();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        final acc = _total == 0 ? 0.0 : _correct / _total * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 400,
            accuracy: acc,
            xp: 10 + _score ~/ 5,
            durationSec: 60,
            detailAr: 'صحيح: $_correct من $_total • المستوى: $_tier',
          ),
        );
      }
    });
  }

  void _choose(int v) {
    _total++;
    if (v == _answer) {
      HapticFeedback.lightImpact();
      _score += 10 * _tier;
      _correct++;
    } else {
      HapticFeedback.mediumImpact();
    }
    _newQ();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'حل المعادلة واختر الإجابة الصحيحة. لديك 60 ثانية والمستوى يرتفع كل 8 إجابات صحيحة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  النقاط: $_score  •  المستوى: $_tier'),
          const Spacer(),
          Text(
            _q,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textDirection: TextDirection.ltr,
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
                    onPressed: () => _choose(c),
                    child: Text('$c', style: const TextStyle(fontSize: 20)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
