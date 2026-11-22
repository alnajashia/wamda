import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

/// A face defined by feature indices.
class _Face {
  const _Face(this.skin, this.hairStyle, this.hairColor, this.glasses, this.smile);
  final int skin; // 0..2
  final int hairStyle; // 0 short, 1 long, 2 bald, 3 curly
  final int hairColor; // 0 black, 1 brown, 2 blond, 3 red
  final bool glasses;
  final bool smile; // true smile, false neutral

  @override
  bool operator ==(Object other) =>
      other is _Face &&
      skin == other.skin &&
      hairStyle == other.hairStyle &&
      hairColor == other.hairColor &&
      glasses == other.glasses &&
      smile == other.smile;

  @override
  int get hashCode => Object.hash(skin, hairStyle, hairColor, glasses, smile);
}

class _FacePainter extends CustomPainter {
  _FacePainter(this.face);
  final _Face face;

  static const _skins = [Color(0xFFFFDFC4), Color(0xFFE8B88A), Color(0xFFB07B4F)];
  static const _hairs = [
    Color(0xFF2B2B2B),
    Color(0xFF6B4226),
    Color(0xFFE3B505),
    Color(0xFFB5441C),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;
    final skinPaint = Paint()..color = _skins[face.skin];
    final hairPaint = Paint()..color = _hairs[face.hairColor];
    // long hair behind head
    if (face.hairStyle == 1) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, cy + r * 0.15),
            width: r * 2.3,
            height: r * 2.5,
          ),
          Radius.circular(r * 0.5),
        ),
        hairPaint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), r, skinPaint);
    // hair styles
    switch (face.hairStyle) {
      case 0: // short cap
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy - r * 0.08), radius: r),
          pi,
          pi,
          true,
          hairPaint,
        );
      case 1: // long: top cap
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy - r * 0.08), radius: r),
          pi,
          pi,
          true,
          hairPaint,
        );
      case 3: // curly: bumps
        for (var i = 0; i < 5; i++) {
          final a = pi + i * pi / 4;
          canvas.drawCircle(
            Offset(cx + cos(a) * r * 0.85, cy + sin(a) * r * 0.85),
            r * 0.32,
            hairPaint,
          );
        }
    }
    // eyes
    final eyePaint = Paint()..color = const Color(0xFF14213D);
    canvas.drawCircle(Offset(cx - r * 0.35, cy - r * 0.05), r * 0.08, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.35, cy - r * 0.05), r * 0.08, eyePaint);
    // glasses
    if (face.glasses) {
      final g = Paint()
        ..color = const Color(0xFF14213D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.07;
      canvas.drawCircle(Offset(cx - r * 0.35, cy - r * 0.05), r * 0.24, g);
      canvas.drawCircle(Offset(cx + r * 0.35, cy - r * 0.05), r * 0.24, g);
      canvas.drawLine(
        Offset(cx - r * 0.11, cy - r * 0.05),
        Offset(cx + r * 0.11, cy - r * 0.05),
        g,
      );
    }
    // mouth
    final mouth = Paint()
      ..color = const Color(0xFF14213D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.08
      ..strokeCap = StrokeCap.round;
    if (face.smile) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(cx, cy + r * 0.35),
          width: r * 0.9,
          height: r * 0.6,
        ),
        0.15 * pi,
        0.7 * pi,
        false,
        mouth,
      );
    } else {
      canvas.drawLine(
        Offset(cx - r * 0.3, cy + r * 0.5),
        Offset(cx + r * 0.3, cy + r * 0.5),
        mouth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FacePainter old) => old.face != face;
}

class PeopleSimilarityGame extends StatefulWidget {
  const PeopleSimilarityGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<PeopleSimilarityGame> createState() => _State();
}

class _State extends State<PeopleSimilarityGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 10;
  List<_Face> _group = [];
  _Face? _probe;
  bool _probeInGroup = false;
  bool _studying = false;
  bool? _lastCorrect;
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _start = Stopwatch();

  _Face _randomFace() => _Face(
    _rand.nextInt(3),
    _rand.nextInt(4),
    _rand.nextInt(4),
    _rand.nextBool(),
    _rand.nextBool(),
  );

  _Face _mutate(_Face f) {
    // change exactly one feature
    switch (_rand.nextInt(5)) {
      case 0:
        return _Face((f.skin + 1 + _rand.nextInt(2)) % 3, f.hairStyle, f.hairColor, f.glasses, f.smile);
      case 1:
        return _Face(f.skin, (f.hairStyle + 1 + _rand.nextInt(3)) % 4, f.hairColor, f.glasses, f.smile);
      case 2:
        return _Face(f.skin, f.hairStyle, (f.hairColor + 1 + _rand.nextInt(3)) % 4, f.glasses, f.smile);
      case 3:
        return _Face(f.skin, f.hairStyle, f.hairColor, !f.glasses, f.smile);
      default:
        return _Face(f.skin, f.hairStyle, f.hairColor, f.glasses, !f.smile);
    }
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  void _nextRound() {
    _round++;
    final n = 3 + (_round - 1) ~/ 3; // 3..6
    _group = [];
    while (_group.length < n) {
      final f = _randomFace();
      if (!_group.contains(f)) _group.add(f);
    }
    _probeInGroup = _rand.nextBool();
    if (_probeInGroup) {
      _probe = _group[_rand.nextInt(_group.length)];
    } else {
      var p = _mutate(_group[_rand.nextInt(_group.length)]);
      var guard = 0;
      while (_group.contains(p) && guard++ < 20) {
        p = _mutate(p);
      }
      _probe = p;
    }
    _lastCorrect = null;
    setState(() => _studying = true);
    Future.delayed(Duration(milliseconds: 2500 + n * 500), () {
      if (mounted) setState(() => _studying = false);
    });
  }

  void _answer(bool yes) {
    if (_studying || _lastCorrect != null) return;
    final ok = yes == _probeInGroup;
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

  Widget _faceWidget(_Face f, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: CustomPaint(painter: _FacePainter(f)),
  );

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'احفظ وجوه المجموعة، ثم قرر: هل الشخص الظاهر كان ضمن المجموعة؟ انتبه للشعر والنظارة والابتسامة. 10 جولات.',
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
          if (_studying) ...[
            const Text('احفظ هذه الوجوه...'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [for (final f in _group) _faceWidget(f, 100)],
            ),
          ] else ...[
            const Text('هل كان هذا الشخص ضمن المجموعة؟'),
            const SizedBox(height: 16),
            if (_probe != null) _faceWidget(_probe!, 150),
            const SizedBox(height: 20),
            if (_lastCorrect != null)
              Text(
                _lastCorrect! ? 'صحيح! أحسنت' : 'خطأ! انتبه للتفاصيل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _lastCorrect! ? Colors.green.shade700 : Colors.red.shade600,
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                      ),
                      onPressed: () => _answer(true),
                      child: const Text('نعم، كان معهم'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                      ),
                      onPressed: () => _answer(false),
                      child: const Text('لا، لم يكن'),
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
