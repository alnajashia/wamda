import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class BallRushGame extends StatefulWidget {
  const BallRushGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<BallRushGame> createState() => _State();
}

class _Ball {
  _Ball(this.lane, this.color, this.y);
  final int lane;
  final int color;
  double y; // 0 top .. 1 bottom (fraction of play height)
}

class _State extends State<BallRushGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
  ];
  static const _namesAr = ['برتقالي', 'أزرق', 'أخضر', 'أصفر'];
  static const _lanes = 4;
  static const _duration = 60;

  bool _ready = true;
  final List<_Ball> _balls = [];
  int _target = 0;
  int _score = 0;
  int _hits = 0;
  int _wrongs = 0;
  int _missed = 0;
  int _elapsedMs = 0;
  int _spawnCooldown = 0;
  Timer? _timer;
  final _rand = Random();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _timeLeft => max(0, _duration - _elapsedMs ~/ 1000);

  void _startGame() {
    _ready = false;
    _target = _rand.nextInt(4);
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) => _tick());
    setState(() {});
  }

  void _tick() {
    if (!mounted) return;
    _elapsedMs += 50;
    // Target color changes every 15 seconds.
    if (_elapsedMs % 15000 < 50 && _elapsedMs > 0) {
      var next = _rand.nextInt(4);
      if (next == _target) next = (next + 1) % 4;
      _target = next;
    }
    // Speed grows over time: 0.25 -> 0.65 of height per second.
    final speed = 0.25 + 0.4 * (_elapsedMs / (_duration * 1000));
    for (final b in _balls) {
      b.y += speed * 0.05;
    }
    _balls.removeWhere((b) {
      if (b.y > 1.05) {
        if (b.color == _target) _missed++;
        return true;
      }
      return false;
    });
    _spawnCooldown -= 50;
    if (_spawnCooldown <= 0) {
      _balls.add(_Ball(_rand.nextInt(_lanes), _rand.nextInt(4), -0.05));
      _spawnCooldown = 500 + _rand.nextInt(500);
    }
    if (_timeLeft <= 0) {
      _timer?.cancel();
      final total = _hits + _wrongs + _missed;
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: 1000,
          accuracy: total == 0 ? 0 : _hits / total * 100,
          xp: 10 + _score ~/ 10,
          durationSec: _duration,
          detailAr: 'كرات صحيحة: $_hits • خاطئة: $_wrongs • فاتتك: $_missed',
        ),
      );
      return;
    }
    setState(() {});
  }

  void _tapBall(_Ball b) {
    if (b.color == _target) {
      HapticFeedback.lightImpact();
      _hits++;
      _score += 15;
    } else {
      HapticFeedback.mediumImpact();
      _wrongs++;
      _score = max(0, _score - 10);
    }
    setState(() => _balls.remove(b));
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اضغط فقط على الكرات ذات اللون المطلوب قبل أن تصل إلى الأسفل. اللون المطلوب يتغير كل 15 ثانية والسرعة تزداد. لديك 60 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('الوقت: $_timeLeft ث  •  النتيجة: $_score  •  الهدف: '),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: _palette[_target], shape: BoxShape.circle),
              ),
              Text(' ${_namesAr[_target]}'),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final laneW = w / _lanes;
                const ballSize = 52.0;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    children: [
                      for (var l = 1; l < _lanes; l++)
                        Positioned(
                          left: laneW * l,
                          top: 0,
                          bottom: 0,
                          child: Container(width: 1, color: Colors.grey.shade200),
                        ),
                      for (final b in _balls)
                        Positioned(
                          left: b.lane * laneW + (laneW - ballSize) / 2,
                          top: b.y * (h - ballSize),
                          child: GestureDetector(
                            onTap: () => _tapBall(b),
                            child: Container(
                              width: ballSize,
                              height: ballSize,
                              decoration: BoxDecoration(
                                color: _palette[b.color],
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12, width: 2),
                              ),
                            ),
                          ),
                        ),
                    ],
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
