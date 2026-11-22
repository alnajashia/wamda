import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class QuickCompareGame extends StatefulWidget {
  const QuickCompareGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<QuickCompareGame> createState() => _State();
}

class _State extends State<QuickCompareGame> {
  bool _ready = true;
  int _left = 0;
  int _right = 0;
  bool _dotsMode = false;
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  int _timeLeft = 60;
  int? _picked;
  DateTime _shownAt = DateTime.now();
  Timer? _timer;
  final _rand = Random();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newRound() {
    _dotsMode = _rand.nextBool();
    final level = min(6, _correct ~/ 4);
    final gap = max(1, 12 - level * 2);
    final base = 5 + _rand.nextInt(30);
    final delta = 1 + _rand.nextInt(gap);
    if (_rand.nextBool()) {
      _left = base;
      _right = base + delta;
    } else {
      _left = base + delta;
      _right = base;
    }
    _picked = null;
    _shownAt = DateTime.now();
  }

  void _startGame() {
    _ready = false;
    _newRound();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        final total = _correct + _wrong;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 800,
            accuracy: total == 0 ? 0 : _correct / total * 100,
            xp: 10 + _score ~/ 10,
            durationSec: 60,
            detailAr: 'إجابات صحيحة: $_correct • أخطاء: $_wrong',
          ),
        );
      }
    });
    setState(() {});
  }

  void _pick(bool left) {
    if (_picked != null) return;
    final good = left ? _left > _right : _right > _left;
    final ms = DateTime.now().difference(_shownAt).inMilliseconds;
    if (good) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 15 + max(0, 10 - ms ~/ 300);
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
      _score = max(0, _score - 5);
    }
    setState(() => _picked = left ? 0 : 1);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || _timeLeft <= 0) return;
      setState(_newRound);
    });
  }

  Widget _side(int value, bool left) {
    final bigger = left ? _left > _right : _right > _left;
    Color bg = Colors.white;
    if (_picked != null && bigger) bg = Colors.green.shade100;
    if (_picked == (left ? 0 : 1) && !bigger) bg = Colors.red.shade100;
    return Expanded(
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _pick(left),
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: _dotsMode
                ? Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (var i = 0; i < value; i++)
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: WamdaColors.teal,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  )
                : Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: WamdaColors.ink,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions: 'اضغط على الجانب الأكبر: العدد الأكبر أو النقاط الأكثر. لديك 60 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  النتيجة: $_score  •  صح: $_correct'),
          const SizedBox(height: 12),
          Text(
            _dotsMode ? 'أي جانب فيه نقاط أكثر؟' : 'أي عدد أكبر؟',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                _side(_left, true),
                const SizedBox(width: 12),
                _side(_right, false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
