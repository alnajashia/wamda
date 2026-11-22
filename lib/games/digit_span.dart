import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class DigitSpanGame extends StatefulWidget {
  const DigitSpanGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<DigitSpanGame> createState() => _State();
}

class _State extends State<DigitSpanGame> {
  bool _ready = true;
  int _len = 3;
  List<int> _digits = [];
  int _showIdx = -1;
  bool _showing = false;
  String _entered = '';
  int _lives = 3;
  int _score = 0;
  int _correct = 0;
  int _attempts = 0;
  final _rand = Random();
  final _start = Stopwatch();

  Future<void> _newSeq() async {
    _digits = List.generate(_len, (_) => _rand.nextInt(10));
    _entered = '';
    setState(() => _showing = true);
    for (var i = 0; i < _digits.length; i++) {
      setState(() => _showIdx = i);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
    }
    setState(() {
      _showing = false;
      _showIdx = -1;
    });
  }

  void _startGame() {
    _ready = false;
    _start.start();
    _newSeq();
  }

  void _press(String d) {
    if (_showing) return;
    setState(() => _entered += d);
    if (_entered.length == _len) {
      _attempts++;
      if (_entered == _digits.join()) {
        HapticFeedback.lightImpact();
        _correct++;
        _score += _len * 10;
        _len++;
      } else {
        HapticFeedback.mediumImpact();
        _lives--;
        if (_lives <= 0) {
          _start.stop();
          final acc = _attempts == 0 ? 0.0 : _correct / _attempts * 100;
          widget.onFinish(
            GameResult(
              score: _score,
              maxScore: 200,
              accuracy: acc,
              xp: 10 + _score ~/ 5,
              durationSec: _start.elapsed.inSeconds,
              detailAr: 'وصلت إلى طول $_len أرقام',
            ),
          );
          return;
        }
      }
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _newSeq();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'ستظهر الأرقام واحداً تلو الآخر. اكتبها بالترتيب. لديك 3 محاولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الطول: $_len  •  المحاولات المتبقية: $_lives  •  النقاط: $_score',
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: Center(
              child: _showing && _showIdx >= 0
                  ? Text(
                      '${_digits[_showIdx]}',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E7C6B),
                      ),
                    )
                  : Text(
                      _entered.isEmpty ? 'اكتب الأرقام' : _entered,
                      style: const TextStyle(fontSize: 32, letterSpacing: 4),
                    ),
            ),
          ),
          const Spacer(),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 1; i <= 9; i++)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: FilledButton(
                    onPressed: () => _press('$i'),
                    child: Text('$i'),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    if (_entered.isNotEmpty) {
                      _entered = _entered.substring(0, _entered.length - 1);
                    }
                  }),
                  child: const Icon(Icons.backspace),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: FilledButton(
                  onPressed: () => _press('0'),
                  child: const Text('0'),
                ),
              ),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
