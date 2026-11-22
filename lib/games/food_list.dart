import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class _Food {
  const _Food(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _allFoods = [
  _Food('خبز', Icons.bakery_dining),
  _Food('حليب', Icons.local_drink),
  _Food('بيض', Icons.egg),
  _Food('جبن', Icons.lunch_dining),
  _Food('تفاح', Icons.apple),
  _Food('موز', Icons.restaurant),
  _Food('أرز', Icons.rice_bowl),
  _Food('تمر', Icons.spa),
  _Food('عسل', Icons.hexagon),
  _Food('زيت', Icons.opacity),
  _Food('سكر', Icons.grain),
  _Food('شاي', Icons.emoji_food_beverage),
  _Food('قهوة', Icons.coffee),
  _Food('عصير', Icons.local_bar),
  _Food('لحم', Icons.kebab_dining),
  _Food('سمك', Icons.set_meal),
  _Food('بطاطس', Icons.fastfood),
  _Food('طماطم', Icons.circle),
  _Food('خيار', Icons.eco),
  _Food('عنب', Icons.bubble_chart),
];

class FoodListGame extends StatefulWidget {
  const FoodListGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<FoodListGame> createState() => _State();
}

class _State extends State<FoodListGame> {
  bool _ready = true;
  int _round = 0;
  static const _rounds = 8;
  List<int> _list = [];
  List<int> _options = [];
  Set<int> _selected = {};
  bool _studying = false;
  int _score = 0;
  int _correctPicks = 0;
  int _totalListItems = 0;
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
    final count = n > 8 ? 8 : n;
    final idx = List.generate(_allFoods.length, (i) => i)..shuffle(_rand);
    _list = idx.take(count).toList();
    _totalListItems += count;
    _options = List.generate(_allFoods.length, (i) => i)..shuffle(_rand);
    _selected = {};
    setState(() => _studying = true);
    Future.delayed(Duration(milliseconds: 2500 + count * 450), () {
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
    final listSet = _list.toSet();
    final correct = _selected.intersection(listSet).length;
    final wrong = _selected.difference(listSet).length;
    _correctPicks += correct;
    _score += correct * 10 - wrong * 5;
    if (_score < 0) _score = 0;
    if (correct == listSet.length && wrong == 0) _score += 15;
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (_round >= _rounds) {
        _start.stop();
        final acc = _totalListItems == 0 ? 0.0 : _correctPicks / _totalListItems * 100;
        widget.onFinish(
          GameResult(
            score: _score,
            maxScore: _totalListItems * 10 + _rounds * 15,
            accuracy: acc,
            xp: 10 + _score ~/ 10,
            durationSec: _start.elapsed.inSeconds,
            detailAr: 'تذكرت $_correctPicks من $_totalListItems صنفاً',
          ),
        );
      } else {
        _nextRound();
      }
    });
  }

  Widget _chip(int i, {required bool selectable}) {
    final food = _allFoods[i];
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
                food.icon,
                size: 26,
                color: selected ? Colors.white : const Color(0xFF14213D),
              ),
              const SizedBox(height: 4),
              Text(
                food.label,
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
            'احفظ قائمة المأكولات، ثم اختر أصنافها من رف المتجر. 8 جولات والقائمة تطول.',
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
                Icon(Icons.shopping_basket, color: Color(0xFFF2A93B)),
                SizedBox(width: 8),
                Text('قائمة التسوق... احفظها!'),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [for (final i in _list) _chip(i, selectable: false)],
            ),
          ] else ...[
            Text('اختر أصناف القائمة (${_selected.length}/${_list.length})'),
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
