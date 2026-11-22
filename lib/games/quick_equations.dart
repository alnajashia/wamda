import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class QuickEquationsGame extends StatefulWidget {
  const QuickEquationsGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<QuickEquationsGame> createState() => _State();
}

class _State extends State<QuickEquationsGame> {
  bool _ready = true;
  String _eq = '';
  bool _isTrue = true;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _streak = 0;
  int _timeLeft = 60;
  Timer? _timer;
  final _rand = Random();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newEq() {
    final level = _correct ~/ 10;
    final maxN = 10 + level * 10;
    final ops = level >= 2 ? ['+', '-', '×'] : ['+', '-'];
    final op = ops[_rand.nextInt(ops.length)];
    final a = _rand.nextInt(maxN) + 1;
    final b = _rand.nextInt(maxN) + 1;
    int result;
    if (op == '+') {
      result = a + b;
    } else if (op == '-') {
      result = a - b;
    } else {
      result = a * b;
    }
    _isTrue = _rand.nextBool();
    final shown = _isTrue
        ? result
        : result + (_rand.nextBool() ? 1 : -1) * (1 + _rand.nextInt(5));
    _eq = '$a $op $b = $shown';
    setState(() {});
  }

  void _startGame() {
    _ready = false;
    _newEq();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        final acc = _total == 0 ? 0.0 : _correct / _total * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 300,
            accuracy: acc,
            xp: 10 + _score ~/ 5,
            durationSec: 60,
            detailAr: 'صحيح: $_correct من $_total',
          ),
        );
      }
    });
  }

  void _answer(bool v) {
    _total++;
    if (v == _isTrue) {
      HapticFeedback.lightImpact();
      _correct++;
      _streak++;
      _score += 10;
      if (_streak % 5 == 0) _score += 5;
    } else {
      HapticFeedback.mediumImpact();
      _streak = 0;
    }
    _newEq();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions: 'هل المعادلة صحيحة أم خاطئة؟ لديك 60 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  النقاط: $_score  •  سلسلة: $_streak'),
          const Spacer(),
          Text(
            _eq,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textDirection: TextDirection.ltr,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                  ),
                  onPressed: () => _answer(true),
                  child: const Text('صح'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                  ),
                  onPressed: () => _answer(false),
                  child: const Text('خطأ'),
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
