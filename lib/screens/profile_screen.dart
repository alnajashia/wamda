import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/storage.dart';
import '../games/registry.dart';
import 'game_entry_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
  });
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final store = WamdaStore.instance;
    final favs = store.favorites.map(gameById).toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'حسابي',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المستوى ${store.level}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: store.xpInLevel / 100,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF0E7C6B),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 8),
                Text(
                  '${store.totalXp} XP • سلسلة ${store.streakDays} يوم • ${store.totalPlays} لعبة',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('المفضلة', style: Theme.of(context).textTheme.titleLarge),
        if (favs.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('لا توجد ألعاب مفضلة بعد. اضغط على القلب في المكتبة.'),
          ),
        for (final g in favs)
          Card(
            child: ListTile(
              leading: Icon(g.icon, color: g.category.color),
              title: Text(g.titleAr),
              trailing: const Icon(Icons.favorite, color: Colors.red),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameEntryScreen(def: g)),
              ).then((_) => setState(() {})),
            ),
          ),
        const SizedBox(height: 20),
        Text('الإعدادات', style: Theme.of(context).textTheme.titleLarge),
        ListTile(
          title: const Text('اللغة'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChoiceChip(
                label: const Text('العربية'),
                selected: widget.locale.languageCode == 'ar',
                onSelected: (_) => widget.onLocaleChanged(const Locale('ar')),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('English'),
                selected: widget.locale.languageCode == 'en',
                onSelected: (_) => widget.onLocaleChanged(const Locale('en')),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text('إعادة تعيين التقدم'),
          subtitle: const Text('حذف كل النقاط والسجل'),
          trailing: const Icon(Icons.delete_outline, color: Colors.red),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('إعادة تعيين التقدم؟'),
                content: const Text('سيتم حذف كل تقدمك نهائياً. هل أنت متأكد؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await WamdaStore.instance.resetAll();
                      if (ctx.mounted) Navigator.pop(ctx);
                      setState(() {});
                    },
                    child: const Text(
                      'حذف',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text('حول ومضة', style: Theme.of(context).textTheme.titleLarge),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'ومضة WAMDA — ألعاب تدريب عقلي سريعة. كل الألعاب إعادة تنفيذ مستقلة لآليات ألعاب مفتوحة المصدر وكلاسيكية، دون نسخ أي كود أو أصول أو علامات تجارية.',
          ),
        ),
        const Text(
          'مصادر الآليات:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (final g in allGames)
          ListTile(
            dense: true,
            title: Text(g.titleEn),
            subtitle: Text('${g.sourceRepo} • ${g.license}'),
          ),
      ],
    );
  }
}
