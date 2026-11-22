import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class ColoredDiscsGame extends StatefulWidget {
  const ColoredDiscsGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<ColoredDiscsGame> createState() => _State();
}

class _State extends State<ColoredDiscsGame> {
  static const _palette = [
    (Color(0xFFE4572E), 'برتقالي'),
    (Color(0xFF2563EB), 'أزرق'),
    (Color(0xFF0E7C6B), 'أخضر'),
    (Color(0xFFF2A93B), 'أصفر'),
    (Color(0xFF7C5CBF), 'بنفسجي'),
    (Color(0xFFD6336C), 'وردي'),
  ];
  static const _totalRounds = 10;

  bool _ready = true;
  int _round = 0;
  int _target = 0;
  List<int> _discs = [];
  final Set<int> _found = {};
  int _targetsTotal = 0;
  int _mistakes = 0;
  int _score = 0;
  int _roundTime = 12;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newRound() {
    _timer?.cancel();
    _target = _rand.nextInt(_palette.length);
    final count = 12 + _round * 2;
    _targetsTotal = 3 + _rand.nextInt(3);
    _discs = List.generate(count, (_) {
      int c;
      do {
        c = _rand.nextInt(_palette.length);
      } while (c == _target);
      return c;
    });
    final idx = <int>{};
    while (idx.length < _targetsTotal) {
      idx.add(_rand.nextInt(count));
    }
    for (final i in idx) {
      _discs[i] = _target;
    }
    _found.clear();
    _roundTime = max(7, 12 - _round ~/ 2);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _roundTime--);
      if (_roundTime <= 0) {
        t.cancel();
        _nextRound();
      }
    });
  }

  void _nextRound() {
    _round++;
    if (_round >= _totalRounds) {
      _timer?.cancel();
      _stopwatch.stop();
      final hits = _score ~/ 15;
      final taps = hits + _mistakes;
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: 800,
          accuracy: taps == 0 ? 0 : hits / taps * 100,
          xp: 10 + _score ~/ 10,
          durationSec: _stopwatch.elapsed.inSeconds,
          detailAr: 'أقراص صحيحة: $hits • أخطاء: $_mistakes',
        ),
      );
    } else {
      setState(_newRound);
    }
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _tap(int i) {
    if (_found.contains(i)) return;
    if (_discs[i] == _target) {
      HapticFeedback.lightImpact();
      _found.add(i);
      _score += 15;
      if (_found.length >= _targetsTotal) {
        _score += _roundTime * 2;
        _nextRound();
        return;
      }
    } else {
      HapticFeedback.mediumImpact();
      _mistakes++;
      _score = max(0, _score - 5);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اضغط على كل الأقراص ذات اللون المطلوب قبل انتهاء وقت الجولة. $_totalRounds جولات.',
        onStart: _startGame,
      );
    }
    final (color, name) = _palette[_target];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة ${_round + 1} من $_totalRounds  •  الوقت: $_roundTime ث  •  النتيجة: $_score',
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('اللون المطلوب: '),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              Text(' $name  •  وجدت ${_found.length} من $_targetsTotal'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _discs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                final found = _found.contains(i);
                return Material(
                  color: found ? Colors.grey.shade300 : _palette[_discs[i]].$1,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => _tap(i),
                    customBorder: const CircleBorder(),
                    child: found
                        ? const Icon(Icons.check, color: Colors.white)
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
