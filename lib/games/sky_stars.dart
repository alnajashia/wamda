import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SkyStarsGame extends StatefulWidget {
  const SkyStarsGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SkyStarsGame> createState() => _State();
}

class _State extends State<SkyStarsGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 8;
  List<Offset> _stars = []; // normalized 0..1
  List<Offset> _taps = [];
  List<bool> _hit = [];
  bool _showing = false;
  int _score = 0;
  int _hits = 0;
  int _totalStars = 0;
  final _rand = Random();
  final _start = Stopwatch();

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  void _nextRound() {
    _round++;
    final count = 2 + _round; // 3..10 -> cap 8
    final n = count > 8 ? 8 : count;
    _stars = [];
    while (_stars.length < n) {
      final p = Offset(
        0.08 + _rand.nextDouble() * 0.84,
        0.08 + _rand.nextDouble() * 0.84,
      );
      if (_stars.every((s) => (s - p).distance > 0.16)) _stars.add(p);
    }
    _taps = [];
    _hit = List.filled(n, false);
    _totalStars += n;
    setState(() => _showing = true);
    final showMs = 4000 - _round * 250; // shrinks each round
    Future.delayed(Duration(milliseconds: showMs < 1800 ? 1800 : showMs), () {
      if (mounted) setState(() => _showing = false);
    });
  }

  void _tap(Offset local, Size size) {
    if (_showing) return;
    final norm = Offset(local.dx / size.width, local.dy / size.height);
    // nearest unhit star within tolerance
    int best = -1;
    double bestDist = 1e9;
    for (var i = 0; i < _stars.length; i++) {
      if (_hit[i]) continue;
      final d = (_stars[i] - norm).distance;
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }
    setState(() => _taps.add(norm));
    if (best >= 0 && bestDist <= 0.09) {
      _hit[best] = true;
      _hits++;
      final precision = ((0.09 - bestDist) / 0.09 * 10).round();
      _score += 10 + precision;
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    if (_hit.every((h) => h) || _taps.length >= _stars.length + 2) {
      _endRound();
    }
  }

  void _endRound() {
    setState(() => _showing = true); // reveal stars briefly
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        final acc = _totalStars == 0 ? 0.0 : _hits / _totalStars * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _totalStars * 20,
            accuracy: acc,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'أصبت $_hits نجمة من $_totalStars',
          ),
        );
      } else {
        _nextRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'احفظ أماكن النجوم في السماء، ثم اضغط عليها بعد اختفائها. 8 جولات، والنجوم تزداد والوقت يقل.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة $_round من $_rounds  •  النقاط: $_score',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _showing
                ? 'احفظ أماكن النجوم...'
                : 'اضغط حيث كانت النجوم (${_hit.where((h) => h).length}/${_stars.length})',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final size = Size(c.maxWidth, c.maxHeight);
                return GestureDetector(
                  onTapDown: (d) => _tap(d.localPosition, size),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF14213D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        if (_showing)
                          for (final s in _stars)
                            Positioned(
                              left: s.dx * size.width - 14,
                              top: s.dy * size.height - 14,
                              child: const Icon(
                                Icons.star,
                                color: Color(0xFFF2A93B),
                                size: 28,
                              ),
                            ),
                        for (var i = 0; i < _stars.length; i++)
                          if (_hit[i] && !_showing)
                            Positioned(
                              left: _stars[i].dx * size.width - 14,
                              top: _stars[i].dy * size.height - 14,
                              child: const Icon(
                                Icons.star,
                                color: Color(0xFF0E7C6B),
                                size: 28,
                              ),
                            ),
                        for (final t in _taps)
                          Positioned(
                            left: t.dx * size.width - 5,
                            top: t.dy * size.height - 5,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.white70,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
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
