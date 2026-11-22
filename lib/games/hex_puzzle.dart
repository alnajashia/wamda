import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class HexPuzzleGame extends StatefulWidget {
  const HexPuzzleGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<HexPuzzleGame> createState() => _State();
}

class _State extends State<HexPuzzleGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
  ];
  static const _cols = 5;
  static const _rows = 4;
  static const _rounds = 6;

  bool _ready = true;
  int _round = 0;
  List<int> _target = [];
  List<int> _board = [];
  int _score = 0;
  int _taps = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _taps = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    final colored = 4 + _round * 2; // 4..14 colored hexes
    _target = List.filled(_cols * _rows, -1);
    final idx = List.generate(_cols * _rows, (i) => i)..shuffle(_rand);
    for (var k = 0; k < colored; k++) {
      _target[idx[k]] = _rand.nextInt(_palette.length);
    }
    _board = List.filled(_cols * _rows, -1);
  }

  void _tap(int i) {
    HapticFeedback.selectionClick();
    _taps++;
    setState(() {
      _board[i] = _board[i] >= _palette.length - 1 ? -1 : _board[i] + 1;
    });
    var match = true;
    for (var k = 0; k < _target.length; k++) {
      if (_board[k] != _target[k]) match = false;
    }
    if (match) {
      HapticFeedback.lightImpact();
      _score += 100;
      if (_round + 1 >= _rounds) {
        _stopwatch.stop();
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _rounds * 100,
            accuracy: 100,
            xp: 15 + _score ~/ 10,
            durationSec: _stopwatch.elapsed.inSeconds,
            detailAr: 'أعدت إنتاج $_rounds أنماط سداسية • عدد النقرات: $_taps',
          ),
        );
      } else {
        setState(() {
          _round++;
          _newRound();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'أعد إنتاج نمط السداسيات الملوّنة في الأعلى. اضغط أي سداسي لتدوير لونه حتى يطابق النمط تماماً. 6 جولات.',
        onStart: _startGame,
      );
    }
    final matched = [
      for (var i = 0; i < _target.length; i++)
        if (_board[i] == _target[i]) i
    ].length;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/$_rounds  •  مطابق: $matched/${_target.length}  •  النتيجة: $_score'),
          const SizedBox(height: 12),
          const Text('النمط المستهدف', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _HexPainter(_target, _cols, _rows, _palette),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 16),
          const Text('لوحتك — اضغط للتدوير', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final geo = _HexGeo(constraints.maxWidth, constraints.maxHeight, _cols, _rows);
                return GestureDetector(
                  onTapDown: (d) {
                    final i = geo.hitTest(d.localPosition);
                    if (i != null) _tap(i);
                  },
                  child: CustomPaint(
                    painter: _HexPainter(_board, _cols, _rows, _palette),
                    size: Size.infinite,
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

class _HexGeo {
  _HexGeo(this.width, this.height, this.cols, this.rows) {
    // Flat-top hexagons, offset rows.
    hexW = min(width / (cols + 0.5), height / (rows * 0.78 + 0.25));
    hexH = hexW * 0.866;
  }
  final double width, height;
  final int cols, rows;
  late final double hexW, hexH;

  Offset center(int i) {
    final r = i ~/ cols, c = i % cols;
    final x = hexW * (c + 0.5 + (r.isOdd ? 0.5 : 0)) + (width - hexW * (cols + 0.5)) / 2;
    final y = hexH * (r * 0.9 + 0.55) + (height - hexH * (rows * 0.9 + 0.1)) / 2;
    return Offset(x, y);
  }

  int? hitTest(Offset p) {
    var best = -1;
    var bestDist = double.infinity;
    for (var i = 0; i < cols * rows; i++) {
      final d = (center(i) - p).distance;
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }
    return bestDist <= hexW * 0.55 ? best : null;
  }
}

class _HexPainter extends CustomPainter {
  _HexPainter(this.cells, this.cols, this.rows, this.palette);
  final List<int> cells;
  final int cols, rows;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final geo = _HexGeo(size.width, size.height, cols, rows);
    final r = geo.hexW * 0.48;
    for (var i = 0; i < cells.length; i++) {
      final c = geo.center(i);
      final path = Path();
      for (var k = 0; k < 6; k++) {
        final a = pi / 3 * k;
        final p = Offset(c.dx + r * cos(a), c.dy + r * sin(a));
        if (k == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      final fill = Paint()
        ..color = cells[i] < 0 ? Colors.white : palette[cells[i]]
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fill);
      final stroke = Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _HexPainter old) => old.cells != cells;
}
