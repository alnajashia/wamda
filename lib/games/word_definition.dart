import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/arabic_words.dart';
import 'shared/game_shell.dart';

class WordDefinitionGame extends StatefulWidget {
  const WordDefinitionGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<WordDefinitionGame> createState() => _State();
}

class _State extends State<WordDefinitionGame> {
  static const _totalRounds = 12;
  static const _roundSec = 15;

  bool _ready = true;
  List<DefinitionItem> _items = [];
  int _round = 0;
  List<String> _options = [];
  int _answer = 0;
  int? _picked;
  bool _timedOut = false;
  int _timeLeft = _roundSec;
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _ready = false;
    _items = List.of(definitions)..shuffle(_rand);
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
    _options = [item.word, ...item.distractors]..shuffle(_rand);
    _answer = _options.indexOf(item.word);
    _picked = null;
    _timedOut = false;
    _timeLeft = _roundSec;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) _onTimeout();
    });
  }

  void _onTimeout() {
    if (_picked != null || _timedOut) return;
    _timer?.cancel();
    HapticFeedback.mediumImpact();
    _wrong++;
    setState(() => _timedOut = true);
    _advance();
  }

  void _pick(int i) {
    if (_picked != null || _timedOut) return;
    _timer?.cancel();
    if (i == _answer) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 20 + _timeLeft;
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
    }
    setState(() => _picked = i);
    _advance();
  }

  void _advance() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _round++;
      if (_round >= _totalRounds) {
        _stopwatch.stop();
        final total = _correct + _wrong;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _totalRounds * (20 + _roundSec),
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
            'اقرأ التعريف واختر الكلمة الصحيحة من الخيارات الأربعة. 12 جولة، ولديك 15 ثانية لكل جولة — كلما أسرعت زادت نقاطك.',
        onStart: _startGame,
      );
    }
    final item = _items[_round];
    final revealed = _picked != null || _timedOut;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة ${_round + 1} من $_totalRounds  •  النتيجة: $_score  •  الوقت: $_timeLeft',
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _timeLeft / _roundSec,
            color: WamdaColors.language,
            backgroundColor: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                item.definition,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: WamdaColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('ما الكلمة؟'),
          const SizedBox(height: 12),
          for (var i = 0; i < _options.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Material(
                color: !revealed
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      _options[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: WamdaColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
