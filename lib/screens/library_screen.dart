import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import 'game_entry_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _State();
}

class _State extends State<LibraryScreen> {
  String _query = '';
  GameCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final filtered = allGames.where((g) {
      if (_filter != null && g.category != _filter) return false;
      if (_query.isNotEmpty &&
          !g.titleAr.contains(_query) &&
          !g.titleEn.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'مكتبة الألعاب',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            hintText: 'ابحث عن لعبة...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('الكل'),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              for (final c in GameCategory.values)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(c.labelAr),
                    selected: _filter == c,
                    onSelected: (_) => setState(() => _filter = c),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'لا توجد ألعاب في هذا التصنيف بعد — قادمة في الدفعة التالية',
              textAlign: TextAlign.center,
            ),
          ),
        for (final g in filtered)
          Card(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameEntryScreen(def: g)),
              ).then((_) => setState(() {})),
              child: Row(
                children: [
                  Container(
                    width: 84,
                    height: 96,
                    decoration: BoxDecoration(
                      color: g.category.color,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Icon(g.icon, size: 36, color: Colors.white),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.titleAr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${g.titleEn} • ${g.category.labelAr}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(g.descAr, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              for (var i = 0; i < 3; i++)
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: i < g.difficulty
                                      ? g.category.color
                                      : Colors.grey.shade300,
                                ),
                              const SizedBox(width: 8),
                              Text(
                                '${g.minutes} دقائق',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (WamdaStore.instance.bestScore(g.id) > 0) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'الأفضل: ${WamdaStore.instance.bestScore(g.id)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      WamdaStore.instance.isFavorite(g.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await WamdaStore.instance.toggleFavorite(g.id);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
