import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class TowerOfHanoiGame extends StatefulWidget {
  const TowerOfHanoiGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<TowerOfHanoiGame> createState() => _State();
}

class _State extends State<TowerOfHanoiGame> {
  bool _ready = true;
  int _disks = 4;
  List<List<int>> _pegs = [[], [], []];
  int? _selectedPeg;
  int _moves = 0;
  final _start = Stopwatch();

  int get _optimal => (1 << _disks) - 1;

  void _startGame() {
    _ready = false;
    _start.start();
    _pegs = [List.generate(_disks, (i) => _disks - i), [], []];
    setState(() {});
  }

  void _tapPeg(int peg) {
    if (_selectedPeg == null) {
      if (_pegs[peg].isEmpty) return;
      setState(() => _selectedPeg = peg);
    } else {
      if (_selectedPeg == peg) {
        setState(() => _selectedPeg = null);
        return;
      }
      final disk = _pegs[_selectedPeg!].last;
      if (_pegs[peg].isEmpty || _pegs[peg].last > disk) {
        HapticFeedback.lightImpact();
        setState(() {
          _pegs[_selectedPeg!].removeLast();
          _pegs[peg].add(disk);
          _moves++;
          _selectedPeg = null;
        });
        if (_pegs[2].length == _disks) {
          _start.stop();
          final score = max(10, 100 - (_moves - _optimal) * 2);
          final acc = _moves == 0 ? 100.0 : _optimal / _moves * 100;
          widget.onFinish(
            GameResult(
              score: score,
              maxScore: 100,
              accuracy: acc.clamp(0, 100).toDouble(),
              xp: 15 + score ~/ 5,
              durationSec: _start.elapsed.inSeconds,
              detailAr: 'نقلت البرج في $_moves حركة (الأمثل: $_optimal)',
            ),
          );
        }
      } else {
        HapticFeedback.mediumImpact();
        setState(() => _selectedPeg = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'انقل كل الأقراص إلى العمود الأيمن. لا تضع قرصاً كبيراً فوق صغير. اضغط عموداً لالتقاط قرص ثم اضغط عموداً لوضعه.',
        onStart: _startGame,
        extra: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final n in [3, 4, 5])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text('$n أقراص'),
                  selected: _disks == n,
                  onSelected: (_) => setState(() => _disks = n),
                ),
              ),
          ],
        ),
      );
    }
    const colors = [
      Color(0xFFE4572E),
      Color(0xFFF2A93B),
      Color(0xFF0E7C6B),
      Color(0xFF2563EB),
      Color(0xFF7C5CBF),
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('الحركات: $_moves  •  الأمثل: $_optimal'),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var p = 0; p < 3; p++)
                  Expanded(
                    child: InkWell(
                      onTap: () => _tapPeg(p),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: _selectedPeg == p
                              ? const Color(0xFFF2A93B).withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPeg == p
                                ? const Color(0xFFF2A93B)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (final d in _pegs[p].reversed)
                              Container(
                                height: 26,
                                width: 30.0 + d * 18,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors[(d - 1) % colors.length],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            Container(
                              height: 8,
                              color: Colors.grey.shade700,
                              margin: const EdgeInsets.only(top: 4),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                p == 0 ? 'يسار' : (p == 1 ? 'وسط' : 'يمين'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
