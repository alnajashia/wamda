import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class CubePuzzleGame extends StatefulWidget {
  const CubePuzzleGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<CubePuzzleGame> createState() => _State();
}

class _State extends State<CubePuzzleGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
    Color(0xFF7C5CBF),
    Color(0xFFD6336C),
  ];
  static const _namesAr = ['برتقالي', 'أزرق', 'أخضر', 'أصفر', 'بنفسجي', 'وردي'];
  // Net positions (col,row): 0 top, 1 center(front), 2 bottom, 3 farBottom(back), 4 left, 5 right
  static const _netPos = [(1, 0), (1, 1), (1, 2), (1, 3), (0, 1), (2, 1)];
  static const _opposite = [2, 3, 0, 1, 5, 4];
  static const _rounds = 10;

  bool _ready = true;
  int _round = 0;
  List<int> _faces = []; // face index -> color index
  int _asked = 0;
  List<int> _options = [];
  int? _picked;
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

  void _newRound() {
    _faces = [0, 1, 2, 3, 4, 5]..shuffle(_rand);
    _asked = _rand.nextInt(6);
    final answer = _faces[_opposite[_asked]];
    final opts = <int>{answer};
    while (opts.length < 4) {
      opts.add(_rand.nextInt(6));
    }
    _options = opts.toList()..shuffle(_rand);
    _picked = null;
  }

  void _pick(int color) {
    if (_picked != null) return;
    final answer = _faces[_opposite[_asked]];
    final good = color == answer;
    if (good) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 10;
    } else {
      HapticFeedback.mediumImpact();
    }
    setState(() => _picked = color);
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
            'انظر إلى شبكة المكعب المفرودة ثم خمّن: ما لون الوجه المقابل للوجه المحدد؟ 10 جولات.',
        onStart: _startGame,
      );
    }
    final answer = _faces[_opposite[_asked]];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/$_rounds  •  النتيجة: $_score'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('الشبكة المفرودة', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 150,
                    height: 200,
                    child: CustomPaint(
                      painter: _NetPainter(_faces, _asked, _palette, _netPos),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('المكعب', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 150,
                    height: 200,
                    child: CustomPaint(
                      painter: _CubePainter(
                        top: _palette[_faces[0]],
                        front: _palette[_faces[1]],
                        right: _palette[_faces[5]],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'ما لون الوجه المقابل للوجه ${_namesAr[_faces[_asked]]}؟',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final o in _options)
                InkWell(
                  onTap: () => _pick(o),
                  child: Container(
                    width: 72,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _palette[o],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _picked == null
                            ? Colors.transparent
                            : (o == answer ? Colors.green.shade700 : (_picked == o ? Colors.red.shade700 : Colors.transparent)),
                        width: 4,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _namesAr[o],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

class _NetPainter extends CustomPainter {
  _NetPainter(this.faces, this.asked, this.palette, this.pos);
  final List<int> faces;
  final int asked;
  final List<Color> palette;
  final List<(int, int)> pos;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = min(size.width / 3, size.height / 4);
    final ox = (size.width - cell * 3) / 2;
    final oy = (size.height - cell * 4) / 2;
    for (var f = 0; f < 6; f++) {
      final (c, r) = pos[f];
      final rect = Rect.fromLTWH(ox + c * cell + 2, oy + r * cell + 2, cell - 4, cell - 4);
      final fill = Paint()..color = palette[faces[f]];
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), fill);
      if (f == asked) {
        final stroke = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), stroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NetPainter old) => true;
}

class _CubePainter extends CustomPainter {
  _CubePainter({required this.top, required this.front, required this.right});
  final Color top, front, right;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final s = min(size.width, size.height) * 0.32;
    final center = Offset(cx, cy);
    final topP = Offset(cx, cy - s);
    final leftP = Offset(cx - s * 0.87, cy - s * 0.5);
    final rightP = Offset(cx + s * 0.87, cy - s * 0.5);
    final bottomL = Offset(cx - s * 0.87, cy + s * 0.5);
    final bottomR = Offset(cx + s * 0.87, cy + s * 0.5);
    final bottomC = Offset(cx, cy + s);
    Path poly(List<Offset> pts) {
      final p = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) {
        p.lineTo(pt.dx, pt.dy);
      }
      return p..close();
    }

    canvas.drawPath(poly([topP, rightP, center, leftP]), Paint()..color = top);
    canvas.drawPath(poly([leftP, center, bottomC, bottomL]), Paint()..color = front);
    canvas.drawPath(poly([center, rightP, bottomR, bottomC]), Paint()..color = right);
    final stroke = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(poly([topP, rightP, center, leftP]), stroke);
    canvas.drawPath(poly([leftP, center, bottomC, bottomL]), stroke);
    canvas.drawPath(poly([center, rightP, bottomR, bottomC]), stroke);
  }

  @override
  bool shouldRepaint(covariant _CubePainter old) => true;
}
