import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SpeedStepsGame extends StatefulWidget {
  const SpeedStepsGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SpeedStepsGame> createState() => _State();
}

class _State extends State<SpeedStepsGame> {
  static const _n = 5;
  bool _ready = true;
  int _start = 12;
  List<int> _dirs = []; // 0 up, 1 down, 2 left, 3 right
  int _target = 12;
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  int _timeLeft = 80;
  int? _flashCell;
  bool _flashGood = false;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  static const _icons = [
    Icons.arrow_upward,
    Icons.arrow_downward,
    Icons.arrow_back,
    Icons.arrow_forward,
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _pathLen => min(10, 3 + _correct ~/ 3);

  void _newPath() {
    var r = _rand.nextInt(_n);
    var c = _rand.nextInt(_n);
    _start = r * _n + c;
    _dirs = [];
    var guard = 0;
    while (_dirs.length < _pathLen && guard++ < 200) {
      final d = _rand.nextInt(4);
      var nr = r, nc = c;
      if (d == 0) nr--;
      if (d == 1) nr++;
      if (d == 2) nc--;
      if (d == 3) nc++;
      if (nr < 0 || nr >= _n || nc < 0 || nc >= _n) continue;
      r = nr;
      c = nc;
      _dirs.add(d);
    }
    _target = r * _n + c;
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _newPath();
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
            durationSec: 80,
            detailAr: 'مسارات صحيحة: $_correct • أخطاء: $_wrong',
          ),
        );
      }
    });
    setState(() {});
  }

  void _tap(int i) {
    if (_flashCell != null) return;
    final good = i == _target;
    if (good) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 20 + _pathLen * 5;
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
      _score = max(0, _score - 10);
      _timeLeft = max(0, _timeLeft - 2);
    }
    setState(() {
      _flashCell = i;
      _flashGood = good;
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() => _flashCell = null);
      if (_timeLeft > 0) setState(_newPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'تتبع الأسهم ذهنياً من الخلية المميزة واضغط على الخلية النهائية. لديك 80 ثانية، والخطأ يخصم ثانيتين.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  النتيجة: $_score  •  صح: $_correct'),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              for (final d in _dirs)
                Icon(_icons[d], color: WamdaColors.teal, size: 26),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _n * _n,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _n,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (_, i) {
                Color bg = Colors.white;
                if (i == _start) bg = WamdaColors.amber;
                if (_flashCell == i) {
                  bg = _flashGood ? Colors.green.shade500 : Colors.red.shade400;
                }
                return Material(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(10),
                    child: i == _start
                        ? const Icon(Icons.flag, color: Colors.white)
                        : null,
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
