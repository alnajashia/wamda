import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class LightsOutGame extends StatefulWidget {
  const LightsOutGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<LightsOutGame> createState() => _State();
}

class _State extends State<LightsOutGame> {
  bool _ready = true;
  List<bool> _board = List.filled(25, false);
  int _moves = 0;
  final _start = Stopwatch();

  void _toggle(List<bool> b, int idx) {
    final r = idx ~/ 5, c = idx % 5;
    void flip(int rr, int cc) {
      if (rr >= 0 && rr < 5 && cc >= 0 && cc < 5) {
        b[rr * 5 + cc] = !b[rr * 5 + cc];
      }
    }

    flip(r, c);
    flip(r - 1, c);
    flip(r + 1, c);
    flip(r, c - 1);
    flip(r, c + 1);
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _board = List.filled(25, false);
    final rand = Random();
    for (var i = 0; i < 8; i++) {
      _toggle(_board, rand.nextInt(25));
    }
    if (!_board.contains(true)) _toggle(_board, 12);
    setState(() {});
  }

  void _tap(int i) {
    HapticFeedback.lightImpact();
    setState(() {
      _toggle(_board, i);
      _moves++;
    });
    if (!_board.contains(true)) {
      _start.stop();
      final score = max(10, 100 - _moves);
      widget.onFinish(
        GameResult(
          score: score,
          maxScore: 100,
          accuracy: 100,
          xp: 15 + score ~/ 5,
          durationSec: _start.elapsed.inSeconds,
          detailAr: 'أطفأت كل الأضواء في $_moves حركة',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اضغط على خلية لتبديلها هي وجيرانها. الهدف إطفاء كل الأضواء.',
        onStart: _startGame,
      );
    }
    final lit = _board.where((v) => v).length;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الحركات: $_moves  •  أضواء مشتعلة: $lit'),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 25,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (_, i) {
                return Material(
                  color: _board[i]
                      ? const Color(0xFFF2A93B)
                      : const Color(0xFF14213D),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Icon(
                        Icons.lightbulb,
                        color: _board[i] ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
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
