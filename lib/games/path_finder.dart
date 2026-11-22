import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class PathFinderGame extends StatefulWidget {
  const PathFinderGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<PathFinderGame> createState() => _State();
}

class _State extends State<PathFinderGame> {
  static const _sizes = [5, 5, 6, 6, 7, 8];

  bool _ready = true;
  int _round = 0;
  int _size = 5;
  // wallsRight[i] true if wall between cell i and i+1; wallsDown[i] between i and i+size.
  List<bool> _wallsRight = [];
  List<bool> _wallsDown = [];
  List<int> _path = [0];
  int _shortest = 0;
  int _score = 0;
  int _stepsTotal = 0;
  int _optimalTotal = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _stepsTotal = 0;
    _optimalTotal = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    _size = _sizes[_round];
    _generateMaze();
    _path = [0];
    _shortest = _bfsShortest();
  }

  void _generateMaze() {
    final n = _size;
    _wallsRight = List.filled(n * n, true);
    _wallsDown = List.filled(n * n, true);
    final visited = List.filled(n * n, false);
    final stack = [0];
    visited[0] = true;
    while (stack.isNotEmpty) {
      final cur = stack.last;
      final r = cur ~/ n, c = cur % n;
      final opts = <(int, int)>[]; // (neighbor, dir) 0 up 1 down 2 left 3 right
      if (r > 0 && !visited[cur - n]) opts.add((cur - n, 0));
      if (r < n - 1 && !visited[cur + n]) opts.add((cur + n, 1));
      if (c > 0 && !visited[cur - 1]) opts.add((cur - 1, 2));
      if (c < n - 1 && !visited[cur + 1]) opts.add((cur + 1, 3));
      if (opts.isEmpty) {
        stack.removeLast();
        continue;
      }
      final (next, dir) = opts[_rand.nextInt(opts.length)];
      switch (dir) {
        case 0:
          _wallsDown[next] = false;
        case 1:
          _wallsDown[cur] = false;
        case 2:
          _wallsRight[next] = false;
        case 3:
          _wallsRight[cur] = false;
      }
      visited[next] = true;
      stack.add(next);
    }
  }

  bool _canMove(int from, int to) {
    final n = _size;
    if (to == from - n) return !_wallsDown[to];
    if (to == from + n) return !_wallsDown[from];
    if (to == from - 1) return !_wallsRight[to];
    if (to == from + 1) return !_wallsRight[from];
    return false;
  }

  int _bfsShortest() {
    final n = _size;
    final dist = List.filled(n * n, -1);
    dist[0] = 0;
    final queue = [0];
    while (queue.isNotEmpty) {
      final cur = queue.removeAt(0);
      if (cur == n * n - 1) return dist[cur];
      for (final next in [cur - n, cur + n, cur - 1, cur + 1]) {
        if (next < 0 || next >= n * n) continue;
        // Avoid row wrap.
        if ((next == cur - 1 && cur % n == 0) || (next == cur + 1 && cur % n == n - 1)) continue;
        if (dist[next] != -1) continue;
        if (!_canMove(cur, next)) continue;
        dist[next] = dist[cur] + 1;
        queue.add(next);
      }
    }
    return dist[n * n - 1];
  }

  void _tap(int i) {
    final cur = _path.last;
    if (_path.length > 1 && _path[_path.length - 2] == i) {
      setState(() => _path.removeLast());
      return;
    }
    if (_path.contains(i)) return;
    final dr = (i ~/ _size - cur ~/ _size).abs();
    final dc = (i % _size - cur % _size).abs();
    if (dr + dc != 1) return;
    if (!_canMove(cur, i)) {
      HapticFeedback.mediumImpact();
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _path.add(i));
    if (i == _size * _size - 1) {
      final steps = _path.length - 1;
      _stepsTotal += steps;
      _optimalTotal += _shortest;
      _score += max(30, 100 - (steps - _shortest) * 5);
      if (_round + 1 >= _sizes.length) {
        _stopwatch.stop();
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _sizes.length * 100,
            accuracy: _stepsTotal == 0 ? 100 : (_optimalTotal / _stepsTotal * 100).clamp(0, 100).toDouble(),
            xp: 15 + _score ~/ 10,
            durationSec: _stopwatch.elapsed.inSeconds,
            detailAr: 'أنهيت ${_sizes.length} متاهات • خطواتك: $_stepsTotal • الأمثل: $_optimalTotal',
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
            'ارسم مساراً من البداية (الأخضر) إلى الهدف (العلم) بالضغط على الخلايا المجاورة دون عبور الجدران. اضغط الخلية السابقة للتراجع. 6 جولات.',
        onStart: _startGame,
      );
    }
    final n = _size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/${_sizes.length}  •  الخطوات: ${_path.length - 1}  •  النتيجة: $_score'),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: n * n,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: n,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (_, i) {
                    final r = i ~/ n, c = i % n;
                    final inPath = _path.contains(i);
                    final isGoal = i == n * n - 1;
                    final isHead = _path.last == i;
                    Color bg = Colors.white;
                    if (inPath) bg = WamdaColors.teal.withValues(alpha: 0.35);
                    if (isHead) bg = WamdaColors.teal;
                    if (i == 0) bg = Colors.green.shade400;
                    if (isGoal) bg = WamdaColors.amber;
                    return GestureDetector(
                      onTap: () => _tap(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          border: Border(
                            top: BorderSide(
                              color: r == 0 || _wallsDown[i - n] ? WamdaColors.ink : Colors.grey.shade200,
                              width: r == 0 || _wallsDown[i - n] ? 3 : 1,
                            ),
                            bottom: BorderSide(
                              color: r == n - 1 || _wallsDown[i] ? WamdaColors.ink : Colors.grey.shade200,
                              width: r == n - 1 || _wallsDown[i] ? 3 : 1,
                            ),
                            left: BorderSide(
                              color: c == 0 || _wallsRight[i - 1] ? WamdaColors.ink : Colors.grey.shade200,
                              width: c == 0 || _wallsRight[i - 1] ? 3 : 1,
                            ),
                            right: BorderSide(
                              color: c == n - 1 || _wallsRight[i] ? WamdaColors.ink : Colors.grey.shade200,
                              width: c == n - 1 || _wallsRight[i] ? 3 : 1,
                            ),
                          ),
                        ),
                        child: isGoal
                            ? const Icon(Icons.flag, color: Colors.white, size: 20)
                            : (isHead && i != 0
                                ? const Icon(Icons.person, color: Colors.white, size: 20)
                                : null),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => setState(() => _path = [0]),
            child: const Text('إعادة المسار'),
          ),
        ],
      ),
    );
  }
}
