import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../games/registry.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = WamdaStore.instance;
    if (store.totalPlays == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'لا توجد بيانات بعد. العب لعبة وستظهر إحصائياتك هنا.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final perCategory = <GameCategory, int>{};
    for (final h in store.history) {
      final cat = gameById(h.gameId).category;
      perCategory[cat] = (perCategory[cat] ?? 0) + 1;
    }
    final maxPlays = perCategory.values.isEmpty
        ? 1
        : perCategory.values.reduce((a, b) => a > b ? a : b);
    final bests = allGames.where((g) => store.bestScore(g.id) > 0).toList()
      ..sort((a, b) => store.bestScore(b.id).compareTo(store.bestScore(a.id)));
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'الإحصائيات',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        '${store.totalXp}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('XP'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        '${store.level}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('المستوى'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        '${store.streakDays}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('أيام متتالية'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        '${store.totalPlays}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('لعبة لُعبت'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'اللعب حسب التصنيف',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        for (final c in GameCategory.values)
          if ((perCategory[c] ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      c.labelAr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (perCategory[c] ?? 0) / maxPlays,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                      color: c.color,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${perCategory[c]}'),
                ],
              ),
            ),
        const SizedBox(height: 20),
        Text('أفضل النتائج', style: Theme.of(context).textTheme.titleLarge),
        for (final g in bests)
          ListTile(
            leading: Icon(g.icon, color: g.category.color),
            title: Text(g.titleAr),
            trailing: Text(
              '${store.bestScore(g.id)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 20),
        Text('السجل الأخير', style: Theme.of(context).textTheme.titleLarge),
        for (final h in store.history.take(15))
          ListTile(
            title: Text(gameById(h.gameId).titleAr),
            subtitle: Text(h.dateIso.substring(0, 10)),
            trailing: Text('${h.score} • ${h.accuracy.toStringAsFixed(0)}%'),
          ),
      ],
    );
  }
}
