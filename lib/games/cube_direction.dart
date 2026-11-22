import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class CubeDirectionGame extends StatefulWidget {
  const CubeDirectionGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<CubeDirectionGame> createState() => _State();
}

class _State extends State<CubeDirectionGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
    Color(0xFF7C5CBF),
    Color(0xFFD6336C),
  ];
  static const _namesAr = ['برتقالي', 'أزرق', 'أخضر', 'أصفر', 'بنفسجي', 'وردي'];
  // dirs: 0 right, 1 left, 2 forward (toward viewer), 3 backward
  static const _dirIcons = [Icons.arrow_forward, Icons.arrow_back, Icons.arrow_downward, Icons.arrow_upward];
  static const _dirNames = ['يمين', 'يسار', 'نحوك', 'بعيداً عنك'];
  static const _rounds = 10;

  bool _ready = true;
  int _round = 0;
  // faces: up, down, front, back, left, right -> color index
  List<int> _faces = [];
  List<int> _seq = [];
  int _step = -1; // -1 showing initial, else applied steps count
  bool _asking = false;
  int _askFace = 0; // 0 up, 2 front
  List<int> _options = [];
  int? _picked;
  int _score = 0;
  int _correct = 0;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _correct = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  List<int> _rotate(List<int> f, int dir) {
    final up = f[0], down = f[1], front = f[2], back = f[3], left = f[4], right = f[5];
    return switch (dir) {
      0 => [left, right, front, back, down, up], // roll right
      1 => [right, left, front, back, up, down], // roll left
      2 => [back, front, up, down, left, right], // tip toward viewer
      _ => [front, back, down, up, left, right], // tip away
    };
  }

  void _newRound() {
    _timer?.cancel();
    _faces = [0, 1, 2, 3, 4, 5]..shuffle(_rand);
    final len = 2 + _round ~/ 3; // 2..5
    _seq = List.generate(len, (_) => _rand.nextInt(4));
    _step = -1;
    _asking = false;
    _picked = null;
    _askFace = _rand.nextBool() ? 0 : 2;
    _timer = Timer.periodic(const Duration(milliseconds: 1100), (t) {
      if (!mounted) return;
      setState(() {
        _step++;
        if (_step >= 0 && _step < _seq.length) {
          _faces = _rotate(_faces, _seq[_step]);
        }
      });
      if (_step >= _seq.length) {
        t.cancel();
        final answer = _faces[_askFace];
        final opts = <int>{answer};
        while (opts.length < 4) {
          opts.add(_rand.nextInt(6));
        }
        setState(() {
          _asking = true;
          _options = opts.toList()..shuffle(_rand);
        });
      }
    });
  }

  void _pick(int color) {
    if (_picked != null) return;
    final good = color == _faces[_askFace];
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
            'شاهد المكعب وهو يدور خطوة بخطوة، ثم خمّن لون الوجه المطلوب بعد انتهاء الدوران. 10 جولات متدرجة.',
        onStart: _startGame,
      );
    }
    final answer = _faces[_askFace];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/$_rounds  •  النتيجة: $_score'),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            children: [
              for (var s = 0; s < _seq.length; s++)
                Chip(
                  avatar: Icon(_dirIcons[_seq[s]], size: 16),
                  label: Text(_dirNames[_seq[s]]),
                  backgroundColor: _step >= s ? const Color(0xFFF2A93B) : null,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(
                  painter: _CubeDirPainter(
                    top: _palette[_faces[0]],
                    front: _palette[_faces[2]],
                    right: _palette[_faces[5]],
                  ),
                ),
              ),
            ),
          ),
          if (_asking) ...[
            Text(
              _askFace == 0 ? 'ما لون الوجه العلوي الآن؟' : 'ما لون الوجه الأمامي الآن؟',
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
          ] else
            const Text('تابع الدوران...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _CubeDirPainter extends CustomPainter {
  _CubeDirPainter({required this.top, required this.front, required this.right});
  final Color top, front, right;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final s = min(size.width, size.height) * 0.36;
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
  bool shouldRepaint(covariant _CubeDirPainter old) => true;
}
