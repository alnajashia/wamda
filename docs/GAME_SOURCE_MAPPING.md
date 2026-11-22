# WAMDA — Game Source Mapping

Generated 2026-11-22 from direct inspection of the six source repositories (README + source tree + license files). Status meanings: **Faithfully ported** = original code reused under its license; **Faithfully reimplemented** = original Dart code reproducing the observable rules/scoring/timing; **Partially replicated** = core loop present, some modes missing; **Original additional game** = not from any repo; **Not implemented** = catalogued only.

## License findings (verified 2026-11-22)

| Repository | URL | License | Reuse rule for Wamda |
|---|---|---|---|
| NeuralPulse | https://github.com/sleuthy-sloth/NeuralPulse | MIT | Code may be reused with attribution; Wamda reimplements in Dart and attributes. |
| PRISMIND (brain-games-logic) | https://github.com/ALENZACODES/brain-games-logic | **No LICENSE file found** (default copyright) | No code/assets copied. Only observable mechanics may be independently reimplemented. |
| Braincup | https://github.com/SimonSchubert/Braincup | Apache-2.0 | Reuse allowed with attribution + license notice; Wamda reimplements in Dart and attributes. |
| Brain Development Games | https://github.com/sojinantony01/brain-development-games (note: user-supplied `sojinantony/...` URL returns 404; actual account is `sojinantony01`) | MIT (per README) | Reuse allowed with attribution; Wamda reimplements in Dart and attributes. |
| NIMIQ Arcade | https://github.com/NIMIQ-MINIAPPS/NIMIQ-ARCADE | MIT | Code reuse allowed with attribution; Wamda excludes all Web3/NIM economy, multiplayer rooms and tournaments (out of scope for an offline brain trainer). |
| FreeFocusGames | https://github.com/loethen/freefocusgames | AGPL-3.0 | Copyleft: no code copied into Wamda. Only classic public-domain paradigms (Stroop 1935, Schulte, N-Back, digit span) are independently implemented. |

No Sho3lah (Elektron Labs) code, content, names, or assets are used anywhere in Wamda.

## NeuralPulse — 13 games (MIT)

