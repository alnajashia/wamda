import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import 'game_entry_screen.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});
  @override
  State<DailyScreen> createState() => _State();
}

class _State extends State<DailyScreen> {
  @override
  Widget build(BuildContext context) {
    final daily = dailyGames();
    final done = WamdaStore.instance.todayPlayedGameIds;
    final next = daily.where((g) => !done.contains(g.id)).toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'التدريب اليومي',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${daily.where((g) => done.contains(g.id)).length} من 3 مكتملة اليوم',
        ),
        const SizedBox(height: 16),
        for (final g in daily)
          Card(
            child: ListTile(
              leading: Icon(
                done.contains(g.id) ? Icons.check_circle : g.icon,
                color: done.contains(g.id) ? Colors.green : g.category.color,
                size: 32,
              ),
              title: Text(g.titleAr),
              subtitle: Text(done.contains(g.id) ? 'مكتملة اليوم' : g.descAr),
              trailing: done.contains(g.id)
                  ? null
                  : const Icon(Icons.play_arrow),
              onTap: done.contains(g.id)
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GameEntryScreen(def: g),
                      ),
                    ).then((_) => setState(() {})),
            ),
          ),
        const SizedBox(height: 16),
        if (next.isNotEmpty)
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameEntryScreen(def: next.first),
              ),
            ).then((_) => setState(() {})),
            child: Text('ابدأ التالية: ${next.first.titleAr}'),
          ),
        if (next.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'رائع! أكملت تدريب اليوم كاملاً.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
