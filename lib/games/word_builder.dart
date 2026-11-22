import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/arabic_words.dart';
import 'shared/game_shell.dart';

class _Tile {
  _Tile(this.letter);
  final String letter;
  bool used = false;
}

class WordBuilderGame extends StatefulWidget {
  const WordBuilderGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<WordBuilderGame> createState() => _State();
}

class _State extends State<WordBuilderGame> {
  static const _durationSec = 90;

  bool _ready = true;
  List<_Tile> _tiles = [];
  final List<int> _current = [];
  final Set<String> _found = {};
  final List<String> _foundList = [];
  List<String> _possible = [];
  int _score = 0;
  int _timeLeft = _durationSec;
  String _feedback = '';
  bool _feedbackGood = true;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setup() {
    // Pick a seed word (5-7 letters) that yields at least 4 bank words.
    final seeds = wordBank.where((w) {
      final l = w.runes.length;
      return l >= 5 && l <= 7;
    }).toList()
      ..shuffle(_rand);
    String seed = seeds.first;
    List<String> possible = possibleWords(lettersOf(seed));
    for (final s in seeds) {
      final p = possibleWords(lettersOf(s));
      if (p.length >= 4) {
        seed = s;
        possible = p;
        break;
      }
      if (p.length > possible.length) {
        seed = s;
        possible = p;
      }
    }
    _possible = possible;
    _tiles = lettersOf(seed).map(_Tile.new).toList()..shuffle(_rand);
    _current.clear();
    _found.clear();
    _foundList.clear();
    _score = 0;
    _timeLeft = _durationSec;
    _feedback = '';
  }

  void _startGame() {
    _ready = false;
    _setup();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) _finish();
    });
    setState(() {});
  }

  void _finish() {
    _timer?.cancel();
    _stopwatch.stop();
    final maxScore = _possible.fold(0, (s, w) => s + wordScore(w.runes.length));
    final acc =
        _possible.isEmpty ? 0.0 : _found.length / _possible.length * 100;
    widget.onFinish(
      GameResult(
        score: _score,
        maxScore: max(maxScore, 1),
        accuracy: min(acc, 100),
        xp: 10 + _score ~/ 10,
        durationSec: _stopwatch.elapsed.inSeconds,
        detailAr: 'وجدت ${_found.length} من ${_possible.length} كلمة ممكنة',
      ),
    );
  }

  void _say(String msg, bool good) {
    setState(() {
      _feedback = msg;
      _feedbackGood = good;
    });
  }

  void _tapTile(int i) {
    if (_tiles[i].used) return;
    HapticFeedback.selectionClick();
    setState(() {
      _tiles[i].used = true;
      _current.add(i);
    });
  }

  void _backspace() {
    if (_current.isEmpty) return;
    setState(() {
      _tiles[_current.removeLast()].used = false;
    });
  }

  void _clear() {
    setState(() {
      for (final i in _current) {
        _tiles[i].used = false;
      }
      _current.clear();
    });
  }

  void _submit() {
    final word = _current.map((i) => _tiles[i].letter).join();
    if (word.runes.length < 3) {
      _say('الكلمة قصيرة! 3 أحرف على الأقل', false);
      return;
    }
    if (_found.contains(word)) {
      HapticFeedback.mediumImpact();
      _say('وجدتها من قبل!', false);
      _clear();
      return;
    }
    if (wordBankSet.contains(word)) {
      HapticFeedback.lightImpact();
      final pts = wordScore(word.runes.length);
      setState(() {
        _score += pts;
        _found.add(word);
        _foundList.add(word);
      });
      _say('أحسنت! +$pts نقطة', true);
      _clear();
      if (_found.length >= _possible.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _finish();
        });
      }
    } else {
      HapticFeedback.mediumImpact();
      _say('ليست كلمة صحيحة', false);
      _clear();
    }
  }

  String get _currentWord => _current.map((i) => _tiles[i].letter).join();

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'كوّن كلمات عربية صحيحة من الحروف المعطاة بالضغط عليها. كلما طالت الكلمة زادت نقاطها. اعثر على أكبر عدد ممكن خلال 90 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الوقت: $_timeLeft ث  •  النقاط: $_score  •  وجدت: ${_found.length}/${_possible.length}',
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _timeLeft / _durationSec,
            color: WamdaColors.language,
            backgroundColor: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 16),
          Container(
            height: 64,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Center(
              child: Text(
                _currentWord.isEmpty ? 'كوّن كلمة' : _currentWord,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: _currentWord.isEmpty
                      ? Colors.grey
                      : WamdaColors.ink,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                _feedback,
                style: TextStyle(
                  color: _feedbackGood ? Colors.green.shade700 : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < _tiles.length; i++)
                Material(
                  color: _tiles[i].used
                      ? const Color(0xFFE5E7EB)
                      : WamdaColors.language,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _tapTile(i),
                    child: SizedBox(
                      width: 58,
                      height: 58,
                      child: Center(
                        child: Text(
                          _tiles[i].letter,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _tiles[i].used
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: _submit,
                child: const Text('تأكيد'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _backspace,
                child: const Icon(Icons.backspace),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _clear,
                child: const Text('مسح'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final w in _foundList)
                    Chip(
                      label: Text(w),
                      backgroundColor: Colors.green.shade100,
                      side: BorderSide.none,
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
