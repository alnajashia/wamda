import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../core/models.dart';
import 'shared/arabic_words.dart';
import 'shared/game_shell.dart';

class LostWordsGame extends StatefulWidget {
  const LostWordsGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<LostWordsGame> createState() => _State();
}

class _State extends State<LostWordsGame> {
  static const _sizes = [8, 8, 9, 9, 10];
  static const _counts = [5, 6, 6, 7, 8];
  static const _totalRounds = 5;

  bool _ready = true;
  WordSearchPuzzle? _puzzle;
  int _round = 0;
  final Set<String> _foundWords = {};
  final Set<int> _foundCells = {};
  int? _startCell;
  int _wrongTaps = 0;
  int _totalWords = 0;
  int _score = 0;
  String _feedback = '';
  bool _feedbackGood = true;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _wrongTaps = 0;
    _totalWords = 0;
    _score = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    _puzzle = generateWordSearch(
      size: _sizes[_round],
      wordCount: _counts[_round],
      rand: _rand,
    );
    _totalWords += _puzzle!.words.length;
    _foundWords.clear();
    _foundCells.clear();
    _startCell = null;
    _feedback = '';
  }

  void _say(String msg, bool good) {
    setState(() {
      _feedback = msg;
      _feedbackGood = good;
    });
  }

  void _tapCell(int idx) {
    final puzzle = _puzzle!;
    final size = puzzle.size;
    if (_startCell == null) {
      HapticFeedback.selectionClick();
      setState(() => _startCell = idx);
      return;
    }
    if (idx == _startCell) {
      setState(() => _startCell = null);
      return;
    }
    final r1 = _startCell! ~/ size, c1 = _startCell! % size;
    final r2 = idx ~/ size, c2 = idx % size;
    if (r1 != r2 && c1 != c2) {
      // Not a straight line: start a new selection here.
      HapticFeedback.selectionClick();
      setState(() => _startCell = idx);
      return;
    }
    final cells = <int>[];
    final dr = (r2 - r1).sign;
    final dc = (c2 - c1).sign;
    var r = r1, c = c1;
    while (true) {
      cells.add(r * size + c);
      if (r == r2 && c == c2) break;
      r += dr;
      c += dc;
    }
    final letters = cells.map((i) => puzzle.grid[i ~/ size][i % size]).join();
    final reversed = lettersOf(letters).reversed.join();
    String? hit;
    for (final w in puzzle.words) {
      if (_foundWords.contains(w)) continue;
      if (w == letters || w == reversed) {
        hit = w;
        break;
      }
    }
    if (hit != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _foundWords.add(hit!);
        _foundCells.addAll(puzzle.placements[hit]!);
        _score += 20;
        _startCell = null;
      });
      _say('وجدت «$hit»! +20 نقطة', true);
      if (_foundWords.length >= puzzle.words.length) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          _round++;
          if (_round >= _totalRounds) {
            _finish();
          } else {
            setState(_newRound);
          }
        });
      }
    } else {
      HapticFeedback.mediumImpact();
      _wrongTaps++;
      setState(() => _startCell = null);
      _say('ليست كلمة مخبأة، حاول مرة أخرى', false);
    }
  }

  void _finish() {
    _stopwatch.stop();
    final found = _totalWords;
    final attempts = found + _wrongTaps;
    widget.onFinish(
      GameResult(
        score: _score,
        maxScore: max(_totalWords * 20, 1),
        accuracy: attempts == 0 ? 0 : found / attempts * 100,
        xp: 10 + _score ~/ 10,
        durationSec: _stopwatch.elapsed.inSeconds,
        detailAr: 'وجدت كل الكلمات في $_totalRounds جولات',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'اعثر على الكلمات المخبأة في شبكة الحروف: اضغط أول حرف ثم آخر حرف من الكلمة. الكلمات أفقية أو عمودية. 5 جولات والشبكة تكبر تدريجياً.',
        onStart: _startGame,
      );
    }
    final puzzle = _puzzle!;
    final size = puzzle.size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة ${_round + 1} من $_totalRounds  •  النتيجة: $_score  •  وجدت: ${_foundWords.length}/${puzzle.words.length}',
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
            crossAxisCount: size,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            children: [
              for (var i = 0; i < size * size; i++)
                Material(
                  color: _foundCells.contains(i)
                      ? WamdaColors.language
                      : (i == _startCell
                          ? WamdaColors.amber
                          : Colors.white),
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _tapCell(i),
                    child: Center(
                      child: Text(
                        puzzle.grid[i ~/ size][i % size],
                        style: TextStyle(
                          fontSize: size >= 10 ? 15 : 17,
                          fontWeight: FontWeight.bold,
                          color: (_foundCells.contains(i) || i == _startCell)
                              ? Colors.white
                              : WamdaColors.ink,
                        ),
                      ),
                    ),
                  ),
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
                  for (final w in puzzle.words)
                    Chip(
                      label: Text(
                        w,
                        style: TextStyle(
                          decoration: _foundWords.contains(w)
                              ? TextDecoration.lineThrough
                              : null,
                          color: _foundWords.contains(w)
                              ? Colors.grey
                              : WamdaColors.ink,
                        ),
                      ),
                      backgroundColor: _foundWords.contains(w)
                          ? Colors.green.shade100
                          : Colors.white,
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
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
