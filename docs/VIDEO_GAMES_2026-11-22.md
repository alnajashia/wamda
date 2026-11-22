# Video games catalog — 2026-11-22

Source: screen-recording sent by Ahmed in the Wamda chat on 2026-11-22
09:52 UTC (`workspace/user/media_library/video/43/4366e2ececcb1db1d684eeaf74d780f4a0305ed65d3fd6f1db486a9679af85b0.mp4`,
36.3 s, 720×1600) with the request «اضف جميع الألعاب المرفقة بالفيديو»
(add all the games in the video). Frames were extracted at 1 fps
(36 frames) and read individually. The app in the video is a third-party
Arabic brain-training app (tabs: التمرين / المعدل / الألعاب / المكعبات /
حسابي); it is not Sho3lah and not one of the six open-source repos in
`GAME_SOURCE_MAPPING.md`. Per the project rules, anything built from
this catalog is an original Wamda implementation of a classic paradigm:
own code, own art (flat colors, no gradients — `DESIGN.md`), no copied
assets, text, or layouts.

## What the video actually shows

Only ONE game is played on screen: **الخطوات السريعة (Quick Steps)**.
The rest of the video scrolls a games library. 25 distinct game names
are readable; most tiles carry a lock icon (paid/locked in that app),
so their mechanics are NOT in the video — only a name and a thumbnail.
"Add all games" therefore splits into three honest groups below.

## Group A — fully specified by the video (1 game)

### الخطوات السريعة — Quick Steps (Speed / visualization)
Extracted from frames f001–f024:
- 5×5 grid; a character token starts on one cell (token art changes
  between rounds in the source app — Wamda uses its own flat token).
- A row of 5 arrow tiles is shown: straight arrows (↑ ↓ ← →) and
  turn arrows (bent arrows). Instruction: «اضغط على المربع النهائي
  بعد هذه الخطوات» — tap the final cell after applying the steps.
- Total timer 1:20, score counter (0 → 2,500 within ~16 s of play;
  per-answer increment not isolated in the frames — confirm by
  rewatching at full frame rate before locking scoring).
- 3-2-1 countdown before play; pause button; score + time pills on top.
- Source app lists benefits: Visualization + Information Processing,
  and a 400-level progression (theirs — Wamda uses its own XP/levels).

Original Wamda spec (ready to implement as `quick_steps`):
- Board 5×5 (physical layout, not mirrored in RTL per DESIGN.md).
- Generator: random start cell; 5-step path mixing straight and turn
  steps, constrained to stay in bounds; destination = end cell.
- Round: show arrows + start token; player taps one cell; correct =
  destination. Wrong tap: error feedback + haptic, round ends or
  retries per difficulty (decide at build; default: one tap per round).
- Session: 80 s timer, score per correct answer with speed bonus
  (align with existing games' scoring style), results screen via the
  shared game shell, best-score persistence, replay.
- Difficulty: steps 3→7 and grid 4×4→6×6 across levels.
- Category: Speed (`#E4572E`). Arabic title: «الخطوات السريعة» is a
  generic descriptive name; final title to confirm with Ahmed.

## Group B — name + thumbnail only, unlocked in the video (5 games)

Mechanics are not shown. Each needs either a short gameplay recording
from Ahmed or approval to design an original game from the name.
Closest existing Wamda/Roadmap paradigms are noted — they are NOT the
same games and must not be presented as copies.

| Game (AR) | Meaning | Closest Wamda / Roadmap item |
|---|---|---|
| مكعبات السودوكو | Sudoku Cubes | Mini Sudoku — Roadmap Batch 6 |
| تكوين الكلمات | Word Formation | Word Twist / Word Scramble — Batch 2 (Arabic word bank needed) |
| لوحة الكلمات | Word Board | Word Twist family — Batch 2 (Arabic word bank needed) |
| توصيل النقاط | Connect the Dots | Color Path / Flow-style — Batch 4 (NIMIQ subset) |
| تقسيم اللوحة | Board Division | No close match in mapping; mechanics unknown |

## Group C — locked in the video, name only (19 games)

No gameplay, no rules visible. Implementing these "faithfully" from a
name alone would be invention, not porting. Options: Ahmed records
each game unlocked, or approves original designs from the names
(labelled as original Wamda games), or they stay out.

- Language: اختصر الجملة (Shorten the Sentence), تعريف الكلمة (Word
  Definition), المترادفات (Synonyms)
- Problem solving: لوحة الرموز (Symbols Board), اللغز السداسي
  (Hexagon Puzzle), لغز المكعبات (Cubes Puzzle)
- (category cut off in video): قائمة المأكولات (Food List),
  التشابه الجزئي (Partial Similarity)
- Memory: لوحة الذاكرة (Memory Board — closest existing: Phase 1
  `memory_matrix`), نجوم السماء (Sky Stars), طريق الخطر (Danger
  Path), تشابه الأشخاص (People Similarity), المسار العكسي (Reverse
  Path)
- Speed: القراءة السريعة (Speed Reading), ترتيب الأشكال (Shape
  Ordering), المقارنة السريعة (Quick Comparison), الأقراص الملونة
  (Colored Discs), الأشكال المطابقة (Matching Shapes — closest
  existing: Phase 1 `memory_match`), حقيبة السفر (Travel Bag)

## Recommended order (for Ahmed's decision)

1. Build Quick Steps first — it is the only game the video specifies
   completely, and it fits Wamda's Speed category with no new assets.
2. Word games (تكوين الكلمات / لوحة الكلمات) fold into Roadmap
   Batch 2, which already waits on an Arabic word bank.
3. مكعبات السودوكو folds into Batch 6 (Mini Sudoku); توصيل النقاط
   into Batch 4 (Color Path paradigm).
4. Group C waits for gameplay recordings or an explicit
   "design originals from the names" approval.

Nothing in this catalog was implemented yet. The merged logo (options
1+2) approval comes first, per the chat sequence; no push without
Ahmed's explicit word.
