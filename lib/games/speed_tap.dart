import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SpeedTapGame extends StatefulWidget {
  const SpeedTapGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SpeedTapGame> createState() => _State();
}

enum _Phase { waiting, ready, result }

class _State extends State<SpeedTapGame> {
  bool _ready = true;
  _Phase _phase = _Phase.waiting;
  int _round = 0;
  final List<int> _times = [];
  int _falseStarts = 0;
  Timer? _timer;
  DateTime _greenAt = DateTime.now();
  String _msg = '';
  final _rand = Random();
  final _start = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _beginRound() {
    setState(() {
      _phase = _Phase.waiting;
      _msg = 'انتظر اللون الأخضر...';
    });
    final delay = 1500 + _rand.nextInt(2500);
    _timer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.ready;
        _greenAt = DateTime.now();
        _msg = 'اضغط الآن!';
      });
    });
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _beginRound();
  }

  void _tap() {
    if (_phase == _Phase.waiting) {
      _timer?.cancel();
      HapticFeedback.mediumImpact();
      _falseStarts++;
      _round++;
      setState(() {
        _phase = _Phase.result;
        _msg = 'مبكر جداً! انطلاقة خاطئة';
      });
      _afterRound();
    } else if (_phase == _Phase.ready) {
      HapticFeedback.lightImpact();
      final ms = DateTime.now().difference(_greenAt).inMilliseconds;
      _times.add(ms);
      _round++;
      setState(() {
        _phase = _Phase.result;
        _msg = 'زمن رد الفعل: $ms مللي ثانية';
      });
      _afterRound();
    }
  }

  void _afterRound() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_round >= 5) {
        _start.stop();
        final avg = _times.isEmpty
            ? 500
            : _times.reduce((a, b) => a + b) ~/ _times.length;
        final best = _times.isEmpty ? 0 : _times.reduce(min);
        final score = max(0, 500 - avg);
        widget.onFinish(
          GameResult(
            score: score,
            maxScore: 500,
            accuracy: _times.length / 5 * 100,
            xp: 10 + score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr:
                'المتوسط: $avg مللي ثانية • الأفضل: $best • انطلاقات خاطئة: $_falseStarts',
          ),
        );
      } else {
        _beginRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'انتظر حتى يصبح اللون أخضر ثم اضغط بأسرع ما يمكن. الضغط المبكر يلغي الجولة. 5 جولات.',
        onStart: _startGame,
      );
    }
    final bg = _phase == _Phase.ready
        ? Colors.green.shade600
        : (_phase == _Phase.waiting
              ? Colors.red.shade400
              : Colors.grey.shade300);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1} من 5'),
          const SizedBox(height: 16),
          Expanded(
            child: Material(
              color: bg,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: _phase == _Phase.result ? null : _tap,
                borderRadius: BorderRadius.circular(24),
                child: Center(
                  child: Text(
                    _msg,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
