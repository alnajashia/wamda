import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wamda/core/storage.dart';
import 'package:wamda/games/registry.dart';
import 'package:wamda/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('registry has 14 games with unique ids', () {
    expect(allGames.length, 14);
    expect(allGames.map((g) => g.id).toSet().length, 14);
    expect(gameBuilders.length, 14);
  });

  test('storage recordResult updates best score and XP', () async {
    SharedPreferences.setMockInitialValues({});
    await WamdaStore.instance.load();
    final isBest = await WamdaStore.instance.recordResult(
      'memory_matrix',
      80,
      90,
      26,
    );
    expect(isBest, true);
    expect(WamdaStore.instance.bestScore('memory_matrix'), 80);
    expect(WamdaStore.instance.totalXp, 26);
    expect(WamdaStore.instance.playCount('memory_matrix'), 1);
    await WamdaStore.instance.recordResult('memory_matrix', 50, 70, 20);
    expect(WamdaStore.instance.bestScore('memory_matrix'), 80);
    expect(WamdaStore.instance.totalXp, 46);
  });

  testWidgets('app shows splash branding then bottom navigation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await WamdaStore.instance.load();
    await tester.pumpWidget(const WamdaApp());
    expect(find.text('ومضة'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump();
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('الألعاب'), findsOneWidget);
    expect(find.text('التدريب اليومي'), findsOneWidget);
    expect(find.text('الإحصائيات'), findsOneWidget);
    expect(find.text('حسابي'), findsOneWidget);
  });
}
