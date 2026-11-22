import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

const _icons = [
  Icons.star,
  Icons.favorite,
  Icons.bolt,
  Icons.eco,
  Icons.music_note,
  Icons.sports_soccer,
];

class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<MemoryMatchGame> createState() => _State();
}

class _State extends State<MemoryMatchGame> {
  bool _ready = true;
  List<int> _cards = [];
  final Set<int> _flipped = {};
  final Set<int> _matched = {};
  int _attempts = 0;
  int _flips = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _busy = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _ready = false;
    _cards = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5]..shuffle(Random());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    setState(() {});
  }

  void _tap(int i) {
    if (_busy || _matched.contains(i) || _flipped.contains(i)) return;
    setState(() {
      _flipped.add(i);
      _flips++;
    });
    if (_flipped.length == 2) {
      _attempts++;
      final list = _flipped.toList();
      if (_cards[list[0]] == _cards[list[1]]) {
        HapticFeedback.lightImpact();
        setState(() {
          _matched.addAll(list);
          _flipped.clear();
        });
        if (_matched.length == 12) {
          _timer?.cancel();
          final extraFlips = max(0, _flips - 12);
          final score = max(0, 6 * 20 - extraFlips);
          final acc = _attempts == 0 ? 100.0 : 6 / _attempts * 100;
          widget.onFinish(
            GameResult(
              score: score,
              maxScore: 120,
              accuracy: acc,
              xp: 10 + score ~/ 5,
              durationSec: _seconds,
              detailAr: 'وجدت كل الأزواج في $_attempts محاولة',
            ),
          );
        }
      } else {
        HapticFeedback.mediumImpact();
        _busy = true;
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          setState(() {
            _flipped.clear();
            _busy = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions: 'اقلب بطاقتين في كل مرة وجد الأزواج المتطابقة الستة.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الوقت: $_seconds ث  •  أزواج: ${_matched.length ~/ 2} من 6  •  محاولات: $_attempts',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                final show = _flipped.contains(i) || _matched.contains(i);
                return Material(
                  color: _matched.contains(i)
                      ? const Color(0xFF0E7C6B)
                      : (show ? const Color(0xFFF2A93B) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: show
                          ? Icon(
                              _icons[_cards[i]],
                              size: 32,
                              color: _matched.contains(i)
                                  ? Colors.white
                                  : const Color(0xFF14213D),
                            )
                          : const Icon(Icons.help_outline, color: Colors.grey),
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
