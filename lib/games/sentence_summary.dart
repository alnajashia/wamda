import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/arabic_words.dart';
import 'shared/game_shell.dart';

class SentenceSummaryGame extends StatefulWidget {
  const SentenceSummaryGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SentenceSummaryGame> createState() => _State();
}

class _State extends State<SentenceSummaryGame> {
  static const _totalRounds = 10;

  bool _ready = true;
  List<SentenceItem> _items = [];
  int _round = 0;
  List<String> _options = [];
  int _answer = 0;
  int? _picked;
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _items = List.of(sentences)..shuffle(_rand);
    _items = _items.take(_totalRounds).toList();
    _round = 0;
    _correct = 0;
    _wrong = 0;
    _score = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    final item = _items[_round];
    _options = [item.summary, ...item.distractors]..shuffle(_rand);
    _answer = _options.indexOf(item.summary);
    _picked = null;
  }

  void _pick(int i) {
    if (_picked != null) return;
    if (i == _answer) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 25;
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
    }
    setState(() => _picked = i);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _round++;
      if (_round >= _totalRounds) {
        _stopwatch.stop();
        final total = _correct + _wrong;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _totalRounds * 25,
            accuracy: total == 0 ? 0 : _correct / total * 100,
            xp: 10 + _score ~/ 10,
            durationSec: _stopwatch.elapsed.inSeconds,
            detailAr: 'إجابات صحيحة: $_correct من $_totalRounds',
          ),
        );
      } else {
        setState(_newRound);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اقرأ الجملة واختر الخيار الذي يلخصها بكلمات أقل دون تغيير معناها. احذر الخيارات الطويلة أو التي تغيّر المعنى. 10 جولات.',
        onStart: _startGame,
      );
    }
    final item = _items[_round];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1} من $_totalRounds  •  النتيجة: $_score'),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                item.sentence,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: WamdaColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('اختر أفضل اختصار:'),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < _options.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Material(
                        color: _picked == null
                            ? Colors.white
                            : (i == _answer
                                ? Colors.green.shade100
                                : (_picked == i
                                    ? Colors.red.shade100
                                    : Colors.white)),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _pick(i),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Text(
                              _options[i],
                              style: const TextStyle(
                                fontSize: 17,
                                color: WamdaColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
