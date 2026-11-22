import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class ReactionGridGame extends StatefulWidget {
  const ReactionGridGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<ReactionGridGame> createState() => _State();
}

class _State extends State<ReactionGridGame> {
  bool _ready = true;
  int _target = 0;
  int _hits = 0;
  int _misses = 0;
  int _timeLeft = 30;
  Timer? _timer;
  final _rand = Random();
  final _start = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _target = _rand.nextInt(16);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _start.stop();
        final score = max(0, _hits * 10 - _misses * 5);
        final total = _hits + _misses;
        final acc = total == 0 ? 0.0 : _hits / total * 100;
        widget.onFinish(
          GameResult(
            score: score,
            maxScore: 300,
            accuracy: acc,
            xp: 10 + score ~/ 5,
            durationSec: 30,
            detailAr: 'إصابات: $_hits • أخطاء: $_misses',
          ),
        );
      }
    });
    setState(() {});
  }

  void _tap(int i) {
    if (i == _target) {
      HapticFeedback.lightImpact();
      _hits++;
      int next;
      do {
        next = _rand.nextInt(16);
      } while (next == _target);
      setState(() => _target = next);
    } else {
      HapticFeedback.mediumImpact();
      setState(() => _misses++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions: 'اضغط على الخلية المضيئة بأسرع ما يمكن. لديك 30 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  إصابات: $_hits  •  أخطاء: $_misses'),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 16,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                return Material(
                  color: i == _target ? const Color(0xFFF2A93B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(12),
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
