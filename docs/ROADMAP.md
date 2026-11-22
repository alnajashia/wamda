# WAMDA — Implementation Roadmap

Priority order (project brief): game fidelity > UI/UX quality > playable completeness > architecture > performance > QA > GitHub > APK. Games ship in batches; the app stays working after every batch. A game is only marked implemented when it is playable end-to-end (board, states, scoring, difficulty, results, persistence, replay).

## Phase 1 — DONE in this build (14 games + full shell)
Shell: splash, home, library (search/filter/favorites), game entry, daily training (3 date-seeded games), statistics, profile/settings (AR/EN, reset, attributions), XP/levels/streak/best scores/history in local storage, RTL Arabic first.
Games: memory_matrix, sequence_memory, digit_span, memory_match, n_back, stroop_match, flanker_task, schulte_table, speed_tap, reaction_grid, quick_equations, math_sprint, tower_of_hanoi, lights_out.

## Batch 2 — NeuralPulse completion + Braincup math (next)
Word Twist (Arabic word bank needed), Star Battle, Pattern Matrix; Braincup: Mental Calculation, Chain Calculation, Value Comparison, Bubble Sum, Quick Sum, Missing Operators, Sherlock Calculation, Fraction Calculation.

## Batch 3 — Braincup logic/perception
Anomaly Puzzle, Rule Shift, Mental Rotations, Path Finder, Colored Shapes, Sliding Puzzle, Bulls & Cows, Pattern Sequence, Visual Memory, Ghost Grid, Orbit Tracker, Digit Memory, Spot the New, Simon Says (full), Mental Flex, Flash Crowd, Trio.

## Batch 4 — Brain Development Games + NIMIQ brain subset
Water Jugs, Pathway Maze, Trail Making, Number Sequence, Ball Sort, Mental Rotation, Visual Search, Dual Task; NIMIQ: Lowdown, Number Flow, Pattern Sync, Focus Grid, Speed Sort, Low Pop, Color Path, Sum Path, Light Bounce, Hex Flow, Perilous Path.

## Batch 5 — PRISMIND concepts (independent reimplementations, no code copy)
Spatial pack first (Rotation Match, Mirror Maze, Cube Net, Folded Paper...), then Language & Numbers pack, Planning pack, Logic pack, Judgment pack. Each needs its own mechanics spec extracted from `js/catalog.json` + pack files before coding.

## Batch 6 — Board/extra modes (separate effort)
Mini Sudoku/Sudoku, Wordle (Arabic variant decision needed), Mini Chess/Solo Chess/Checkers/Reversi, Shikaku, Nurikabe, Cat Queens, Knot, Matchstick Riddles, Peg Solitaire, IQ Test mode.

## Out of scope
NIMIQ arcade/action titles (Nimtris, shooters, runners...), all Web3/NIM economy, online rooms/tournaments, FreeFocusGames Pomodoro tool. Dual N-Back audio channel is a later enhancement to `n_back`.

## Creativity category
No creativity-specific games were found in the six repos. The category stays empty (honest empty state) until original Wamda creativity games are designed and clearly labelled as original additions.
