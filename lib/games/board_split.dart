import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class BoardSplitGame extends StatefulWidget {
  const BoardSplitGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<BoardSplitGame> createState() => _State();
}

class _State extends State<BoardSplitGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFF7C5CBF),
  ];
  static const _rounds = [(4, 2), (6, 2), (6, 3), (6, 4), (8, 4)];

  bool _ready = true;
  int _round = 0;
  List<int> _cells = [];
  int _selectedColor = 0;
  int _score = 0;
  int _mistakes = 0;
  String _msg = '';
  final _stopwatch = Stopwatch();

  int get _size => _rounds[_round].$1;
  int get _colors => _rounds[_round].$2;
  int get _perColor => _size * _size ~/ _colors;

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _mistakes = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    _cells = List.filled(_size * _size, -1);
    _selectedColor = 0;
    _msg = '';
  }

  bool _connected(int color) {
    final cells = [for (var i = 0; i < _cells.length; i++) if (_cells[i] == color) i];
    if (cells.isEmpty) return false;
    final seen = <int>{cells.first};
    final stack = [cells.first];
    while (stack.isNotEmpty) {
      final cur = stack.removeLast();
      final r = cur ~/ _size, c = cur % _size;
      for (final (dr, dc) in [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
        final nr = r + dr, nc = c + dc;
        if (nr < 0 || nr >= _size || nc < 0 || nc >= _size) continue;
        final ni = nr * _size + nc;
        if (_cells[ni] == color && !seen.contains(ni)) {
          seen.add(ni);
          stack.add(ni);
        }
      }
    }
    return seen.length == cells.length;
  }

  void _check() {
    final counts = List.filled(_colors, 0);
    for (final v in _cells) {
      if (v >= 0) counts[v]++;
    }
    if (_cells.contains(-1)) {
      setState(() => _msg = 'لوّن كل الخلايا أولاً');
      return;
    }
    if (counts.any((c) => c != _perColor)) {
      _mistakes++;
      HapticFeedback.mediumImpact();
      setState(() => _msg = 'كل لون يجب أن يغطي $_perColor خلية بالضبط');
      return;
    }
    for (var c = 0; c < _colors; c++) {
      if (!_connected(c)) {
        _mistakes++;
        HapticFeedback.mediumImpact();
        setState(() => _msg = 'أحد الألوان مقسوم إلى جزأين — يجب أن يكون متصلاً');
        return;
      }
    }
    HapticFeedback.lightImpact();
    _score += 100;
    if (_round + 1 >= _rounds.length) {
      _stopwatch.stop();
      final total = _rounds.length * 100;
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: total,
          accuracy: max(0, 100 - _mistakes * 10).toDouble(),
          xp: 15 + _score ~/ 10,
          durationSec: _stopwatch.elapsed.inSeconds,
          detailAr: 'أكملت ${_rounds.length} لوحات • محاولات خاطئة: $_mistakes',
        ),
      );
    } else {
      setState(() {
        _round++;
        _newRound();
        _msg = 'أحسنت! اللوحة التالية';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'قسّم اللوحة إلى مناطق ملونة متساوية المساحة ومتصلة. اختر لوناً ثم اضغط الخلايا لتلوينها. 5 جولات.',
        onStart: _startGame,
      );
    }
    final counts = List.filled(_colors, 0);
    for (final v in _cells) {
      if (v >= 0) counts[v]++;
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/${_rounds.length}  •  كل لون: $_perColor خلية  •  النتيجة: $_score'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var c = 0; c < _colors; c++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _selectedColor = c),
                    child: Container(
                      width: 52,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _palette[c],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedColor == c ? Colors.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${counts[c]}/$_perColor',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              itemCount: _size * _size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _size,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (_, i) {
                return Material(
                  color: _cells[i] < 0 ? Colors.white : _palette[_cells[i]],
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => setState(() {
                      _cells[i] = _cells[i] == _selectedColor ? -1 : _selectedColor;
                    }),
                  ),
                );
              },
            ),
          ),
          if (_msg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_msg, style: const TextStyle(color: Color(0xFFE4572E))),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => setState(_newRound),
                child: const Text('مسح اللوحة'),
              ),
              const SizedBox(width: 12),
              FilledButton(onPressed: _check, child: const Text('تحقق')),
            ],
          ),
        ],
      ),
    );
  }
}
