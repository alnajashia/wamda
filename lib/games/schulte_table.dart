import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SchulteTableGame extends StatefulWidget {
  const SchulteTableGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SchulteTableGame> createState() => _State();
}

class _State extends State<SchulteTableGame> {
  bool _ready = true;
  List<int> _nums = [];
  int _next = 1;
  int _mistakes = 0;
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _ready = false;
    _nums = List.generate(25, (i) => i + 1)..shuffle(Random());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    setState(() {});
  }

  void _tap(int n) {
    if (n == _next) {
      HapticFeedback.lightImpact();
      _next++;
      setState(() {});
      if (_next > 25) {
        _timer?.cancel();
        final score = max(0, 300 - _seconds * 2 - _mistakes * 10);
        final acc = (25 + _mistakes) == 0 ? 100.0 : 25 / (25 + _mistakes) * 100;
        widget.onFinish(
          GameResult(
            score: score,
            maxScore: 300,
            accuracy: acc,
            xp: 10 + score ~/ 5,
            durationSec: _seconds,
            detailAr: 'أكملت الجدول في $_seconds ثانية مع $_mistakes خطأ',
          ),
        );
      }
    } else {
      HapticFeedback.mediumImpact();
      setState(() {
        _mistakes++;
        _seconds += 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اضغط على الأرقام من 1 إلى 25 بالترتيب. كل خطأ يضيف ثانيتين.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('التالي: $_next  •  الوقت: $_seconds ث  •  أخطاء: $_mistakes'),
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
                final n = _nums[i];
                final done = n < _next;
                return Material(
                  color: done ? const Color(0xFF0E7C6B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _tap(n),
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Text(
                        '$n',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: done ? Colors.white : const Color(0xFF14213D),
                        ),
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
