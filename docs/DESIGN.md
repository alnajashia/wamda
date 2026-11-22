# WAMDA — Visual Identity & Design System

Wamda (ومضة = "flash/spark") is an original identity. It does not copy Sho3lah's logo, brand, or layout assets. Sho3lah was used only as a general reference for catalog simplicity and hierarchy, per the project brief.

## Concept
A quick flash of insight: a spark that lights a path. Friendly, intelligent, premium, lightweight.

## Logo
Circular badge: deep teal disc, amber spark/flash bolt formed by two tapered strokes, small orbit dot. Drawn in code (CustomPainter) so it stays crisp at every size; no external asset. Wordmark: «ومضة» + WAMDA in bold rounded sans.

## Palette (flat colors only — no gradients, per project rule)
- Primary teal: `#0E7C6B`
- Accent amber (the flash): `#F2A93B`
- Ink: `#14213D`
- Paper background: `#F7F8FA`
- Surface: `#FFFFFF`
- Muted text: `#5B6B82`
- Success: `#1E9E6A`, Error: `#D64545`

Category colors (flat):
- Speed `#E4572E` · Flexibility `#7C5CBF` · Memory `#0E7C6B` · Mathematics `#2563EB`
- Language `#D6336C` · Problem Solving `#B7791F` · Focus `#0891B2` · Creativity `#65A30D`

## Typography
System Arabic-capable sans (Roboto/Noto fallback chain provided by Android). Headlines bold 22-28, titles 18, body 15-16, captions 12-13. Line height 1.4 for Arabic readability. Numbers use Latin digits inside games for clarity (timers/scores), Arabic-Indic where purely textual.

## Spacing & shape
4pt scale: 4/8/12/16/24/32. Cards radius 20, buttons radius 16, chips radius 999. Card shadow: single soft shadow (blur 12, offset 0/4, 8% ink). Minimum touch target 48dp.

## Components
Game card (flat category-color header band with white icon, title AR + EN, one-line description, difficulty dots, duration, best score, favorite toggle), XP progress bar, streak chip, category tile, primary/secondary buttons, results stat tiles, bottom NavigationBar (5 tabs).

## Motion
200-300ms easeOut transitions, scale 0.97 press feedback, tile flash 250ms, result count-up. Haptics: light on tap-correct, medium on wrong/complete. No decorative animation that delays gameplay.

## RTL
Arabic is the primary locale; the whole shell mirrors in RTL. Game boards that are inherently spatial (grids, Hanoi pegs) keep their physical layout and are not mirrored, so learned positions stay stable; text and controls around them mirror normally.

## Accessibility
Contrast >= 4.5:1 for text on paper/surface, color is never the only signal (Stroop choices also carry shape/position consistency, correct/wrong also use icons + haptics), scalable text respected, pause available in every timed game.
