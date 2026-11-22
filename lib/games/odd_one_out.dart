import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';

class OddOneOutGame extends StatefulWidget {
  const OddOneOutGame({super.key, required this.onFinish});
  final void Function(GameResult) onFinish;
  @override
  State<OddOneOutGame> createState() => _State();
}

class _State extends State<OddOneOutGame> {
  static const _shapes = [
    Icons.circle,
    Icons.square,
    Icons.change_history,
    Icons.star,
    Icons.favorite,
    Icons.hexagon,
  ];
  static const _colors = [
    Color(0xFFE4572E),
    Color(0xFF2563EB),
    Color(0xFF0E7C6B),
    Color(0xFFF2A93B),
    Color(0xFF7C5CBF),
    Color(0xFFD6336C),
  ];
  static const _totalRounds = 12;

  bool _ready = true;
  int _round = 0;
  int _baseShape = 0;
  Color _baseColor = _colors[0];
  int _oddIndex = 0;
  int _oddShape = 0;
  Color _oddColor = _colors[1];
  double _oddTurns = 0;
  int _correct = 0;
  int _wrong = 0;
  int _score = 0;
  int _roundTime = 10;
  Timer? _timer;
  final _rand = Random();
  final _stopwatch = Stopwatch();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _gridN => _round < 4 ? 3 : (_round < 8 ? 4 : 5);

  void _newRound() {
    _timer?.cancel();
    _baseShape = _rand.nextInt(_shapes.length);
    _baseColor = _colors[_rand.nextInt(_colors.length)];
    _oddIndex = _rand.nextInt(_gridN * _gridN);
    _oddShape = _baseShape;
    _oddColor = _baseColor;
    _oddTurns = 0;
    final mode = _rand.nextInt(3);
    if (mode == 0) {
      do {
        _oddShape = _rand.nextInt(_shapes.length);
      } while (_oddShape == _baseShape);
    } else if (mode == 1) {
      do {
        _oddColor = _colors[_rand.nextInt(_colors.length)];
      } while (_oddColor == _baseColor);
    } else {
      _oddTurns = 0.125 + _rand.nextInt(3) * 0.125;
    }
    _roundTime = max(5, 10 - _round ~/ 2);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _roundTime--);
      if (_roundTime <= 0) {
        t.cancel();
        _wrong++;
        _nextRound();
      }
    });
  }

  void _nextRound() {
    _round++;
    if (_round >= _totalRounds) {
      _timer?.cancel();
      _stopwatch.stop();
      final total = _correct + _wrong;
      widget.onFinish(
        GameResult(
          score: _score,
          maxScore: 600,
          accuracy: total == 0 ? 0 : _correct / total * 100,
          xp: 10 + _score ~/ 10,
          durationSec: _stopwatch.elapsed.inSeconds,
          detailAr: 'وجدت المختلف $_correct مرة • أخطاء: $_wrong',
        ),
      );
    } else {
      setState(_newRound);
    }
  }

  void _startGame() {
    _ready = false;
    _stopwatch.start();
    _newRound();
    setState(() {});
  }

  void _tap(int i) {
    if (i == _oddIndex) {
      HapticFeedback.lightImpact();
      _correct++;
      _score += 20 + _roundTime * 2;
      _nextRound();
    } else {
      HapticFeedback.mediumImpact();
      _wrong++;
      _score = max(0, _score - 5);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return ReadyScreen(
        instructions:
            'كل الأشكال متطابقة إلا واحداً مختلفاً في الشكل أو اللون أو الاتجاه. اعثر عليه قبل انتهاء الوقت. $_totalRounds جولات.',
        onStart: _startGame,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'الجولة ${_round + 1} من $_totalRounds  •  الوقت: $_roundTime ث  •  النتيجة: $_score',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _gridN * _gridN,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridN,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (_, i) {
                final odd = i == _oddIndex;
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _tap(i),
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(odd ? _oddTurns : 0),
                        child: Icon(
                          _shapes[odd ? _oddShape : _baseShape],
                          color: odd ? _oddColor : _baseColor,
                          size: 34,
                        ),
                      ),
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
