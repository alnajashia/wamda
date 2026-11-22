import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class FlankerTaskGame extends StatefulWidget {
  const FlankerTaskGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<FlankerTaskGame> createState() => _State();
}

class _State extends State<FlankerTaskGame> {
  bool _ready = true;
  int _trial = 0;
  bool _centerLeft = true;
  bool _congruent = true;
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _start = Stopwatch();
  DateTime _trialStart = DateTime.now();

  void _newTrial() {
    _centerLeft = _rand.nextBool();
    _congruent = _rand.nextBool();
    _trialStart = DateTime.now();
    setState(() {});
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _newTrial();
  }

  void _answer(bool left) {
    final reaction =
        DateTime.now().difference(_trialStart).inMilliseconds / 1000.0;
    if (left == _centerLeft) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 10 + max(0, 5 - reaction.floor());
    } else {
      HapticFeedback.mediumImpact();
    }
    _trial++;
    if (_trial >= 20) {
      _start.stop();
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: 300,
          accuracy: _correct / 20 * 100,
          xp: 10 + _score ~/ 5,
          durationSec: _start.elapsed.inSeconds,
          detailAr: 'أجبت بشكل صحيح على $_correct من 20',
        ),
      );
    } else {
      _newTrial();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'انظر إلى السهم الأوسط فقط واضغط اتجاهه. تجاهل الأسهم الجانبية. 20 محاولة.',
        onStart: _startGame,
      );
    }
    final flankLeft = _congruent ? _centerLeft : !_centerLeft;
    Widget arrow(bool left, bool center) => Icon(
      left ? Icons.arrow_back : Icons.arrow_forward,
      size: center ? 64 : 48,
      color: center ? const Color(0xFF0E7C6B) : Colors.grey.shade600,
    );
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('المحاولة ${_trial + 1} من 20  •  النقاط: $_score'),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              arrow(flankLeft, false),
              arrow(flankLeft, false),
              arrow(_centerLeft, true),
              arrow(flankLeft, false),
              arrow(flankLeft, false),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => _answer(true),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 8),
                      Text('يسار'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => _answer(false),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('يمين'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
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
