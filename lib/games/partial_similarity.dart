import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class PartialSimilarityGame extends StatefulWidget {
  const PartialSimilarityGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<PartialSimilarityGame> createState() => _State();
}

class _State extends State<PartialSimilarityGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 12;
  int _size = 3;
  List<int> _a = []; // color indices, -1 = empty
  List<int> _b = [];
  int _diffCell = -1; // -1 means identical
  bool? _lastCorrect;
  int _score = 0;
  int _correct = 0;
  final _rand = Random();
  final _start = Stopwatch();

  static const _colors = [
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF7C5CBF),
  ];

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  void _nextRound() {
    _round++;
    _size = _round <= 4 ? 3 : (_round <= 8 ? 4 : 5);
    final total = _size * _size;
    final filled = total * 2 ~/ 3;
    final cells = List.generate(total, (i) => i)..shuffle(_rand);
    _a = List.filled(total, -1);
    for (var k = 0; k < filled; k++) {
      _a[cells[k]] = _rand.nextInt(_colors.length);
    }
    _b = List.of(_a);
    _diffCell = -1;
    if (_rand.nextBool()) {
      // change exactly one cell: color change, add, or remove
      final i = _rand.nextInt(total);
      _diffCell = i;
      if (_b[i] == -1) {
        _b[i] = _rand.nextInt(_colors.length);
      } else if (_rand.nextBool()) {
        _b[i] = -1;
      } else {
        var c = _rand.nextInt(_colors.length);
        if (c == _b[i]) c = (c + 1) % _colors.length;
        _b[i] = c;
      }
    }
    _lastCorrect = null;
    setState(() {});
  }

  void _answerSame() {
    if (_lastCorrect != null) return;
    _resolve(_diffCell == -1);
  }

  void _tapCell(int i) {
    if (_lastCorrect != null) return;
    _resolve(_diffCell == i);
  }

  void _resolve(bool ok) {
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

  Widget _board(List<int> pattern, {required bool tappable}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pattern.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _size,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (_, i) {
        final v = pattern[i];
        final highlight = _lastCorrect != null && _diffCell == i && !tappable;
        return Material(
          color: v == -1 ? Colors.white : _colors[v],
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: tappable ? () => _tapCell(i) : null,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: highlight
                      ? Colors.red.shade600
                      : const Color(0xFFE5E7EB),
                  width: highlight ? 3 : 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'قارن النمطين: إن كانا متطابقين اضغط «متطابقان»، وإن اختلفا في خلية واحدة اضغط عليها في النمط الثاني. 12 جولة.',
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
          const Text('النمط الأول'),
          const SizedBox(height: 6),
          SizedBox(height: 150, child: _board(_a, tappable: false)),
          const SizedBox(height: 12),
          const Text('النمط الثاني (اضغط الخلية المختلفة إن وجدت)'),
          const SizedBox(height: 6),
          SizedBox(height: 150, child: _board(_b, tappable: true)),
          const Spacer(),
          if (_lastCorrect != null)
            Text(
              _lastCorrect! ? 'صحيح! أحسنت' : 'خطأ! ركّز أكثر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _lastCorrect! ? Colors.green.shade700 : Colors.red.shade600,
              ),
            )
          else
            FilledButton(
              onPressed: _answerSame,
              child: const Text('متطابقان تماماً'),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