| Game | Original Repository | Original File | License | Status |
|---|---|---|---|---|
| Quick Equations (Numeracy) — True/false rapid verification of equations under time pressure | NeuralPulse | `src/app/games/quick-equations/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `quick_equations`) |
| Math Sprint (Numeracy) — Arithmetic against the clock, 3 difficulty levels (math-quiz) | NeuralPulse | `src/app/games/math-quiz/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `math_sprint`) |
| Memory Match (Memory) — Flip cards, find matching pairs | NeuralPulse | `src/app/games/memory-match/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `memory_match`) |
| Memory Matrix (Memory) — Memorize highlighted tiles, reproduce on expanding grid; 5 rounds; show 1500+200*tile ms; points 10+tiles*5 | NeuralPulse | `src/app/games/memory-matrix/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `memory_matrix`) |
| Sequence Memory (Memory) — Simon-style: watch tiles light in sequence, tap back in order | NeuralPulse | `src/app/games/sequence-memory/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `sequence_memory`) |
| Stroop Match (Focus) — Tap ink color not word; 15 rounds; ink/word mode switches every 5 rounds; points 10+speed bonus+level | NeuralPulse | `src/app/games/stroop-match/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `stroop_match`) |
| Speed Tap (Reflexes) — React when signal changes; response time measured | NeuralPulse | `src/app/games/speed-tap/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `speed_tap`) |
| Word Twist (Vocabulary) — Unscramble letters to form words (word-scramble) | NeuralPulse | `src/app/games/word-scramble/page.tsx` | MIT | Not implemented — queued for later batch |
| Star Battle (Logic) — One star per row/column/region, no touching | NeuralPulse | `src/app/games/star-battle/page.tsx` | MIT | Not implemented — queued for later batch |
| Digit Span (Memory) — Recall digit sequences, harder each round | NeuralPulse | `src/app/games/digit-span/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `digit_span`) |
| Flanker Task (Focus) — Center arrow direction, ignore flankers | NeuralPulse | `src/app/games/flanker-task/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `flanker_task`) |
| Reaction Grid (Reflexes) — Tap targets appearing on a grid as fast as possible | NeuralPulse | `src/app/games/reaction-grid/page.tsx` | MIT | Faithfully reimplemented (Phase 1: `reaction_grid`) |
| Pattern Matrix (Logic) — Missing piece in 3x3 Raven-style matrix | NeuralPulse | `src/app/games/pattern-matrix/page.tsx` | MIT | Not implemented — queued for later batch |

## Braincup — 48 activities: 41 scored + 7 extras (Apache-2.0)

| Game | Original Repository | Original File | License | Status |
|---|---|---|---|---|
| Mental Calculation (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Chain Calculation (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Sherlock Calculation (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Fraction Calculation (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Value Comparison (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Bubble Sum (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Quick Sum (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Missing Operators (Math) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Anomaly Puzzle (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Rule Shift (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Mental Rotations (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Path Finder (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Colored Shapes (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Mini Sudoku (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Mini Chess (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Solo Chess (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Mini Checkers (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Lights Out (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Faithfully reimplemented (Phase 1: `lights_out`) |
| Sliding Puzzle (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Shikaku (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Nurikabe (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Cat Queens (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Knot (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Tower of Hanoi (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Faithfully reimplemented (Phase 1: `tower_of_hanoi`) |
| Wordle (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Prism Clear (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Bulls & Cows (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Pattern Sequence (Logic) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Visual Memory (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Ghost Grid (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Orbit Tracker (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Digit Memory (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Spot the New (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| N-Back (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Faithfully reimplemented (Phase 1: `n_back`, single visual stream; Dual variant not yet) |
| Simon Says (Memory) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Color Confusion (Perception) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Mental Flex (Perception) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Flash Crowd (Perception) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Schulte Table (Perception) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Faithfully reimplemented (Phase 1: `schulte_table`) |
| Flags (Perception) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Trio (Perception) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| IQ Test (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Matchstick Riddles (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Peg Solitaire (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Sudoku (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Chess (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Reversi (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |
| Checkers (Extra) | Braincup | `composeApp/` (Kotlin Multiplatform game modules; per-game file to be pinned at port time) | Apache-2.0 | Not implemented — queued for later batch |

## Brain Development Games — 21 games x 10 levels (MIT, sojinantony01)

| Game | Original Repository | Original File | License | Status |
|---|---|---|---|---|
| Water Jugs (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Tower of Hanoi (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Faithfully reimplemented (Phase 1: `tower_of_hanoi`) |
| Pathway Maze (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Trail Making (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Logic Puzzles (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Number Sequence (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Ball Sort Puzzle (Logic) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| N-Back (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Faithfully reimplemented (Phase 1: `n_back`, single visual stream; Dual variant not yet) |
| Stroop Test (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Pattern Matrix (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Schulte Table (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Faithfully reimplemented (Phase 1: `schulte_table`) |
| Simon Says (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Card Matching (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Working Memory Grid (Memory) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Mental Rotation (Flexibility) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Quick Math (Flexibility) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Word Scramble (Flexibility) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Reaction Time (Flexibility) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Visual Search (Flexibility) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Anagram Solver (Flexibility) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |
| Dual Task Challenge (Advanced) | Brain Development Games | React/TS game components (per-game file to be pinned at port time) | MIT | Not implemented — queued for later batch |

## NIMIQ Arcade — 35 games (MIT); brain-training subset in scope

| Game | Original Repository | Original File | License | Status |
|---|---|---|---|---|
| Memory Matrix (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Faithfully reimplemented (Phase 1: `memory_matrix`, via NeuralPulse spec) |
| Lowdown (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Dual N-Back (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Color Stroop (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Faithfully reimplemented (Phase 1: `stroop_match`, via NeuralPulse spec) |
| Number Flow (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Pattern Sync (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Focus Grid (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Speed Sort (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Word Fresh (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Low Pop (Brain Training) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Memory Rush (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Perilous Path (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Mini Sudoku (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Merge Hex (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Color Path (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Shift Blocks (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Hex Flow (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Light Bounce (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Sum Path (Puzzle) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — queued for later batch |
| Nimtris (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Hex Fall (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Snake Path (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Galaxy Defender (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Space Raid (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Breakwall (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Pac Maze (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Asteroid Field (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Frog Cross (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Pong Duel (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Hex Runner (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Quick Tap (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Gravity Switch (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Neon Blade (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Dodge Storm (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |
| Tower Stack (Arcade/Action) | NIMIQ Arcade | `src/games/<game-id>/` | MIT | Not implemented — out of scope for brain-training batches (arcade/action, not cognitive training) |

## FreeFocusGames — classic paradigms (AGPL-3.0; mechanics only, no code)

| Game | Original Repository | Original File | License | Status |
|---|---|---|---|---|
| Dual N-Back | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Partially replicated (Phase 1: `n_back` single visual stream; dual audio+visual not yet) |
| Schulte Table | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Faithfully reimplemented (Phase 1: `schulte_table`) |
| Rotating Schulte Table | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Not implemented — queued for later batch |
| Stroop Effect Test | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Faithfully reimplemented (Phase 1: `stroop_match`) |
| Reaction Time Test | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Faithfully reimplemented (Phase 1: `speed_tap`) |
| Digit Span Test | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Faithfully reimplemented (Phase 1: `digit_span`) |
| Sequence Memory Test | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Faithfully reimplemented (Phase 1: `sequence_memory`) |
| Pomodoro Timer (tool, not a game) | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Not implemented — queued for later batch |
| 10-Second Challenge | FreeFocusGames | Next.js app routes (not copied) | AGPL-3.0 | Not implemented — queued for later batch |

## PRISMIND (brain-games-logic) — catalogue of 200 concepts; this repo implements concepts 101-200 (100 games)

Concepts 1-100 belong to the companion app `brain-games-memory` (not in this repo) and are listed for completeness. No LICENSE file exists in this repo, so Wamda copies no code or assets from it; any future PRISMIND game will be an independent reimplementation of its described mechanics.

| # | Game | Category | Original Repository | Original File | License | Status |
|---|---|---|---|---|---|---|
| 1 | Parcel Sequence | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 2 | Reverse Radio | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 3 | Window Watch | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 4 | Café Orders | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 5 | Last Three | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 6 | Colour Ledger | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 7 | Running Balance | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 8 | Shape–Sound Pairs | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 9 | Pocket Inventory | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 10 | Number–Letter Mixer | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 11 | Moving Shelves | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 12 | Echo Grid | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 13 | Two-Back Orchard | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 14 | Message Relay | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 15 | Pattern Extension | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 16 | Seat Planner | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 17 | Memory Arithmetic | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 18 | Interrupted Sequence | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 19 | Direction Stack | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 20 | Feature Binding | Working memory and short-term recall | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 21 | Name Garden | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 22 | Object–Place Museum | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 23 | Story Anchors | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 24 | Vocabulary Voyage | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 25 | Symbol Dictionary | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 26 | Landmark Return | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 27 | Pair Builder | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 28 | Recipe Recall | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 29 | Yesterday’s Board | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 30 | Fact Ladder | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 31 | Sound Signature | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 32 | Face–Detail Match | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 33 | Category Hooks | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 34 | Forgotten Item Rescue | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 35 | Timeline Traveller | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 36 | Rule Recall | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 37 | Password Palace | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 38 | Detail Detective | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 39 | Learn–Teach Cards | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 40 | Memory Confidence | Long-term learning and retrieval | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 41 | Target Harbour | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 42 | Central Arrow | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 43 | Quiet Signal | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 44 | Changing Shopfront | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 45 | Multiple-Object Tracker | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 46 | Pattern Search | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 47 | Sound Sentinel | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 48 | Dual Watch | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 49 | Relevant Detail | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 50 | Odd Rhythm | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 51 | Peripheral Locator | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 52 | Proofreader’s Desk | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 53 | Feature Intersection | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 54 | Signal Queue | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 55 | Search Without Repeating | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 56 | Conversation Filter | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 57 | Target Count | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 58 | Alert or Routine | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 59 | Moving Reading Window | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 60 | Focus Recovery | Attention and distraction control | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 61 | Go–Hold Garden | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 62 | Stop the Delivery | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 63 | Ink Interpreter | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 64 | Rule Switch Station | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 65 | Opposite Compass | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 66 | Day–Night Signals | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 67 | Category Flip | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 68 | Traffic Exception | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 69 | Reverse Sort | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 70 | Keep or Discard | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 71 | Mirror Controls | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 72 | Question Switch | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 73 | Forbidden Number | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 74 | Change the Sorting Law | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 75 | Relevant Dimension | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 76 | Pause Before Choice | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 77 | Exception Collector | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 78 | Mixed-Operation Relay | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 79 | Strategy Reset | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 80 | Undo the Habit | Inhibition and cognitive flexibility | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 81 | Symbol Twins | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 82 | Code Key | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 83 | Bigger Value | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 84 | Rapid Category | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 85 | Matching Stream | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 86 | Letter Locator | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 87 | Quantity Glance | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 88 | Same Meaning | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 89 | Pattern Passport | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 90 | Route Flash | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 91 | Word–Picture Match | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 92 | Missing Piece Sprint | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 93 | Order Check | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 94 | One Different | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 95 | Rapid Equation Check | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 96 | Sound Pair Check | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 97 | Orientation Check | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 98 | Fraction Flash | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 99 | Duplicate Detector | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 100 | Accuracy Pacekeeper | Processing speed and rapid comparison | PRISMIND | `companion repo brain-games-memory (not inspected)` | None found | Not implemented — queued for later batch |
| 101 | Rule Detective | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 102 | Mini Logic Houses | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 103 | Circuit Path | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 104 | Balance Mystery | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 105 | Sequence Laboratory | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 106 | Truthful Robots | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 107 | Constraint Garden | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 108 | Cause-and-Effect Machine | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 109 | Minimal Clue | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 110 | Counterexample Hunt | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 111 | Number Lock | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 112 | Bridge Limits | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 113 | Tile Equation | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 114 | Hidden Transformation | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 115 | Necessary or Sufficient | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 116 | Puzzle Repair | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 117 | Set Builder | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 118 | Invariant Hunt | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 119 | Analogy Workshop | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 120 | Proof Path | Logic and problem-solving | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 121 | Delivery Planner | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 122 | Calendar Tetris | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 123 | Kitchen Conductor | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 124 | Limited Moves | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 125 | Priority Desk | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 126 | Warehouse Stack | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 127 | Battery Expedition | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 128 | Dependency Builder | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 129 | Travel Buffer | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 130 | Packing Constraints | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 131 | Rescue Sequence | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 132 | Maintenance Window | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 133 | Goal Decomposer | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 134 | Replanning Storm | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 135 | Budget Builder | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 136 | Queue Manager | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 137 | Checkpoint Planner | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 138 | Tool Before Task | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 139 | Time Estimate Lab | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 140 | Plan–Do–Review | Planning and executive organisation | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 141 | Rotation Match | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 142 | Folded Paper | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 143 | Cube Net | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 144 | Perspective Finder | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 145 | Mirror Maze | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 146 | Shape Assembly | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 147 | Hidden Blocks | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 148 | Map Rotation | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 149 | Path Integration | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 150 | Cross-Section Studio | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 151 | Relative Position | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 152 | Shadow Match | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 153 | Route Reconstruction | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 154 | Symmetry Workshop | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 155 | Packing Rotation | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 156 | Scale Mapper | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 157 | Landmark Ordering | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 158 | Tile Navigation | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 159 | Occlusion Detective | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 160 | Construction Blueprint | Spatial reasoning and mental imagery | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 161 | Word Ladder | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 162 | Category Sprint | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 163 | Meaning in Context | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 164 | Sentence Repair | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 165 | Concise Messenger | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 166 | Ambiguity Detective | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 167 | Analogy Bridge | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 168 | Instruction Builder | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 169 | Main-Idea Finder | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 170 | Evidence Match | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 171 | Number Line Navigator | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 172 | Estimate First | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 173 | Fraction Duel | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 174 | Percentage Transformer | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 175 | Mental Checkout | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 176 | Ratio Kitchen | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 177 | Data Detective | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 178 | Probability Marbles | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 179 | Unit Switch | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 180 | Patterned Arithmetic | Language and numerical reasoning | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 181 | Confidence Compass | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 182 | Evidence Updater | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 183 | Base-Rate Detective | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 184 | Sample-Size Studio | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 185 | Confirmation Trap | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 186 | Sunk-Cost Expedition | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 187 | Framing Mirror | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 188 | Forecast Tournament | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 189 | Information Value | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 190 | Stop-Searching Challenge | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 191 | If–Then Builder | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 192 | Distraction Budget | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 193 | Error Detective | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 194 | Strategy Selector | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 195 | Breakpoint Planner | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 196 | Alternative Explanation | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 197 | Perspective Switch | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 198 | Decision Journal | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 199 | Transfer Mission | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |
| 200 | Personal Experiment Lab | Decision-making, behavioural habits, and metacognition | PRISMIND | `js/games/pack-*.js + js/catalog.json` | None found | Not implemented — queued for later batch |

## Phase 1 implemented in Wamda (14 games)

| Wamda ID | Game | Category | Primary source spec | License |
|---|---|---|---|---|
| `memory_matrix` | Memory Matrix | Memory | NeuralPulse memory-matrix | MIT |
| `sequence_memory` | Sequence Memory | Memory | NeuralPulse sequence-memory | MIT |
| `digit_span` | Digit Span | Memory | NeuralPulse digit-span | MIT |
| `memory_match` | Memory Match | Memory | NeuralPulse memory-match | MIT |
| `n_back` | N-Back | Memory | Braincup N-Back / classic paradigm | Apache-2.0 / public paradigm |
| `stroop_match` | Stroop Match | Focus | NeuralPulse stroop-match | MIT |
| `flanker_task` | Flanker Task | Focus | NeuralPulse flanker-task | MIT |
| `schulte_table` | Schulte Table | Focus | Braincup Schulte Table / classic paradigm | Apache-2.0 / public paradigm |
| `speed_tap` | Speed Tap (Reaction Time) | Speed | NeuralPulse speed-tap | MIT |
| `reaction_grid` | Reaction Grid | Speed | NeuralPulse reaction-grid | MIT |
| `quick_equations` | Quick Equations | Mathematics | NeuralPulse quick-equations | MIT |
| `math_sprint` | Math Sprint | Mathematics | NeuralPulse math-quiz | MIT |
| `tower_of_hanoi` | Tower of Hanoi | Problem Solving | Braincup Tower of Hanoi / classic puzzle | Apache-2.0 / public domain puzzle |
| `lights_out` | Lights Out | Problem Solving | Braincup Lights Out / classic puzzle | Apache-2.0 |

## Counts

- Games/activities identified across the 6 repos: NeuralPulse 13 + Braincup 48 + Brain Development 21 + NIMIQ 35 + FreeFocusGames 9 listed tools/games + PRISMIND catalogue 200 concepts (100 implemented in-repo) = 326 catalogue entries (many overlap by mechanic, e.g. Stroop/Schulte/N-Back appear in 4-5 repos).
- Unique mechanics after de-duplication: roughly 180.
- Implemented in Wamda Phase 1: 14 fully playable games.
- Partially replicated: Dual N-Back (single-stream only).
- Original additional games: 0.
- Not implemented: all remaining catalogue entries, queued in batches (see docs/ROADMAP.md). NIMIQ arcade/action titles and FreeFocusGames Pomodoro tool are out of scope.
## Batch A — Original implementations of classic mechanics (2026-11-22)

The following games were written from scratch for Wamda. They implement generic, classic cognitive-training paradigms only; no code, content, names, or art were taken from any proprietary app.

| Game | File | Category | Mechanic |
|---|---|---|---|
| الخطوات السريعة (Speed Steps) | `lib/games/speed_steps.dart` | Speed | Follow an arrow sequence mentally on a 5×5 grid and tap the final cell |
| المقارنة السريعة (Quick Compare) | `lib/games/quick_compare.dart` | Speed | Pick the larger of two numbers / dot groups under time pressure |
| الأشكال المطابقة (Matching Shapes) | `lib/games/matching_shapes.dart` | Focus | Tap every cell matching a target shape+color |
| الأقراص الملونة (Colored Discs) | `lib/games/colored_discs.dart` | Speed | Tap all discs of an announced color before the round timer ends |
| ترتيب الأشكال (Shape Sort) | `lib/games/shape_sort.dart` | Speed | Sort appearing shapes into the correct bin quickly |
| الشكل المختلف (Odd One Out) | `lib/games/odd_one_out.dart` | Focus | Find the single different shape/color/rotation in a grid |
| المربعات المتطابقة (Matching Squares) | `lib/games/matching_squares.dart` | Focus | Find the only identical pair among patterned squares |
| الشكل المفقود (Missing Shape) | `lib/games/missing_shape.dart` | Focus | Complete a shape pattern (repetition, size, color, rotation) |

Source: Classic paradigm (original implementation) — License: Original.

## Batch B — Original implementations of classic mechanics (2026-11-22)

The following games were written from scratch for Wamda. They implement generic, classic cognitive-training paradigms only; no code, content, names, or art were taken from any proprietary app.

| Game | File | Category | Mechanic |
|---|---|---|---|
| تقسيم اللوحة (Board Split) | `lib/games/board_split.dart` | Problem | Paint a grid into equal-area connected color regions (BFS-verified) |
| توصيل النقاط (Connect Dots) | `lib/games/connect_dots.dart` | Problem | Flow-style: connect colored dot pairs with non-crossing paths; puzzles generated from solution paths |
| مكعبات السودوكو (Sudoku Cubes) | `lib/games/sudoku_cubes.dart` | Problem | 4×4 color Sudoku with unique-solution generation (backtracking counter) |
| تحديد المسار (Path Finder) | `lib/games/path_finder.dart` | Problem | Trace a path through a randomized-DFS maze; scored vs BFS shortest |
| اللغز السداسي (Hex Puzzle) | `lib/games/hex_puzzle.dart` | Problem | Reproduce a colored hexagon pattern by tapping to cycle colors |
| لوحة الرموز (Symbol Board) | `lib/games/symbol_board.dart` | Problem | Assign each symbol its legend color on a 3×3 board; legend reshuffles per round |
| لغز المكعبات (Cube Puzzle) | `lib/games/cube_puzzle.dart` | Problem | From a cube net, pick the color opposite a marked face |
| تدافع الكرات (Ball Rush) | `lib/games/ball_rush.dart` | Problem | Tap falling balls of the target color in 4 lanes; speed grows over 60s |
| اتجاه المكعب (Cube Direction) | `lib/games/cube_direction.dart` | Flexibility | Track a cube through a rotation sequence and predict the asked face |
| دوران الأشكال (Shape Rotation) | `lib/games/shape_rotation.dart` | Flexibility | Mental rotation: pick the identical polyomino among mirrored/other distractors |
| التبديل الذهني (Mental Switch) | `lib/games/mental_switch.dart` | Flexibility | Task-switching: judge stimuli by color/shape/number parity as the rule cue switches |

Source: Classic paradigm (original implementation) — License: Original.

## Batch C — Original implementations of classic mechanics (2026-11-22)

The following games were written from scratch for Wamda. They implement generic, classic cognitive-training paradigms only; no code, content, names, or art were taken from any proprietary app.

| Game | File | Category | Mechanic |
|---|---|---|---|
| نجوم السماء (Sky Stars) | `lib/games/sky_stars.dart` | Memory | Stars flash at random positions on a dark board; tap where each was (tolerance + precision scoring), 3→8 stars, shrinking exposure, 8 rounds |
| تشابه الأشخاص (People Similarity) | `lib/games/people_similarity.dart` | Memory | Study N drawn faces (skin/hair/glasses/smile features), judge whether a probe face was in the group; distractors differ by one feature, 10 rounds |
| طريق الخطر (Danger Path) | `lib/games/danger_path.dart` | Memory | A safe path (random walk top→bottom) shows for 3s, then step cell-by-cell to the goal; danger cells cost one of 3 lives, 6 rounds |
| المسار العكسي (Reverse Path) | `lib/games/reverse_path.dart` | Memory | Corsi-style: a token lights cells in sequence; tap them back in REVERSE order, length 4→9, 8 rounds |
| حقيبة السفر (Travel Bag) | `lib/games/travel_bag.dart` | Memory | Study packed items (icon chips), then select exactly those from the full set; 4→8 items, 8 rounds |
| قائمة المأكولات (Food List) | `lib/games/food_list.dart` | Memory | Study a shopping list of Arabic foods, then pick them from a larger shelf grid; 4→8 items, 8 rounds |
| التشابه الجزئي (Partial Similarity) | `lib/games/partial_similarity.dart` | Focus | Two colored-cell patterns: tap the single differing cell, or declare them identical; grids grow 3×3→5×5, 12 rounds |
| تقدير المجموع (Sum Estimate) | `lib/games/sum_estimate.dart` | Math | Two dot clouds shown for 1.5s; estimate which had more (subitizing/estimation); quantities grow, differences shrink, 12 rounds |
| تحدي الأرقام (Number Challenge) | `lib/games/number_challenge.dart` | Math | Find the missing term in a sequence (+n, ×n, alternating ops, squares, Fibonacci-like, growing steps); 4 options, 12 rounds |

Source: Classic paradigm (original implementation) — License: Original.

## Batch D — Language games, original Arabic content (2026-11-22)

The following games were written from scratch for Wamda. All Arabic
language content (word bank, definitions, synonym pairs, sentences) was
authored originally for this app from general knowledge; no words,
definitions, or sentences were copied from any app or book. Shared
content and generation helpers live in `lib/games/shared/arabic_words.dart`
(~390-word bank across 9 categories, 46 definition items, 48 synonym
pairs, 32 sentence-summary items, plus word-search and Boggle grid
generators).

| Game | File | Category | Mechanic |
|---|---|---|---|
| تكوين الكلمات (Word Builder) | `lib/games/word_builder.dart` | Language | Tap letter tiles from a seed word to build valid bank words; length-based scoring, duplicates rejected, 90s |
| لوحة الكلمات (Word Board) | `lib/games/word_board.dart` | Language | Boggle-style 4×4 Arabic letter grid (5 words placed along adjacent paths); tap adjacent letters incl. diagonals to form words, 90s |
| تعريف الكلمة (Word Definition) | `lib/games/word_definition.dart` | Language | Read a definition, pick the correct word from 4 options; 12 rounds, 15s each, speed bonus |
| اختصر الجملة (Sentence Summary) | `lib/games/sentence_summary.dart` | Language | Pick the option that best summarizes a sentence in fewer words (distractors change meaning or ramble); 10 rounds |
| المترادفات (Synonyms) | `lib/games/synonyms.dart` | Language | Pick the synonym of the shown word from 4 options (antonyms used as distractors); 12 rounds, 15s each, speed bonus |
| الكلمات الضائعة (Lost Words) | `lib/games/lost_words.dart` | Language | Word search: tap first and last letter of hidden words in a growing 8×8→10×10 grid; found words highlighted and crossed off, 5 rounds |

Source: Classic paradigm (original implementation) — License: Original.
