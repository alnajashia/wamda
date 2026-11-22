import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class NBackGame extends StatefulWidget {
  const NBackGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<NBackGame> createState() => _State();
}

class _State extends State<NBackGame> {
  bool _ready = true;
  int _n = 2;
  final List<int> _seq = [];
  int _pos = -1;
  int _trial = 0;
  int _hits = 0;
  int _falseAlarms = 0;
  int _correctRejections = 0;
  int _misses = 0;
  bool _pressed = false;
  Timer? _timer;
  final _rand = Random();
  final _start = Stopwatch();

  int get _totalTrials => 20 + _n;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _judgePrevious() {
    if (_trial <= _n) return;
    final isMatch = _seq[_trial - 1] == _seq[_trial - 1 - _n];
    if (isMatch && _pressed) {
      _hits++;
    } else if (isMatch && !_pressed) {
      _misses++;
    } else if (!isMatch && _pressed) {
      _falseAlarms++;
    } else {
      _correctRejections++;
    }
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _seq.clear();
    for (var i = 0; i < _totalTrials; i++) {
      if (i >= _n && _rand.nextDouble() < 0.3) {
        _seq.add(_seq[i - _n]);
      } else {
        _seq.add(_rand.nextInt(9));
      }
    }
    _trial = 0;
    _nextStimulus();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      _judgePrevious();
      if (_trial >= _totalTrials) {
        _timer?.cancel();
        _start.stop();
        final score = max(0, _hits * 15 - _falseAlarms * 10);
        final judgments = _hits + _misses + _falseAlarms + _correctRejections;
        final acc = judgments == 0
            ? 0.0
            : (_hits + _correctRejections) / judgments * 100;
        widget.onFinish(
          GameResult(
            score: score,
            maxScore: 150,
            accuracy: acc,
            xp: 15 + score ~/ 5,
            durationSec: _start.elapsed.inSeconds,
            detailAr:
                'إصابات: $_hits • إنذارات كاذبة: $_falseAlarms • فائتة: $_misses',
          ),
        );
        return;
      }
      _nextStimulus();
    });
    setState(() {});
  }

  void _nextStimulus() {
    setState(() {
      _pos = _seq[_trial];
      _trial++;
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'ستظهر خلية مضيئة كل ثانيتين. اضغط "تطابق" إذا كان موقعها يطابق الموقع قبل N خطوات.',
        onStart: _startGame,
        extra: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final n in [1, 2, 3])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text('N = $n'),
                  selected: _n == n,
                  onSelected: (_) => setState(() => _n = n),
                ),
              ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'N = $_n  •  المحاولة $_trial من $_totalTrials  •  إصابات: $_hits',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                return Material(
                  color: i == _pos ? const Color(0xFF0E7C6B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() => _pressed = true);
            },
            child: Text(_pressed ? 'تم التسجيل ✓' : 'تطابق'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
