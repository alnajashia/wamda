import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class ShapeSortGame extends StatefulWidget {
  const ShapeSortGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<ShapeSortGame> createState() => _State();
}

class _State extends State<ShapeSortGame> {
  static const _shapes = [
    (Icons.circle, 'دائرة'),
    (Icons.square, 'مربع'),
    (Icons.change_history, 'مثلث'),
    (Icons.star, 'نجمة'),
  ];
  static const _colors = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
  ];

  bool _ready = true;
  int _current = 0;
  Color _currentColor = _colors[0];
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  int _timeLeft = 60;
  int? _lastBin;
  bool _lastGood = false;
  Timer? _timer;
  Timer? _spawnTimer;
  final _rand = Random();

  @override
  void dispose() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  int get _spawnMs => max(900, 2200 - _correct * 60);

  void _nextShape() {
    _spawnTimer?.cancel();
    setState(() {
      _current = _rand.nextInt(_shapes.length);
      _currentColor = _colors[_rand.nextInt(_colors.length)];
      _lastBin = null;
    });
    _spawnTimer = Timer(Duration(milliseconds: _spawnMs), () {
      if (!mounted || _timeLeft <= 0) return;
      _wrong++;
      _nextShape();
    });
  }

  void _startGame() {
    _ready = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _spawnTimer?.cancel();
        final total = _correct + _wrong;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 800,
            accuracy: total == 0 ? 0 : _correct / total * 100,
            xp: 10 + _score ~/ 10,
            durationSec: 60,
            detailAr: 'فرز صحيح: $_correct • أخطاء/فوات: $_wrong',
          ),
        );
      }
    });
    _nextShape();
    setState(() {});
  }

  void _pickBin(int bin) {
    final good = bin == _current;
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
      _lastBin = bin;
      _lastGood = good;
    });
    Future.delayed(const Duration(milliseconds: 220), () {
      if (!mounted || _timeLeft <= 0) return;
      _nextShape();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'صنّف الشكل الظاهر بالضغط على صندوقه الصحيح بأسرع ما يمكن. لديك 60 ثانية والسرعة تزداد.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الوقت: $_timeLeft ث  •  النتيجة: $_score  •  صح: $_correct'),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Icon(
                _shapes[_current].$1,
                color: _currentColor,
                size: 120,
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < _shapes.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Material(
                      color: _lastBin == i
                          ? (_lastGood
                                ? Colors.green.shade100
                                : Colors.red.shade100)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => _pickBin(i),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Icon(
                                _shapes[i].$1,
                                color: WamdaColors.ink,
                                size: 34,
                              ),
                              const SizedBox(height: 4),
                              Text(_shapes[i].$2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
