import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class MissingShapeGame extends StatefulWidget {
  const MissingShapeGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MissingShapeGame> createState() => _State();
}

class _Item {
  const _Item(this.shape, this.color, this.size, this.turns);
  final int shape;
  final Color color;
  final double size;
  final double turns;
  bool sameAs(_Item o) =>
      shape == o.shape && color == o.color && size == o.size && turns == o.turns;
}

class _State extends State<MissingShapeGame> {
  static const _shapes = [
    Icons.circle,
    Icons.square,
    Icons.change_history,
    Icons.star,
    Icons.favorite,
    Icons.hexagon,
  ];
  static const _colors = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
    Color(0xFF7C5CBF),
    Color(0xFFD6336C),
  ];
  static const _totalRounds = 10;

  bool _ready = true;
  int _round = 0;
  List<_Item?> _sequence = [];
  List<_Item> _options = [];
  int _answer = 0;
  int? _picked;
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  _Item _randItem() => _Item(
    _rand.nextInt(_shapes.length),
    _colors[_rand.nextInt(_colors.length)],
    30,
    0,
  );

  void _newRound() {
    final mode = _rand.nextInt(5);
    List<_Item> full;
    if (mode == 0) {
      // ABABAB
      final a = _randItem();
      var b = _randItem();
      while (b.sameAs(a)) {
        b = _randItem();
      }
      full = [a, b, a, b, a, b];
    } else if (mode == 1) {
      // ABCABC
      final a = _randItem();
      var b = _randItem();
      var c = _randItem();
      while (b.sameAs(a)) {
        b = _randItem();
      }
      while (c.sameAs(a) || c.sameAs(b)) {
        c = _randItem();
      }
      full = [a, b, c, a, b, c];
    } else if (mode == 2) {
      // Size progression
      final s = _rand.nextInt(_shapes.length);
      final c = _colors[_rand.nextInt(_colors.length)];
      full = [
        for (var i = 0; i < 5; i++) _Item(s, c, 18.0 + i * 6, 0),
      ];
    } else if (mode == 3) {
      // Color progression (cycle through palette)
      final s = _rand.nextInt(_shapes.length);
      final start = _rand.nextInt(_colors.length);
      full = [
        for (var i = 0; i < 5; i++)
          _Item(s, _colors[(start + i) % _colors.length], 30, 0),
      ];
    } else {
      // Rotation progression
      final s = _rand.nextInt(_shapes.length);
      final c = _colors[_rand.nextInt(_colors.length)];
      full = [
        for (var i = 0; i < 5; i++) _Item(s, c, 30, i * 0.125),
      ];
    }
    final missing = 1 + _rand.nextInt(full.length - 1);
    final answerItem = full[missing];
    _sequence = List<_Item?>.of(full);
    _sequence[missing] = null;
    _options = [answerItem];
    var guard = 0;
    while (_options.length < 4 && guard++ < 100) {
      final o = _randItem();
      if (_options.any((x) => x.sameAs(o))) continue;
      _options.add(o);
    }
    _options.shuffle(_rand);
    _answer = _options.indexWhere((o) => o.sameAs(answerItem));
    _picked = null;
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _pick(int i) {
    if (_picked != null) return;
    final good = i == _answer;
    if (good) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 25;
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
      _score = max(0, _score - 5);
    }
    setState(() => _picked = i);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _round++;
      if (_round >= _totalRounds) {
        _stopwatch.stop();
        final total = _correct + _wrong;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 250,
            accuracy: total == 0 ? 0 : _correct / total * 100,
            xp: 10 + _score ~/ 10,
            durationSec: _stopwatch.elapsed.inSeconds,
            detailAr: 'إجابات صحيحة: $_correct من $_totalRounds',
          ),
        );
      } else {
        setState(_newRound);
      }
    });
  }

  Widget _itemView(_Item item, {double box = 56}) {
    return SizedBox(
      width: box,
      height: box,
      child: Center(
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(item.turns),
          child: Icon(_shapes[item.shape], color: item.color, size: item.size),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اكتشف النمط واختر الشكل الذي يكمل الفراغ (؟). الأنماط: تكرار، حجم متزايد، ألوان متتابعة، دوران. $_totalRounds جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1} من $_totalRounds  •  النتيجة: $_score'),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in _sequence)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: item == null
                      ? const SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: WamdaColors.amber,
                              ),
                            ),
                          ),
                        )
                      : _itemView(item),
                ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('اختر الشكل المناسب:'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _options.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: _picked == null
                        ? Colors.white
                        : (i == _answer
                              ? Colors.green.shade100
                              : (_picked == i
                                    ? Colors.red.shade100
                                    : Colors.white)),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => _pick(i),
                      borderRadius: BorderRadius.circular(12),
                      child: _itemView(_options[i], box: 64),
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
