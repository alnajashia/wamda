import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class _Item {
  const _Item(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _allItems = [
  _Item('كتاب', Icons.menu_book),
  _Item('نظارة', Icons.visibility),
  _Item('مفتاح', Icons.key),
  _Item('هاتف', Icons.smartphone),
  _Item('قبعة', Icons.face),
  _Item('فرشاة أسنان', Icons.brush),
  _Item('كوب', Icons.coffee),
  _Item('ساعة', Icons.watch),
  _Item('محفظة', Icons.wallet),
  _Item('قلم', Icons.edit),
  _Item('كاميرا', Icons.camera_alt),
  _Item('سماعات', Icons.headphones),
  _Item('مظلة', Icons.umbrella),
  _Item('حقيبة صغيرة', Icons.work),
  _Item('زجاجة ماء', Icons.water_drop),
  _Item('شاحن', Icons.battery_charging_full),
];

class TravelBagGame extends StatefulWidget {
  const TravelBagGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<TravelBagGame> createState() => _State();
}

class _State extends State<TravelBagGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 8;
  Set<int> _bag = {};
  List<int> _options = [];
  Set<int> _selected = {};
  bool _studying = false;
  int _score = 0;
  int _correctPicks = 0;
  int _totalBagItems = 0;
  final _rand = Random();
  final _start = Stopwatch();

  void _startGame() {
    _ready = false;
    _start.start();
    _nextRound();
  }

  void _nextRound() {
    _round++;
    final n = 3 + _round; // 4..11 -> cap 8
    final bagCount = n > 8 ? 8 : n;
    final idx = List.generate(_allItems.length, (i) => i)..shuffle(_rand);
    _bag = idx.take(bagCount).toSet();
    _totalBagItems += bagCount;
    _options = List.generate(_allItems.length, (i) => i)..shuffle(_rand);
    _selected = {};
    setState(() => _studying = true);
    Future.delayed(Duration(milliseconds: 3000 + bagCount * 400), () {
      if (mounted) setState(() => _studying = false);
    });
  }

  void _toggle(int i) {
    if (_studying) return;
    setState(() {
      if (_selected.contains(i)) {
        _selected.remove(i);
      } else {
        _selected.add(i);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _confirm() {
    final correct = _selected.intersection(_bag).length;
    final wrong = _selected.difference(_bag).length;
    _correctPicks += correct;
    _score += correct * 10 - wrong * 5;
    if (_score < 0) _score = 0;
    if (correct == _bag.length && wrong == 0) _score += 15;
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        final acc = _totalBagItems == 0 ? 0.0 : _correctPicks / _totalBagItems * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _totalBagItems * 10 + _rounds * 15,
            accuracy: acc,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'تذكرت $_correctPicks من $_totalBagItems غرضاً',
          ),
        );
      } else {
        _nextRound();
      }
    });
  }

  Widget _chip(int i, {required bool selectable}) {
    final item = _allItems[i];
    final selected = _selected.contains(i);
    return Material(
      color: selected ? const Color(0xFF0E7C6B) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: selectable ? () => _toggle(i) : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? const Color(0xFF0E7C6B) : const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 26,
                color: selected ? Colors.white : const Color(0xFF14213D),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? Colors.white : const Color(0xFF14213D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'احفظ الأغراض التي في حقيبة السفر، ثم اخترها من بين كل الأغراض. 8 جولات والأغراض تزداد.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة $_round من $_rounds  •  النقاط: $_score',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (_studying) ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.luggage, color: Color(0xFFF2A93B)),
                SizedBox(width: 8),
                Text('في الحقيبة الآن... احفظها!'),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [for (final i in _bag) _chip(i, selectable: false)],
            ),
          ] else ...[
            Text('اختر ما كان في الحقيبة (${_selected.length}/${_bag.length})'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [for (final i in _options) _chip(i, selectable: true)],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _selected.isEmpty ? null : _confirm,
              child: const Text('تأكيد'),
            ),
          ],
        ],
      ),
    );
  }
}
