# WAMDA | ومضة

A polished, offline-first brain-training app for Android, built with Flutter. Arabic-first with full RTL support, English also supported. No account, no ads, no tracking — all progress stays on the device.

ومضة — تطبيق تدريب ذهني أنيق يعمل دون اتصال، بالعربية أولاً مع دعم كامل للاتجاه من اليمين لليسار. بدون حسابات وبدون إعلانات؛ كل تقدمك محفوظ على جهازك.

## Features

- 14 fully playable mini-games across Memory, Focus, Speed, Mathematics, and Problem Solving (Phase 1), each with its own board, scoring, difficulty progression, pause/restart, results, and personal bests
- Daily training: 3 games seeded by date
- Gamification from real gameplay only: XP, levels, day streak, favorites, play history, per-category statistics
- Game library with search and category filters
- Original Wamda visual identity (flat colors, no gradients)

## Games (Phase 1)

Memory Matrix · Sequence Memory · Digit Span · Memory Match · N-Back · Stroop Match · Flanker Task · Schulte Table · Speed Tap · Reaction Grid · Quick Equations · Math Sprint · Tower of Hanoi · Lights Out

More games are planned in batches — see `docs/ROADMAP.md`.

## Sources & licenses

Wamda's games are independent Dart reimplementations of classic cognitive-training paradigms and of mechanics documented in these open-source projects (full traceability in `docs/GAME_SOURCE_MAPPING.md`):

- [NeuralPulse](https://github.com/sleuthy-sloth/NeuralPulse) — MIT
- [Braincup](https://github.com/SimonSchubert/Braincup) — Apache-2.0
- [Brain Development Games](https://github.com/sojinantony01/brain-development-games) — MIT
- [NIMIQ Arcade](https://github.com/NIMIQ-MINIAPPS/NIMIQ-ARCADE) — MIT (brain-training mechanics only; no Web3 features)
- [PRISMIND / brain-games-logic](https://github.com/ALENZACODES/brain-games-logic) — no license file; mechanics reimplemented independently, no code or assets copied
- [FreeFocusGames](https://github.com/loethen/freefocusgames) — AGPL-3.0; no code copied, only classic public paradigms (Stroop, Schulte, N-Back, digit span) implemented from scratch

No code, content, names, or assets from any proprietary app are used.

## Build

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release --split-per-abi
```

APKs are generated in `build/app/outputs/flutter-apk/` (armeabi-v7a, arm64-v8a, x86_64).

## Architecture

```
lib/
  app/theme.dart        Design tokens (flat colors, Material 3)
  core/                 Models + SharedPreferences storage (XP, streak, bests, history)
  games/                One module per game + registry + shared game shell
  screens/              Home, library, game entry, daily, statistics, profile
docs/
  GAME_SOURCE_MAPPING.md  Per-game source/license traceability
  DESIGN.md               Visual identity
  ROADMAP.md              Batched implementation plan
```

Package: `com.alnajashia.wamda`
