import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class MentalSwitchGame extends StatefulWidget {
  const MentalSwitchGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MentalSwitchGame> createState() => _State();
}

class _State extends State<MentalSwitchGame> {
  static const _colors = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
  ];
  static const _colorNames = ['برتقالي', 'أزرق', 'أخضر', 'أصفر'];
  static const _shapes = [Icons.circle, Icons.square, Icons.change_history, Icons.star];
  static const _shapeNames = ['دائرة', 'مربع', 'مثلث', 'نجمة'];
  static const _rules = ['اللون', 'الشكل', 'الرقم'];
  static const _duration = 60;

  bool _ready = true;
  int _rule = 0; // 0 color, 1 shape, 2 number parity
  int _trialsOnRule = 0;
  int _stimColor = 0;
  int _stimShape = 0;
  int _stimNumber = 1;
  int _score = 0;
  int _correct = 0;
  int _wrong = 0;
  int _switchCorrect = 0;
  int _switchTotal = 0;
  bool _justSwitched = false;
  int _timeLeft = _duration;
  bool _flash = false;
  bool _flashGood = false;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _rule = _rand.nextInt(3);
    _trialsOnRule = 0;
    _newStimulus();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _stopwatch.stop();
        final total = _correct + _wrong;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 1000,
            accuracy: total == 0 ? 0 : _correct / total * 100,
            xp: 10 + _score ~/ 10,
            durationSec: _duration,
            detailAr:
                'صحيحة: $_correct • خاطئة: $_wrong • بعد تبديل القاعدة: $_switchCorrect/$_switchTotal',
          ),
        );
      }
    });
    setState(() {});
  }

  void _newStimulus() {
    _stimColor = _rand.nextInt(4);
    _stimShape = _rand.nextInt(4);
    _stimNumber = 1 + _rand.nextInt(9);
  }

  void _answer(int choice) {
    if (_flash) return;
    final bool good;
    switch (_rule) {
      case 0:
        good = choice == _stimColor;
      case 1:
        good = choice == _stimShape;
      default:
        good = choice == (_stimNumber.isEven ? 1 : 0); // 1 even, 0 odd
    }
    if (_justSwitched) {
      _switchTotal++;
      if (good) _switchCorrect++;
    }
    if (good) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 15;
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
      _score = max(0, _score - 5);
    }
    setState(() {
      _flash = true;
      _flashGood = good;
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || _timeLeft <= 0) return;
      setState(() {
        _flash = false;
        _trialsOnRule++;
        _justSwitched = false;
        if (_trialsOnRule >= 3 + _rand.nextInt(3)) {
          var next = _rand.nextInt(3);
          if (next == _rule) next = (next + 1) % 3;
          _rule = next;
          _trialsOnRule = 0;
          _justSwitched = true;
        }
        _newStimulus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'القاعدة تتبدل! احكم حسب المطلوب في الأعلى: اللون أو الشكل أو الرقم (زوجي/فردي). اضغط الزر الصحيح بسرعة. لديك 60 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  النتيجة: $_score  •  صح: $_correct'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _justSwitched ? const Color(0xFFF2A93B) : WamdaColors.teal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'احكم حسب: ${_rules[_rule]}${_justSwitched ? ' (تبدّلت!)' : ''}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: _flash
                      ? (_flashGood ? Colors.green.shade100 : Colors.red.shade100)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(_shapes[_stimShape], size: 110, color: _colors[_stimColor]),
                    Text(
                      '$_stimNumber',
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_rule == 0)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                for (var c = 0; c < 4; c++)
                  InkWell(
                    onTap: () => _answer(c),
                    child: Container(
                      width: 72,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _colors[c],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(_colorNames[c], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            )
          else if (_rule == 1)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                for (var s = 0; s < 4; s++)
                  InkWell(
                    onTap: () => _answer(s),
                    child: Container(
                      width: 72,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_shapes[s], size: 24),
                          Text(_shapeNames[s], style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => _answer(0),
                  child: const Text('فردي'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () => _answer(1),
                  child: const Text('زوجي'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
