import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class ConnectDotsGame extends StatefulWidget {
  const ConnectDotsGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<ConnectDotsGame> createState() => _State();
}

class _State extends State<ConnectDotsGame> {
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFF7C5CBF),
    Color(0xFFF2A93B),
  ];
  static const _rounds = [(5, 3), (5, 4), (6, 4), (6, 5), (7, 5)];

  bool _ready = true;
  int _round = 0;
  int _size = 5;
  int _pairs = 3;
  List<int> _endpoints = []; // color index per cell, -1 none
  List<List<int>> _paths = [];
  int? _activeColor;
  int _score = 0;
  int _resets = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _resets = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    final (size, pairs) = _rounds[_round];
    _size = size;
    _pairs = pairs;
    _generate();
    _paths = List.generate(_pairs, (_) => <int>[]);
    _activeColor = null;
  }

  /// Generates disjoint solution paths first, then exposes only endpoints.
  void _generate() {
    for (var attempt = 0; attempt < 200; attempt++) {
      final used = <int>{};
      final solutions = <List<int>>[];
      var ok = true;
      for (var p = 0; p < _pairs; p++) {
        final free = [
          for (var i = 0; i < _size * _size; i++)
            if (!used.contains(i)) i
        ];
        if (free.isEmpty) {
          ok = false;
          break;
        }
        var cur = free[_rand.nextInt(free.length)];
        final path = [cur];
        used.add(cur);
        final targetLen = 3 + _rand.nextInt(4);
        var guard = 0;
        while (path.length < targetLen && guard++ < 60) {
          final r = cur ~/ _size, c = cur % _size;
          final opts = <int>[];
          for (final (dr, dc) in [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
            final nr = r + dr, nc = c + dc;
            if (nr < 0 || nr >= _size || nc < 0 || nc >= _size) continue;
            final ni = nr * _size + nc;
            if (!used.contains(ni)) opts.add(ni);
          }
          if (opts.isEmpty) break;
          cur = opts[_rand.nextInt(opts.length)];
          path.add(cur);
          used.add(cur);
        }
        if (path.length < 3) {
          ok = false;
          break;
        }
        solutions.add(path);
      }
      if (!ok) continue;
      _endpoints = List.filled(_size * _size, -1);
      for (var p = 0; p < _pairs; p++) {
        _endpoints[solutions[p].first] = p;
        _endpoints[solutions[p].last] = p;
      }
      return;
    }
    // Fallback: simple rows (always solvable).
    _endpoints = List.filled(_size * _size, -1);
    for (var p = 0; p < _pairs; p++) {
      _endpoints[p * _size] = p;
      _endpoints[p * _size + _size - 1] = p;
    }
  }

  bool _isEndpoint(int i) => _endpoints[i] >= 0;

  int? _colorAt(int i) {
    if (_isEndpoint(i)) return _endpoints[i];
    for (var p = 0; p < _pairs; p++) {
      if (_paths[p].contains(i)) return p;
    }
    return null;
  }

  bool _connected(int p) {
    final ends = [for (var i = 0; i < _endpoints.length; i++) if (_endpoints[i] == p) i];
    if (ends.length != 2) return false;
    return _paths[p].contains(ends[0]) && _paths[p].contains(ends[1]);
  }

  void _onCellDown(int i) {
    if (_isEndpoint(i)) {
      final c = _endpoints[i];
      if (_paths[c].isNotEmpty && _activeColor != c) {
        // Tapping an endpoint of an existing path clears it.
        setState(() {
          _paths[c] = [];
          _activeColor = null;
          _resets++;
        });
        return;
      }
      setState(() {
        _activeColor = c;
        _paths[c] = [i];
      });
    }
  }

  void _onCellDrag(int i) {
    final c = _activeColor;
    if (c == null) return;
    final path = _paths[c];
    if (path.isEmpty) return;
    if (path.last == i) return;
    // Backtrack.
    if (path.length > 1 && path[path.length - 2] == i) {
      setState(() => path.removeLast());
      return;
    }
    // Must be adjacent to last cell.
    final last = path.last;
    final dr = (i ~/ _size - last ~/ _size).abs();
    final dc = (i % _size - last % _size).abs();
    if (dr + dc != 1) return;
    // Cannot enter another color's endpoint or path.
    if (_isEndpoint(i) && _endpoints[i] != c) return;
    final owner = _colorAt(i);
    if (owner != null && owner != c) return;
    if (path.contains(i)) return;
    setState(() => path.add(i));
    if (_isEndpoint(i) && _endpoints[i] == c && path.length > 1) {
      HapticFeedback.lightImpact();
      _activeColor = null;
      _checkWin();
    }
  }

  void _checkWin() {
    for (var p = 0; p < _pairs; p++) {
      if (!_connected(p)) return;
    }
    _score += 100;
    if (_round + 1 >= _rounds.length) {
      _stopwatch.stop();
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: _rounds.length * 100,
          accuracy: max(0, 100 - _resets * 5).toDouble(),
          xp: 15 + _score ~/ 10,
          durationSec: _stopwatch.elapsed.inSeconds,
          detailAr: 'وصلت كل الأزواج في ${_rounds.length} جولات • إعادة رسم: $_resets',
        ),
      );
    } else {
      setState(() {
        _round++;
        _newRound();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'وصّل كل زوجين من النقاط الملوّنة بسحب إصبعك عبر الخلايا دون تقاطع المسارات. اضغط نقطة بداية مسار مرسوم لمسحه. 5 جولات.',
        onStart: _startGame,
      );
    }
    final done = [for (var p = 0; p < _pairs; p++) if (_connected(p)) p].length;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/${_rounds.length}  •  متصل: $done/$_pairs  •  النتيجة: $_score'),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final side = min(constraints.maxWidth, constraints.maxHeight);
                final cell = side / _size;
                int? cellAt(Offset pos) {
                  final c = (pos.dx / cell).floor();
                  final r = (pos.dy / cell).floor();
                  if (r < 0 || r >= _size || c < 0 || c >= _size) return null;
                  return r * _size + c;
                }

                return Center(
                  child: GestureDetector(
                    onPanStart: (d) {
                      final i = cellAt(d.localPosition);
                      if (i != null) _onCellDown(i);
                    },
                    onPanUpdate: (d) {
                      final i = cellAt(d.localPosition);
                      if (i != null) _onCellDrag(i);
                    },
                    onPanEnd: (_) => _activeColor = null,
                    child: SizedBox(
                      width: side,
                      height: side,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _size * _size,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _size,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                        itemBuilder: (_, i) {
                          final owner = _colorAt(i);
                          final isEnd = _isEndpoint(i);
                          return Container(
                            decoration: BoxDecoration(
                              color: owner == null
                                  ? Colors.white
                                  : _palette[owner].withValues(alpha: isEnd ? 1 : 0.45),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: isEnd
                                ? Icon(Icons.circle, color: Colors.white, size: cell * 0.35)
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => setState(() {
              _paths = List.generate(_pairs, (_) => <int>[]);
              _activeColor = null;
              _resets++;
            }),
            child: const Text('مسح كل المسارات'),
          ),
        ],
      ),
    );
  }
}
