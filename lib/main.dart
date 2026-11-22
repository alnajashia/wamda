import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/theme.dart';
import 'core/storage.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/daily_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';

final ValueNotifier<Locale> appLocale = ValueNotifier<Locale>(
  const Locale('ar'),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WamdaStore.instance.load();
  runApp(const WamdaApp());
}

class WamdaApp extends StatelessWidget {
  const WamdaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) => MaterialApp(
        title: 'ومضة WAMDA',
        debugShowCheckedModeBanner: false,
        theme: wamdaTheme(),
        locale: locale,
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WamdaColors.paper,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset('assets/logo.png', width: 120, height: 120),
            ),
            const SizedBox(height: 20),
            const Text(
              'ومضة',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: WamdaColors.ink,
              ),
            ),
            const Text(
              'WAMDA',
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 6,
                color: WamdaColors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onGoToLibrary: () => setState(() => _index = 1),
        onGoToDaily: () => setState(() => _index = 2),
      ),
      const LibraryScreen(),
      const DailyScreen(),
      const StatsScreen(),
      ProfileScreen(
        locale: appLocale.value,
        onLocaleChanged: (l) => appLocale.value = l,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(
            icon: Icon(Icons.sports_esports),
            label: 'الألعاب',
          ),
          NavigationDestination(
            icon: Icon(Icons.today),
            label: 'التدريب اليومي',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'الإحصائيات',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
