import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import 'game_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onGoToLibrary,
    required this.onGoToDaily,
  });
  final VoidCallback onGoToLibrary;
  final VoidCallback onGoToDaily;
  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final store = WamdaStore.instance;
    final daily = dailyGames();
    final doneToday = store.todayPlayedGameIds;
    final recentIds = <String>[];
    for (final h in store.history) {
      if (!recentIds.contains(h.gameId)) recentIds.add(h.gameId);
      if (recentIds.length >= 5) break;
    }
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'أهلاً بك في ومضة',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('ومضة WAMDA — تحديات عقلية سريعة كل يوم'),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المستوى ${store.level}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Chip(
                        avatar: const Icon(
                          Icons.local_fire_department,
                          size: 18,
                        ),
                        label: Text('سلسلة ${store.streakDays} يوم'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: store.xpInLevel / 100,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF0E7C6B),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${store.totalXp} XP إجمالاً • ${store.xpInLevel}/100 للمستوى التالي',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF0E7C6B),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التحدي اليومي',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${doneToday.intersection(daily.map((g) => g.id).toSet()).length} من 3 ألعاب مكتملة اليوم',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF2A93B),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: widget.onGoToDaily,
                    child: const Text('ابدأ التدريب اليومي'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'موصى بها لك',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: widget.onGoToLibrary,
                child: const Text('كل الألعاب'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final g in allGames.take(6))
                  SizedBox(
                    width: 160,
                    child: Card(
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameEntryScreen(def: g),
                          ),
                        ).then((_) => setState(() {})),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(g.icon, color: g.category.color, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                g.titleAr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                g.category.labelAr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('التصنيفات', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final c in GameCategory.values)
                Card(
                  child: InkWell(
                    onTap: widget.onGoToLibrary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(c.icon, color: c.color),
                        const SizedBox(height: 4),
                        Text(
                          c.labelAr,
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (recentIds.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('لعبت مؤخراً', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final id in recentIds)
              Card(
                child: ListTile(
                  leading: Icon(
                    gameById(id).icon,
                    color: gameById(id).category.color,
                  ),
                  title: Text(gameById(id).titleAr),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameEntryScreen(def: gameById(id)),
                    ),
                  ).then((_) => setState(() {})),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
