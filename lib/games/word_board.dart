import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/arabic_words.dart';
import 'shared/game_shell.dart';

class WordBoardGame extends StatefulWidget {
  const WordBoardGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<WordBoardGame> createState() => _State();
}

class _State extends State<WordBoardGame> {
  static const _size = 4;
  static const _durationSec = 90;

  bool _ready = true;
  List<String> _cells = [];
  List<String> _placedWords = [];
  final List<int> _path = [];
  final Set<String> _found = {};
  final List<String> _foundList = [];
  int _score = 0;
  int _submissions = 0;
  int _correctSubs = 0;
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

  void _startGame() {
    _ready = false;
    final grid = generateBoggleGrid(rand: _rand);
    _cells = grid.cells;
    _placedWords = grid.placedWords;
    _path.clear();
    _found.clear();
    _foundList.clear();
    _score = 0;
    _submissions = 0;
    _correctSubs = 0;
    _timeLeft = _durationSec;
    _feedback = '';
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
    final maxScore =
        _placedWords.fold(0, (s, w) => s + wordScore(w.runes.length));
    final acc =
        _submissions == 0 ? 0.0 : _correctSubs / _submissions * 100;
    widget.onFinish(
      GameResult(
        score: _score,
        maxScore: max(maxScore, 1),
        accuracy: acc,
        xp: 10 + _score ~/ 10,
        durationSec: _stopwatch.elapsed.inSeconds,
        detailAr: 'وجدت ${_found.length} كلمة في اللوحة',
      ),
    );
  }

  bool _adjacent(int a, int b) {
    final ra = a ~/ _size, ca = a % _size;
    final rb = b ~/ _size, cb = b % _size;
    return (ra - rb).abs() <= 1 && (ca - cb).abs() <= 1 && a != b;
  }

  void _say(String msg, bool good) {
    setState(() {
      _feedback = msg;
      _feedbackGood = good;
    });
  }

  void _tapCell(int i) {
    if (_path.isNotEmpty && i == _path.last) {
      _submit();
      return;
    }
    final at = _path.indexOf(i);
    if (at >= 0) {
      // Rewind the path back to this cell.
      setState(() => _path.removeRange(at + 1, _path.length));
      return;
    }
    if (_path.isEmpty || _adjacent(_path.last, i)) {
      HapticFeedback.selectionClick();
      setState(() => _path.add(i));
    } else {
      HapticFeedback.mediumImpact();
      _say('اختر حرفاً مجاوراً لآخر حرف', false);
    }
  }

  String get _currentWord => _path.map((i) => _cells[i]).join();

  void _submit() {
    final word = _currentWord;
    if (word.runes.length < 3) {
      _say('الكلمة قصيرة! 3 أحرف على الأقل', false);
      return;
    }
    _submissions++;
    if (_found.contains(word)) {
      HapticFeedback.mediumImpact();
      _say('وجدتها من قبل!', false);
    } else if (wordBankSet.contains(word)) {
      HapticFeedback.lightImpact();
      _correctSubs++;
      final pts = wordScore(word.runes.length);
      setState(() {
        _score += pts;
        _found.add(word);
        _foundList.add(word);
      });
      _say('أحسنت! +$pts نقطة', true);
    } else {
      HapticFeedback.mediumImpact();
      _say('ليست كلمة صحيحة', false);
    }
    setState(() => _path.clear());
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اضغط على الحروف المتجاورة (بما فيها القطرية) لتكوين كلمات عربية صحيحة، ثم اضغط تأكيد أو آخر حرف. لديك 90 ثانية.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الوقت: $_timeLeft ث  •  النقاط: $_score  •  وجدت: ${_found.length} كلمة',
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _timeLeft / _durationSec,
            color: WamdaColors.language,
            backgroundColor: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 16),
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Center(
              child: Text(
                _currentWord.isEmpty ? 'ابنِ كلمة من اللوحة' : _currentWord,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color:
                      _currentWord.isEmpty ? Colors.grey : WamdaColors.ink,
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
                  color: _feedbackGood
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: _size,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (var i = 0; i < _cells.length; i++)
                Material(
                  color: _path.contains(i)
                      ? (i == _path.last
                          ? WamdaColors.amber
                          : WamdaColors.language)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _tapCell(i),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Center(
                        child: Text(
                          _cells[i],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _path.contains(i)
                                ? Colors.white
                                : WamdaColors.ink,
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
              FilledButton(onPressed: _submit, child: const Text('تأكيد')),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => setState(() => _path.clear()),
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
