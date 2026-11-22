import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class MemoryMatrixGame extends StatefulWidget {
  const MemoryMatrixGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MemoryMatrixGame> createState() => _State();
}

class _State extends State<MemoryMatrixGame> {
  bool _ready = true;
  int _round = 0;
  int _grid = 3;
  int _tiles = 2;
  Set<int> _pattern = {};
  Set<int> _tapped = {};
  bool _showing = false;
  int _score = 0;
  int _correctTiles = 0;
  int _totalTiles = 0;
  final _start = Stopwatch();

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  void _nextRound() {
    _round++;
    if (_round == 3) _grid = 4;
    if (_round == 5) _grid = 5;
    final rand = Random();
    final cells = List.generate(_grid * _grid, (i) => i)..shuffle(rand);
    _pattern = cells.take(_tiles).toSet();
    _tapped = {};
    _totalTiles += _tiles;
    setState(() => _showing = true);
    Future.delayed(Duration(milliseconds: 1500 + 200 * _tiles), () {
      if (mounted) setState(() => _showing = false);
    });
  }

  void _tap(int i) {
    if (_showing) return;
    if (_tapped.contains(i)) return;
    setState(() => _tapped.add(i));
    if (_pattern.contains(i)) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    if (_tapped.length == _tiles) {
      final correct = _tapped.intersection(_pattern).length;
      _correctTiles += correct;
      if (correct == _tiles) {
        _score += 10 + _tiles * 5;
        _tiles++;
      }
      if (_round >= 5) {
        _start.stop();
        final acc = _totalTiles == 0 ? 0.0 : _correctTiles / _totalTiles * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 100,
            accuracy: acc,
            xp: 10 + _score ~/ 5,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'أكملت 5 جولات في مصفوفة الذاكرة',
          ),
        );
      } else {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _nextRound();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'احفظ الخلايا المضيئة ثم اضغط عليها بعد اختفائها. 5 جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة $_round من 5  •  النقاط: $_score',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(_showing ? 'احفظ النمط...' : 'اضغط على الخلايا التي كانت مضيئة'),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _grid * _grid,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _grid,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                final lit = _showing && _pattern.contains(i);
                final picked = _tapped.contains(i);
                final correctPick = picked && _pattern.contains(i);
                Color bg = Colors.white;
                if (lit) bg = const Color(0xFF0E7C6B);
                if (picked) {
                  bg = correctPick
                      ? const Color(0xFF0E7C6B)
                      : Colors.red.shade300;
                }
                return Material(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(12),
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
