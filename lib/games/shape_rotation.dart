import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class ShapeRotationGame extends StatefulWidget {
  const ShapeRotationGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<ShapeRotationGame> createState() => _State();
}

class _State extends State<ShapeRotationGame> {
  // Asymmetric polyominoes as (row,col) cell sets.
  static const _shapes = <List<(int, int)>>[
    [(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)], // L
    [(0, 0), (0, 1), (1, 1), (1, 2), (2, 2)], // stair
    [(0, 1), (1, 0), (1, 1), (1, 2), (2, 1), (2, 2)], // T-ish with tail
    [(0, 0), (1, 0), (1, 1), (2, 1), (3, 1)], // zig
    [(0, 0), (0, 1), (0, 2), (1, 2), (2, 2), (2, 1)], // hook
    [(0, 2), (1, 0), (1, 1), (1, 2), (2, 0)], // irregular
  ];
  static const _colors = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFF7C5CBF),
  ];
  static const _rounds = 12;

  bool _ready = true;
  int _round = 0;
  List<(int, int)> _target = [];
  List<List<(int, int)>> _options = [];
  int _answerIdx = 0;
  int? _picked;
  Color _color = _colors[0];
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _correct = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  List<(int, int)> _normalize(List<(int, int)> cells) {
    final minR = cells.map((c) => c.$1).reduce(min);
    final minC = cells.map((c) => c.$2).reduce(min);
    return [for (final c in cells) (c.$1 - minR, c.$2 - minC)];
  }

  List<(int, int)> _rotate(List<(int, int)> cells, int times) {
    var out = List.of(cells);
    for (var t = 0; t < times; t++) {
      out = [for (final c in out) (c.$2, -c.$1)];
    }
    return _normalize(out);
  }

  List<(int, int)> _mirror(List<(int, int)> cells) =>
      _normalize([for (final c in cells) (c.$1, -c.$2)]);

  String _key(List<(int, int)> cells) {
    final s = _normalize(cells).map((c) => '${c.$1},${c.$2}').toList()..sort();
    return s.join(';');
  }

  bool _sameShape(List<(int, int)> a, List<(int, int)> b) {
    final ka = _key(a);
    for (var t = 0; t < 4; t++) {
      if (_key(_rotate(b, t)) == ka) return true;
    }
    return false;
  }

  void _newRound() {
    final base = _shapes[_rand.nextInt(_shapes.length)];
    _target = _normalize(base);
    _color = _colors[_rand.nextInt(_colors.length)];
    final correct = _rotate(base, 1 + _rand.nextInt(3));
    final opts = <List<(int, int)>>[correct];
    // Mirror distractor (rotated).
    final mir = _rotate(_mirror(base), _rand.nextInt(4));
    if (!_sameShape(mir, base)) opts.add(mir);
    // Other shapes as distractors.
    var guard = 0;
    while (opts.length < 4 && guard++ < 50) {
      final other = _shapes[_rand.nextInt(_shapes.length)];
      if (_sameShape(other, base)) continue;
      final rot = _rotate(other, _rand.nextInt(4));
      if (opts.any((o) => _key(o) == _key(rot))) continue;
      opts.add(rot);
    }
    while (opts.length < 4) {
      opts.add(_rotate(_mirror(base), opts.length));
    }
    opts.shuffle(_rand);
    _options = opts;
    _answerIdx = opts.indexWhere((o) => _sameShape(o, base));
    _picked = null;
  }

  void _pick(int i) {
    if (_picked != null) return;
    final good = i == _answerIdx;
    if (good) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 10;
    } else {
      HapticFeedback.mediumImpact();
    }
    setState(() => _picked = i);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_round + 1 >= _rounds) {
        _stopwatch.stop();
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _rounds * 10,
            accuracy: _correct / _rounds * 100,
            xp: 10 + _score ~/ 5,
            durationSec: _stopwatch.elapsed.inSeconds,
            detailAr: 'إجابات صحيحة: $_correct من $_rounds',
          ),
        );
      } else {
        setState(() {
          _round++;
          _newRound();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اختر الشكل المطابق للهدف بعد تدويره ذهنياً. انتبه: الأشكال المعكوسة (كالمرآة) ليست مطابقة. 12 جولة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/$_rounds  •  النتيجة: $_score'),
          const SizedBox(height: 12),
          const Text('الشكل الهدف', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            width: 150,
            height: 150,
            child: CustomPaint(painter: _CellsPainter(_target, _color)),
          ),
          const SizedBox(height: 16),
          const Text('أيّها المطابق؟', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                Color border = Colors.grey.shade300;
                if (_picked != null) {
                  if (i == _answerIdx) border = Colors.green.shade600;
                  if (i == _picked && i != _answerIdx) border = Colors.red.shade500;
                }
                return InkWell(
                  onTap: () => _pick(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border, width: 3),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: CustomPaint(painter: _CellsPainter(_options[i], _color)),
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

class _CellsPainter extends CustomPainter {
  _CellsPainter(this.cells, this.color);
  final List<(int, int)> cells;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;
    final maxR = cells.map((c) => c.$1).reduce(max) + 1;
    final maxC = cells.map((c) => c.$2).reduce(max) + 1;
    final cell = min(size.width / maxC, size.height / maxR);
    final ox = (size.width - cell * maxC) / 2;
    final oy = (size.height - cell * maxR) / 2;
    final paint = Paint()..color = color;
    for (final c in cells) {
      final rect = Rect.fromLTWH(ox + c.$2 * cell + 1.5, oy + c.$1 * cell + 1.5, cell - 3, cell - 3);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CellsPainter old) => true;
}
