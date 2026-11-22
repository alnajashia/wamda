import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SumEstimateGame extends StatefulWidget {
  const SumEstimateGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SumEstimateGame> createState() => _State();
}

class _State extends State<SumEstimateGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 12;
  List<Offset> _left = [];
  List<Offset> _right = [];
  int _leftCount = 0;
  int _rightCount = 0;
  bool _showing = false;
  bool? _lastCorrect;
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _start = Stopwatch();

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  List<Offset> _cloud(int n) {
    final pts = <Offset>[];
    var guard = 0;
    while (pts.length < n && guard++ < 2000) {
      final p = Offset(
        0.06 + _rand.nextDouble() * 0.88,
        0.06 + _rand.nextDouble() * 0.88,
      );
      if (pts.every((q) => (q - p).distance > 0.09)) pts.add(p);
    }
    return pts;
  }

  void _nextRound() {
    _round++;
    // base quantity grows, difference ratio shrinks
    final base = 6 + _round * 2; // 8..30
    final ratio = 1.6 - _round * 0.05; // 1.55 .. 1.0
    final diff = max(1, (base * (ratio - 1)).round());
    final biggerFirst = _rand.nextBool();
    _leftCount = biggerFirst ? base + diff : base;
    _rightCount = biggerFirst ? base : base + diff;
    _left = _cloud(_leftCount);
    _right = _cloud(_rightCount);
    _lastCorrect = null;
    setState(() => _showing = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showing = false);
    });
  }

  void _answer(bool leftBigger) {
    if (_showing || _lastCorrect != null) return;
    final ok = leftBigger == (_leftCount > _rightCount);
    if (ok) {
      _correct++;
      _score += 15;
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    setState(() => _lastCorrect = ok);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _rounds * 15,
            accuracy: _correct / _rounds * 100,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'صحيح: $_correct من $_rounds',
          ),
        );
      } else {
        _nextRound();
      }
    });
  }

  Widget _panel(List<Offset> dots, Color color, VoidCallback? onTap, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Stack(
            children: [
              if (_showing)
                for (final p in dots)
                  Positioned(
                    left: p.dx * 150,
                    top: p.dy * 190,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  )
              else
                Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14213D),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'ستظهر مجموعتا نقاط لثانية ونصف فقط. خمّن أيهما أكثر دون عدّ! 12 جولة والفرق يصغر تدريجياً.',
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
          const SizedBox(height: 12),
          Text(_showing ? 'انظر بسرعة...' : 'أي مجموعة كانت أكبر؟ اضغط عليها'),
          const SizedBox(height: 16),
          Row(
            children: [
              _panel(_left, const Color(0xFF2563EB), () => _answer(true), 'الأولى'),
              const SizedBox(width: 16),
              _panel(_right, const Color(0xFFE4572E), () => _answer(false), 'الثانية'),
            ],
          ),
          const SizedBox(height: 20),
          if (_lastCorrect != null)
            Text(
              _lastCorrect!
                  ? 'صحيح! ($_leftCount مقابل $_rightCount)'
                  : 'خطأ! كانت $_leftCount مقابل $_rightCount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _lastCorrect! ? Colors.green.shade700 : Colors.red.shade600,
              ),
            ),
        ],
      ),
    );
  }
}
