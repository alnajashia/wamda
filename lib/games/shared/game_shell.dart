import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models.dart';
import '../../core/storage.dart';
import '../registry.dart';

typedef GameBuilder = Widget Function(void Function(GameResult) onFinish);

class GameShell extends StatefulWidget {
  const GameShell({super.key, required this.def, required this.builder});
  final GameDef def;
  final GameBuilder builder;
  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  GameResult? _result;
  bool _recorded = false;
  bool _isBest = false;
  int _runKey = 0;

  Future<void> _onFinish(GameResult r) async {
    if (_recorded) return;
    _recorded = true;
    final best = await WamdaStore.instance.recordResult(
      widget.def.id,
      r.score,
      r.accuracy,
      r.xp,
    );
    if (!mounted) return;
    setState(() {
      _result = r;
      _isBest = best;
    });
  }

  void _restart() {
    setState(() {
      _result = null;
      _recorded = false;
      _isBest = false;
      _runKey++;
    });
  }

  void _showPause() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إيقاف مؤقت'),
        content: const Text('ماذا تريد أن تفعل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('استئناف'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _restart();
            },
            child: const Text('إعادة البدء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      final r = _result!;
      final best = WamdaStore.instance.bestScore(widget.def.id);
      final next = nextGame(widget.def.id);
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.def.titleAr),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Color(0xFFF2A93B)),
            const SizedBox(height: 12),
            Text(
              'أحسنت!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(r.detailAr, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row('النتيجة', '${r.score}'),
                    _row('الدقة', '${r.accuracy.toStringAsFixed(0)}%'),
                    _row('الوقت', '${r.durationSec} ث'),
                    _row('أفضل نتيجة', '$best${_isBest ? ' (جديد!)' : ''}'),
                    _row('نقاط الخبرة', '+${r.xp} XP'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _restart,
              child: const Text('العب مرة أخرى'),
            ),
            const SizedBox(height: 10),
            if (next != null)
              OutlinedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        GameShell(def: next, builder: gameBuilders[next.id]!),
                  ),
                ),
                child: Text('التحدي التالي: ${next.titleAr}'),
              ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('عودة إلى المكتبة'),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.def.titleAr),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.pause), onPressed: _showPause),
        ],
      ),
      body: KeyedSubtree(
        key: ValueKey(_runKey),
        child: widget.builder(_onFinish),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({
    super.key,
    required this.instructions,
    required this.onStart,
    this.extra,
  });
  final String instructions;
  final VoidCallback onStart;
  final Widget? extra;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flash_on, size: 56, color: Color(0xFF0E7C6B)),
            const SizedBox(height: 16),
            Text(
              instructions,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (extra != null) ...[const SizedBox(height: 16), extra!],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onStart();
              },
              child: const Text('ابدأ'),
            ),
          ],
        ),
      ),
    );
  }
}
