import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SequenceMemoryGame extends StatefulWidget {
  const SequenceMemoryGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SequenceMemoryGame> createState() => _State();
}

class _State extends State<SequenceMemoryGame> {
  bool _ready = true;
  final List<int> _seq = [];
  int _inputIdx = 0;
  int _flash = -1;
  bool _showing = false;
  int _correctTaps = 0;
  int _longest = 0;
  final _rand = Random();
  final _start = Stopwatch();

  Future<void> _showSeq() async {
    setState(() {
      _showing = true;
      _inputIdx = 0;
    });
    for (final v in _seq) {
      setState(() => _flash = v);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _flash = -1);
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
    }
    setState(() => _showing = false);
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _seq.clear();
    for (var i = 0; i < 3; i++) {
      _seq.add(_rand.nextInt(9));
    }
    _showSeq();
  }

  void _tap(int i) {
    if (_showing) return;
    if (i == _seq[_inputIdx]) {
      HapticFeedback.lightImpact();
      _correctTaps++;
      _inputIdx++;
      if (_inputIdx == _seq.length) {
        _longest = _seq.length;
        _seq.add(_rand.nextInt(9));
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _showSeq();
        });
      }
    } else {
      HapticFeedback.mediumImpact();
      _start.stop();
      final score = _longest * 20 + _correctTaps;
      final acc = (_correctTaps + 1) == 0
          ? 0.0
          : _correctTaps / (_correctTaps + 1) * 100;
      widget.onFinish(
        GameResult(
          score: score,
          maxScore: 300,
          accuracy: acc,
          xp: 10 + score ~/ 5,
          durationSec: _start.elapsed.inSeconds,
          detailAr: 'أطول تسلسل أكملته: $_longest',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'شاهد التسلسل المضيء ثم كرره بالترتيب. خطأ واحد ينهي اللعبة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'طول التسلسل: ${_seq.length}  •  ${_showing ? 'شاهد...' : 'كرر التسلسل'}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, i) {
                final lit = _flash == i;
                return Material(
                  color: lit
                      ? const Color(0xFFF2A93B)
                      : const Color(0xFF0E7C6B),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(16),
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
