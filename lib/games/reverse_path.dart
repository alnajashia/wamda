import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class ReversePathGame extends StatefulWidget {
  const ReversePathGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<ReversePathGame> createState() => _State();
}

class _State extends State<ReversePathGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 8;
  static const _grid = 4;
  List<int> _sequence = [];
  int _showIndex = -1; // currently highlighted during playback
  bool _playing = false;
  int _inputPos = 0; // index into reversed sequence
  Set<int> _tappedOk = {};
  int _score = 0;
  int _perfectRounds = 0;
  int _correctTaps = 0;
  int _totalTaps = 0;
  final _rand = Random();
  final _start = Stopwatch();

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  Future<void> _nextRound() async {
    _round++;
    final len = 3 + _round; // 4..11 -> cap 9
    final n = len > 9 ? 9 : len;
    _sequence = [];
    while (_sequence.length < n) {
      final c = _rand.nextInt(_grid * _grid);
      if (_sequence.isEmpty || _sequence.last != c) _sequence.add(c);
    }
    _inputPos = 0;
    _tappedOk = {};
    setState(() => _playing = true);
    for (var i = 0; i < _sequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() => _showIndex = i);
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      setState(() => _showIndex = -1);
    }
    if (mounted) setState(() => _playing = false);
  }

  void _tap(int i) {
    if (_playing) return;
    final expected = _sequence[_sequence.length - 1 - _inputPos];
    _totalTaps++;
    if (i == expected) {
      _correctTaps++;
      _inputPos++;
      _score += 10;
      setState(() => _tappedOk.add(i));
      HapticFeedback.lightImpact();
      if (_inputPos >= _sequence.length) {
        _perfectRounds++;
        _score += 20;
        _advance();
      }
    } else {
      HapticFeedback.mediumImpact();
      _advance();
    }
  }

  void _advance() {
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        final acc = _totalTaps == 0 ? 0.0 : _correctTaps / _totalTaps * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: 800,
            accuracy: acc,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'جولات كاملة بلا خطأ: $_perfectRounds من $_rounds',
          ),
        );
      } else {
        _nextRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'شاهد المسار وهو يتحرك خلية بعد خلية، ثم اضغط على الخلايا بالترتيب العكسي تماماً. 8 جولات والمسار يطول.',
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
          const SizedBox(height: 8),
          Text(
            _playing
                ? 'شاهد المسار...'
                : 'الآن بالعكس! ($_inputPos/${_sequence.length})',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _grid * _grid,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _grid,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                Color bg = Colors.white;
                if (_showIndex >= 0 && _sequence[_showIndex] == i) {
                  bg = const Color(0xFFF2A93B);
                }
                if (_tappedOk.contains(i)) bg = const Color(0xFF0E7C6B);
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
