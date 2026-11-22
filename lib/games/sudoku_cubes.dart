import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SudokuCubesGame extends StatefulWidget {
  const SudokuCubesGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SudokuCubesGame> createState() => _State();
}

class _State extends State<SudokuCubesGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
  ];
  static const _givensPerRound = [10, 8, 7, 6, 5];

  bool _ready = true;
  int _round = 0;
  List<int> _solution = [];
  List<int> _grid = [];
  List<bool> _given = [];
  int _selected = 0;
  int _score = 0;
  int _mistakes = 0;
  String _msg = '';
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _mistakes = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  List<int> _fullGrid() {
    // Base valid pattern: (2r + r~/2 + c) % 4
    var g = List.generate(16, (i) {
      final r = i ~/ 4, c = i % 4;
      return (2 * r + r ~/ 2 + c) % 4;
    });
    // Permute colors.
    final colors = [0, 1, 2, 3]..shuffle(_rand);
    g = [for (final v in g) colors[v]];
    // Swap rows within bands and bands.
    List<int> permRows(List<int> grid, List<int> order) => [
          for (final r in order)
            for (var c = 0; c < 4; c++) grid[r * 4 + c]
        ];
    List<int> permCols(List<int> grid, List<int> order) => [
          for (var r = 0; r < 4; r++)
            for (final c in order) grid[r * 4 + c]
        ];
    final rows = [0, 1, 2, 3];
    if (_rand.nextBool()) rows.swap(0, 1);
    if (_rand.nextBool()) rows.swap(2, 3);
    if (_rand.nextBool()) {
      final t = rows.sublist(0, 2);
      rows.setRange(0, 2, rows.sublist(2));
      rows.setRange(2, 4, t);
    }
    g = permRows(g, rows);
    final cols = [0, 1, 2, 3];
    if (_rand.nextBool()) cols.swap(0, 1);
    if (_rand.nextBool()) cols.swap(2, 3);
    if (_rand.nextBool()) {
      final t = cols.sublist(0, 2);
      cols.setRange(0, 2, cols.sublist(2));
      cols.setRange(2, 4, t);
    }
    g = permCols(g, cols);
    return g;
  }

  bool _validAt(List<int> g, int i, int v) {
    final r = i ~/ 4, c = i % 4;
    for (var k = 0; k < 4; k++) {
      if (g[r * 4 + k] == v || g[k * 4 + c] == v) return false;
    }
    final br = (r ~/ 2) * 2, bc = (c ~/ 2) * 2;
    for (var dr = 0; dr < 2; dr++) {
      for (var dc = 0; dc < 2; dc++) {
        if (g[(br + dr) * 4 + bc + dc] == v) return false;
      }
    }
    return true;
  }

  int _countSolutions(List<int> g, int cap) {
    final idx = g.indexOf(-1);
    if (idx < 0) return 1;
    var count = 0;
    for (var v = 0; v < 4; v++) {
      if (_validAt(g, idx, v)) {
        g[idx] = v;
        count += _countSolutions(g, cap);
        g[idx] = -1;
        if (count >= cap) return count;
      }
    }
    return count;
  }

  void _newRound() {
    _solution = _fullGrid();
    _grid = List.of(_solution);
    _given = List.filled(16, true);
    final target = _givensPerRound[_round];
    final order = List.generate(16, (i) => i)..shuffle(_rand);
    var remaining = 16;
    for (final i in order) {
      if (remaining <= target) break;
      final backup = _grid[i];
      _grid[i] = -1;
      _given[i] = false;
      final copy = List.of(_grid);
      if (_countSolutions(copy, 2) != 1) {
        _grid[i] = backup;
        _given[i] = true;
      } else {
        remaining--;
      }
    }
    _selected = 0;
    _msg = '';
  }

  void _check() {
    if (_grid.contains(-1)) {
      setState(() => _msg = 'املأ كل الخلايا أولاً');
      return;
    }
    var ok = true;
    for (var i = 0; i < 16; i++) {
      if (_grid[i] != _solution[i]) ok = false;
    }
    if (!ok) {
      _mistakes++;
      HapticFeedback.mediumImpact();
      setState(() => _msg = 'بعض الخلايا غير صحيحة — راجع الصفوف والأعمدة والمربعات');
      return;
    }
    HapticFeedback.lightImpact();
    _score += 100;
    if (_round + 1 >= _givensPerRound.length) {
      _stopwatch.stop();
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: _givensPerRound.length * 100,
          accuracy: max(0, 100 - _mistakes * 10).toDouble(),
          xp: 15 + _score ~/ 10,
          durationSec: _stopwatch.elapsed.inSeconds,
          detailAr: 'حللت ${_givensPerRound.length} ألغاز سودوكو • أخطاء: $_mistakes',
        ),
      );
    } else {
      setState(() {
        _round++;
        _newRound();
        _msg = 'أحسنت! اللغز التالي أصعب';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'سودوكو مصغّر بالألوان: كل صف وعمود ومربع 2×2 يجب أن يحتوي الألوان الأربعة. اختر لوناً ثم اضغط الخلية. 5 جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/${_givensPerRound.length}  •  النتيجة: $_score'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var c = 0; c < 4; c++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _selected = c),
                    child: Container(
                      width: 52,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _palette[c],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selected == c ? Colors.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (_, i) {
                    final v = _grid[i];
                    return Material(
                      color: v < 0 ? Colors.white : _palette[v],
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: _given[i]
                            ? null
                            : () => setState(() {
                                  _grid[i] = _grid[i] == _selected ? -1 : _selected;
                                }),
                        child: _given[i]
                            ? const Icon(Icons.lock, color: Colors.white, size: 18)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (_msg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_msg, style: const TextStyle(color: Color(0xFFE4572E))),
            ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _check, child: const Text('تحقق')),
        ],
      ),
    );
  }
}

extension on List<int> {
  void swap(int a, int b) {
    final t = this[a];
    this[a] = this[b];
    this[b] = t;
  }
}
