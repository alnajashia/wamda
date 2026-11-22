import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import '../games/shared/game_shell.dart';

class GameEntryScreen extends StatelessWidget {
  const GameEntryScreen({super.key, required this.def});
  final GameDef def;

  @override
  Widget build(BuildContext context) {
    final best = WamdaStore.instance.bestScore(def.id);
    final plays = WamdaStore.instance.playCount(def.id);
    return Scaffold(
      appBar: AppBar(title: Text(def.titleAr)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: def.category.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(def.icon, size: 72, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(def.titleAr, style: Theme.of(context).textTheme.headlineMedium),
          Text(
            def.titleEn,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(def.category.labelAr)),
              Chip(label: Text('الصعوبة: ${def.difficulty}/3')),
              Chip(label: Text('حوالي ${def.minutes} دقائق')),
            ],
          ),
          const SizedBox(height: 16),
          Text(def.descAr),
          const SizedBox(height: 12),
          Text(
            def.instructionsAr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (plays > 0) Text('أفضل نتيجة: $best  •  مرات اللعب: $plays'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GameShell(def: def, builder: gameBuilders[def.id]!),
              ),
            ),
            child: const Text('ابدأ اللعب'),
          ),
          const SizedBox(height: 24),
          Text(
            'المصدر: ${def.sourceRepo} • ${def.sourceFile} • ${def.license}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const Text(
            'إعادة تنفيذ مستقلة لآلية اللعب دون نسخ كود أو أصول.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
