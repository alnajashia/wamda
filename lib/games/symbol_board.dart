import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class SymbolBoardGame extends StatefulWidget {
  const SymbolBoardGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<SymbolBoardGame> createState() => _State();
}

class _State extends State<SymbolBoardGame> {
  static const _symbols = [Icons.star, Icons.favorite, Icons.bolt, Icons.eco];
  static const _palette = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
  ];
  static const _rounds = 6;

  bool _ready = true;
  int _round = 0;
  List<int> _legend = []; // symbol index -> color index
  List<int> _cells = []; // symbol per cell
  List<int> _assigned = []; // color per cell, -1 none
  int? _selectedCell;
  int _score = 0;
  int _mistakes = 0;
  String _msg = '';
  final _rand = Random();
  final _stopwatch = Stopwatch();

  void _startGame() {
    _ready = false;
    _round = 0;
    _score = 0;
    _mistakes = 0;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _newRound() {
    _legend = [0, 1, 2, 3]..shuffle(_rand);
    _cells = List.generate(9, (_) => _rand.nextInt(4));
    _assigned = List.filled(9, -1);
    _selectedCell = null;
    _msg = '';
  }

  void _assign(int color) {
    final cell = _selectedCell;
    if (cell == null) return;
    HapticFeedback.selectionClick();
    setState(() => _assigned[cell] = color);
    if (!_assigned.contains(-1)) _check();
  }

  void _check() {
    var ok = true;
    for (var i = 0; i < 9; i++) {
      if (_assigned[i] != _legend[_cells[i]]) ok = false;
    }
    if (!ok) {
      _mistakes++;
      HapticFeedback.mediumImpact();
      setState(() => _msg = 'بعض الخلايا بألوان خاطئة — راجع الدليل');
      return;
    }
    HapticFeedback.lightImpact();
    _score += 100;
    if (_round + 1 >= _rounds) {
      _stopwatch.stop();
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: _rounds * 100,
          accuracy: max(0, 100 - _mistakes * 10).toDouble(),
          xp: 15 + _score ~/ 10,
          durationSec: _stopwatch.elapsed.inSeconds,
          detailAr: 'أكملت $_rounds لوحات رموز • أخطاء: $_mistakes',
        ),
      );
    } else {
      setState(() {
        _round++;
        _newRound();
        _msg = 'أحسنت! الدليل تغيّر الآن';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'كل رمز مرتبط بلون في الدليل. اضغط خلية ثم اختر لونها الصحيح من الأسفل. الدليل يتغير كل جولة. 6 جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الجولة ${_round + 1}/$_rounds  •  النتيجة: $_score'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var s = 0; s < 4; s++)
                    Column(
                      children: [
                        Icon(_symbols[s], size: 30),
                        const SizedBox(height: 4),
                        Container(
                          width: 30,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _palette[_legend[s]],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (_, i) {
                    final a = _assigned[i];
                    return Material(
                      color: a < 0 ? Colors.white : _palette[a],
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => setState(() => _selectedCell = i),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _selectedCell == i ? Colors.black : Colors.grey.shade300,
                              width: _selectedCell == i ? 3 : 1,
                            ),
                          ),
                          child: Icon(
                            _symbols[_cells[i]],
                            size: 36,
                            color: a < 0 ? Colors.black87 : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (_msg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_msg, style: const TextStyle(color: Color(0xFFE4572E))),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var c = 0; c < 4; c++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => _assign(c),
                    child: Container(
                      width: 56,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _palette[c],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
