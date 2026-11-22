import 'package:flutter/material.dart';
import '../core/models.dart';
import 'shared/game_shell.dart';
import 'memory_matrix.dart';
import 'sequence_memory.dart';
import 'digit_span.dart';
import 'stroop_match.dart';
import 'flanker_task.dart';
import 'speed_tap.dart';
import 'reaction_grid.dart';
import 'quick_equations.dart';
import 'math_sprint.dart';
import 'memory_match.dart';
import 'schulte_table.dart';
import 'tower_of_hanoi.dart';
import 'lights_out.dart';
import 'n_back.dart';
import 'speed_steps.dart';
import 'quick_compare.dart';
import 'matching_shapes.dart';
import 'colored_discs.dart';
import 'shape_sort.dart';
import 'odd_one_out.dart';
import 'matching_squares.dart';
import 'missing_shape.dart';
import 'board_split.dart';
import 'connect_dots.dart';
import 'sudoku_cubes.dart';
import 'path_finder.dart';
import 'hex_puzzle.dart';
import 'symbol_board.dart';
import 'cube_puzzle.dart';
import 'ball_rush.dart';
import 'cube_direction.dart';
import 'shape_rotation.dart';
import 'mental_switch.dart';
import 'sky_stars.dart';
import 'people_similarity.dart';
import 'danger_path.dart';
import 'reverse_path.dart';
import 'travel_bag.dart';
import 'food_list.dart';
import 'partial_similarity.dart';
import 'sum_estimate.dart';
import 'number_challenge.dart';
import 'word_builder.dart';
import 'word_board.dart';
import 'word_definition.dart';
import 'sentence_summary.dart';
import 'synonyms.dart';
import 'lost_words.dart';

const List<GameDef> allGames = [
  GameDef(
    id: 'memory_matrix',
    titleAr: 'مصفوفة الذاكرة',
    titleEn: 'Memory Matrix',
    descAr: 'احفظ نمط الخلايا المضيئة ثم أعد إنتاجه',
    instructionsAr:
        'احفظ الخلايا المضيئة ثم اضغط عليها بعد اختفائها. 5 جولات متدرجة الصعوبة.',
    category: GameCategory.memory,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Braincup (SimonSchubert/Braincup)',
    sourceFile: 'MemoryMatrix',
    license: 'Apache-2.0',
    icon: Icons.grid_on,
  ),
  GameDef(
    id: 'sequence_memory',
    titleAr: 'ذاكرة التسلسل',
    titleEn: 'Sequence Memory',
    descAr: 'كرر التسلسل المضيء بالترتيب الصحيح',
    instructionsAr:
        'شاهد التسلسل المضيء ثم كرره بالترتيب. خطأ واحد ينهي اللعبة.',
    category: GameCategory.memory,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'NeuralPulse (sleuthy-sloth/NeuralPulse)',
    sourceFile: 'SequenceMemory',
    license: 'MIT',
    icon: Icons.linear_scale,
  ),
  GameDef(
    id: 'digit_span',
    titleAr: 'مدى الأرقام',
    titleEn: 'Digit Span',
    descAr: 'احفظ سلسلة أرقام متزايدة الطول',
    instructionsAr:
        'ستظهر الأرقام واحداً تلو الآخر. اكتبها بالترتيب. لديك 3 محاولات.',
    category: GameCategory.memory,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Braincup (SimonSchubert/Braincup)',
    sourceFile: 'DigitSpan',
    license: 'Apache-2.0',
    icon: Icons.pin,
  ),
  GameDef(
    id: 'stroop_match',
    titleAr: 'تطابق ستروب',
    titleEn: 'Stroop Match',
    descAr: 'ميّز بين لون الحبر والكلمة المكتوبة',
    instructionsAr:
        'اختر اللون المطلوب حسب التعليمات: أحياناً لون الحبر وأحياناً الكلمة المكتوبة. 15 جولة.',
    category: GameCategory.focus,
    difficulty: 3,
    minutes: 2,
    sourceRepo: 'NeuralPulse (sleuthy-sloth/NeuralPulse)',
    sourceFile: 'StroopMatch',
    license: 'MIT',
    icon: Icons.palette,
  ),
  GameDef(
    id: 'flanker_task',
    titleAr: 'مهمة الجناح',
    titleEn: 'Flanker Task',
    descAr: 'ركز على السهم الأوسط وتجاهل الجوانب',
    instructionsAr:
        'انظر إلى السهم الأوسط فقط واضغط اتجاهه. تجاهل الأسهم الجانبية. 20 محاولة.',
    category: GameCategory.focus,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'FreeFocusGames (loethen/freefocusgames)',
    sourceFile: 'FlankerTask',
    license: 'AGPL-3.0 (paradigm only)',
    icon: Icons.compare_arrows,
  ),
  GameDef(
    id: 'speed_tap',
    titleAr: 'نقر السرعة',
    titleEn: 'Speed Tap',
    descAr: 'اختبر سرعة رد فعلك عند تغير اللون',
    instructionsAr:
        'انتظر حتى يصبح اللون أخضر ثم اضغط بأسرع ما يمكن. الضغط المبكر يلغي الجولة. 5 جولات.',
    category: GameCategory.speed,
    difficulty: 1,
    minutes: 1,
    sourceRepo: 'NeuralPulse (sleuthy-sloth/NeuralPulse)',
    sourceFile: 'ReactionTime',
    license: 'MIT',
    icon: Icons.timer,
  ),
  GameDef(
    id: 'reaction_grid',
    titleAr: 'شبكة رد الفعل',
    titleEn: 'Reaction Grid',
    descAr: 'اضغط على الهدف المضيء قبل أن يختفي',
    instructionsAr: 'اضغط على الخلية المضيئة بأسرع ما يمكن. لديك 30 ثانية.',
    category: GameCategory.speed,
    difficulty: 1,
    minutes: 1,
    sourceRepo: 'Braincup (SimonSchubert/Braincup)',
    sourceFile: 'ReactionGrid',
    license: 'Apache-2.0',
    icon: Icons.touch_app,
  ),
  GameDef(
    id: 'quick_equations',
    titleAr: 'معادلات سريعة',
    titleEn: 'Quick Equations',
    descAr: 'احكم على صحة المعادلات بسرعة',
    instructionsAr: 'هل المعادلة صحيحة أم خاطئة؟ لديك 60 ثانية.',
    category: GameCategory.math,
    difficulty: 2,
    minutes: 1,
    sourceRepo: 'Braincup (SimonSchubert/Braincup)',
    sourceFile: 'QuickEquations',
    license: 'Apache-2.0',
    icon: Icons.functions,
  ),
  GameDef(
    id: 'math_sprint',
    titleAr: 'سباق الرياضيات',
    titleEn: 'Math Sprint',
    descAr: 'حل أكبر عدد من المسائل في 60 ثانية',
    instructionsAr:
        'حل المعادلة واختر الإجابة الصحيحة. لديك 60 ثانية والمستوى يرتفع كل 8 إجابات صحيحة.',
    category: GameCategory.math,
    difficulty: 2,
    minutes: 1,
    sourceRepo: 'NeuralPulse (sleuthy-sloth/NeuralPulse)',
    sourceFile: 'MathSprint',
    license: 'MIT',
    icon: Icons.calculate,
  ),
  GameDef(
    id: 'memory_match',
    titleAr: 'مطابقة الذاكرة',
    titleEn: 'Memory Match',
    descAr: 'جد كل الأزواج المتطابقة بأقل محاولات',
    instructionsAr: 'اقلب بطاقتين في كل مرة وجد الأزواج المتطابقة الستة.',
    category: GameCategory.memory,
    difficulty: 1,
    minutes: 3,
    sourceRepo:
        'Brain Development Games (sojinantony01/brain-development-games)',
    sourceFile: 'MemoryMatch',
    license: 'MIT',
    icon: Icons.style,
  ),
  GameDef(
    id: 'schulte_table',
    titleAr: 'جدول شولته',
    titleEn: 'Schulte Table',
    descAr: 'ابحث عن الأرقام من 1 إلى 25 بالترتيب',
    instructionsAr:
        'اضغط على الأرقام من 1 إلى 25 بالترتيب. كل خطأ يضيف ثانيتين.',
    category: GameCategory.focus,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'FreeFocusGames (loethen/freefocusgames)',
    sourceFile: 'SchulteTable',
    license: 'AGPL-3.0 (paradigm only)',
    icon: Icons.format_list_numbered,
  ),
  GameDef(
    id: 'tower_of_hanoi',
    titleAr: 'برج هانوي',
    titleEn: 'Tower of Hanoi',
    descAr: 'انقل البرج كاملاً بأقل حركات ممكنة',
    instructionsAr:
        'انقل كل الأقراص إلى العمود الأيمن. لا تضع قرصاً كبيراً فوق صغير.',
    category: GameCategory.problem,
    difficulty: 3,
    minutes: 5,
    sourceRepo: 'PRISMIND (ALENZACODES/brain-games-logic)',
    sourceFile: 'TowerOfHanoi',
    license: 'No license (mechanics only)',
    icon: Icons.view_column,
  ),
  GameDef(
    id: 'lights_out',
    titleAr: 'إطفاء الأضواء',
    titleEn: 'Lights Out',
    descAr: 'أطفئ كل الأضواء بالضغط الذكي',
    instructionsAr:
        'اضغط على خلية لتبديلها هي وجيرانها. الهدف إطفاء كل الأضواء.',
    category: GameCategory.problem,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'PRISMIND (ALENZACODES/brain-games-logic)',
    sourceFile: 'LightsOut',
    license: 'No license (mechanics only)',
    icon: Icons.lightbulb_outline,
  ),
  GameDef(
    id: 'n_back',
    titleAr: 'إن-باك',
    titleEn: 'N-Back',
    descAr: 'تذكر الموقع قبل N خطوات واكتشف التطابق',
    instructionsAr:
        'ستظهر خلية مضيئة كل ثانيتين. اضغط "تطابق" إذا كان موقعها يطابق الموقع قبل N خطوات.',
    category: GameCategory.memory,
    difficulty: 3,
    minutes: 2,
    sourceRepo: 'Braincup (SimonSchubert/Braincup)',
    sourceFile: 'NBack',
    license: 'Apache-2.0',
    icon: Icons.replay,
  ),
  GameDef(
    id: 'speed_steps',
    titleAr: 'الخطوات السريعة',
    titleEn: 'Speed Steps',
    descAr: 'تتبع الأسهم ذهنياً وخمّن الخلية النهائية',
    instructionsAr:
        'تتبع الأسهم ذهنياً من الخلية المميزة واضغط على الخلية النهائية. لديك 80 ثانية، والخطأ يخصم ثانيتين.',
    category: GameCategory.speed,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'SpeedSteps',
    license: 'Original',
    icon: Icons.route,
  ),
  GameDef(
    id: 'quick_compare',
    titleAr: 'المقارنة السريعة',
    titleEn: 'Quick Compare',
    descAr: 'اختر الجانب الأكبر بسرعة ودقة',
    instructionsAr:
        'اضغط على الجانب الأكبر: العدد الأكبر أو النقاط الأكثر. لديك 60 ثانية.',
    category: GameCategory.speed,
    difficulty: 1,
    minutes: 1,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'QuickCompare',
    license: 'Original',
    icon: Icons.compare,
  ),
  GameDef(
    id: 'matching_shapes',
    titleAr: 'الأشكال المطابقة',
    titleEn: 'Matching Shapes',
    descAr: 'اعثر على كل الأشكال المطابقة للهدف',
    instructionsAr:
        'اضغط على كل الأشكال المطابقة للهدف تماماً (الشكل واللون). 8 جولات متدرجة.',
    category: GameCategory.focus,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'MatchingShapes',
    license: 'Original',
    icon: Icons.category,
  ),
  GameDef(
    id: 'colored_discs',
    titleAr: 'الأقراص الملونة',
    titleEn: 'Colored Discs',
    descAr: 'التقط أقراص اللون المطلوب قبل نفاد الوقت',
    instructionsAr:
        'اضغط على كل الأقراص ذات اللون المطلوب قبل انتهاء وقت الجولة. 10 جولات.',
    category: GameCategory.speed,
    difficulty: 1,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'ColoredDiscs',
    license: 'Original',
    icon: Icons.donut_large,
  ),
  GameDef(
    id: 'shape_sort',
    titleAr: 'ترتيب الأشكال',
    titleEn: 'Shape Sort',
    descAr: 'صنّف الأشكال في صناديقها بسرعة',
    instructionsAr:
        'صنّف الشكل الظاهر بالضغط على صندوقه الصحيح بأسرع ما يمكن. لديك 60 ثانية والسرعة تزداد.',
    category: GameCategory.speed,
    difficulty: 1,
    minutes: 1,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'ShapeSort',
    license: 'Original',
    icon: Icons.sort,
  ),
  GameDef(
    id: 'odd_one_out',
    titleAr: 'الشكل المختلف',
    titleEn: 'Odd One Out',
    descAr: 'اعثر على الشكل الوحيد المختلف',
    instructionsAr:
        'كل الأشكال متطابقة إلا واحداً مختلفاً في الشكل أو اللون أو الاتجاه. اعثر عليه قبل انتهاء الوقت. 12 جولة.',
    category: GameCategory.focus,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'OddOneOut',
    license: 'Original',
    icon: Icons.search,
  ),
  GameDef(
    id: 'matching_squares',
    titleAr: 'المربعات المتطابقة',
    titleEn: 'Matching Squares',
    descAr: 'جد المربعين المتطابقين تماماً',
    instructionsAr:
        'مربعان فقط متطابقان تماماً (الشكل واللون والنقاط والاتجاه). اضغط عليهما معاً. 10 جولات.',
    category: GameCategory.focus,
    difficulty: 3,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'MatchingSquares',
    license: 'Original',
    icon: Icons.grid_view,
  ),
  GameDef(
    id: 'missing_shape',
    titleAr: 'الشكل المفقود',
    titleEn: 'Missing Shape',
    descAr: 'أكمل النمط بالشكل الصحيح',
    instructionsAr:
        'اكتشف النمط واختر الشكل الذي يكمل الفراغ (؟). الأنماط: تكرار، حجم متزايد، ألوان متتابعة، دوران. 10 جولات.',
    category: GameCategory.focus,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'MissingShape',
    license: 'Original',
    icon: Icons.help_outline,
  ),
  GameDef(
    id: 'board_split',
    titleAr: 'تقسيم اللوحة',
    titleEn: 'Board Split',
    descAr: 'قسّم اللوحة إلى مناطق متساوية ومتصلة',
    instructionsAr:
        'قسّم اللوحة إلى مناطق ملونة متساوية المساحة ومتصلة. اختر لوناً ثم اضغط الخلايا لتلوينها. 5 جولات.',
    category: GameCategory.problem,
    difficulty: 3,
    minutes: 4,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'BoardSplit',
    license: 'Original',
    icon: Icons.dashboard_customize,
  ),
  GameDef(
    id: 'connect_dots',
    titleAr: 'توصيل النقاط',
    titleEn: 'Connect Dots',
    descAr: 'وصّل النقاط الملوّنة دون تقاطع المسارات',
    instructionsAr:
        'وصّل كل زوجين من النقاط الملوّنة بسحب إصبعك عبر الخلايا دون تقاطع المسارات. اضغط نقطة بداية مسار مرسوم لمسحه. 5 جولات.',
    category: GameCategory.problem,
    difficulty: 3,
    minutes: 4,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'ConnectDots',
    license: 'Original',
    icon: Icons.hub,
  ),
  GameDef(
    id: 'sudoku_cubes',
    titleAr: 'مكعبات السودوكو',
    titleEn: 'Sudoku Cubes',
    descAr: 'سودوكو مصغّر بالألوان بدل الأرقام',
    instructionsAr:
        'سودوكو مصغّر بالألوان: كل صف وعمود ومربع 2×2 يجب أن يحتوي الألوان الأربعة. اختر لوناً ثم اضغط الخلية. 5 جولات.',
    category: GameCategory.problem,
    difficulty: 3,
    minutes: 4,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'SudokuCubes',
    license: 'Original',
    icon: Icons.view_module,
  ),
  GameDef(
    id: 'path_finder',
    titleAr: 'تحديد المسار',
    titleEn: 'Path Finder',
    descAr: 'ارسم طريقك عبر المتاهة إلى الهدف',
    instructionsAr:
        'ارسم مساراً من البداية إلى الهدف بالضغط على الخلايا المجاورة دون عبور الجدران. اضغط الخلية السابقة للتراجع. 6 جولات.',
    category: GameCategory.problem,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'PathFinder',
    license: 'Original',
    icon: Icons.alt_route,
  ),
  GameDef(
    id: 'hex_puzzle',
    titleAr: 'اللغز السداسي',
    titleEn: 'Hex Puzzle',
    descAr: 'أعد إنتاج نمط السداسيات الملوّنة',
    instructionsAr:
        'أعد إنتاج نمط السداسيات الملوّنة في الأعلى. اضغط أي سداسي لتدوير لونه حتى يطابق النمط تماماً. 6 جولات.',
    category: GameCategory.problem,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'HexPuzzle',
    license: 'Original',
    icon: Icons.hexagon,
  ),
  GameDef(
    id: 'symbol_board',
    titleAr: 'لوحة الرموز',
    titleEn: 'Symbol Board',
    descAr: 'اربط كل رمز بلونه حسب الدليل',
    instructionsAr:
        'كل رمز مرتبط بلون في الدليل. اضغط خلية ثم اختر لونها الصحيح من الأسفل. الدليل يتغير كل جولة. 6 جولات.',
    category: GameCategory.problem,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'SymbolBoard',
    license: 'Original',
    icon: Icons.interests,
  ),
  GameDef(
    id: 'cube_puzzle',
    titleAr: 'لغز المكعبات',
    titleEn: 'Cube Puzzle',
    descAr: 'خمّن لون الوجه المقابل في المكعب',
    instructionsAr:
        'انظر إلى شبكة المكعب المفرودة ثم خمّن: ما لون الوجه المقابل للوجه المحدد؟ 10 جولات.',
    category: GameCategory.problem,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'CubePuzzle',
    license: 'Original',
    icon: Icons.view_in_ar,
  ),
  GameDef(
    id: 'ball_rush',
    titleAr: 'تدافع الكرات',
    titleEn: 'Ball Rush',
    descAr: 'التقط كرات اللون المطلوب قبل وصولها',
    instructionsAr:
        'اضغط فقط على الكرات ذات اللون المطلوب قبل أن تصل إلى الأسفل. اللون المطلوب يتغير كل 15 ثانية والسرعة تزداد. لديك 60 ثانية.',
    category: GameCategory.problem,
    difficulty: 2,
    minutes: 1,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'BallRush',
    license: 'Original',
    icon: Icons.sports_baseball,
  ),
  GameDef(
    id: 'cube_direction',
    titleAr: 'اتجاه المكعب',
    titleEn: 'Cube Direction',
    descAr: 'تتبّع دوران المكعب وخمّن وجهه',
    instructionsAr:
        'شاهد المكعب وهو يدور خطوة بخطوة، ثم خمّن لون الوجه المطلوب بعد انتهاء الدوران. 10 جولات متدرجة.',
    category: GameCategory.flexibility,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'CubeDirection',
    license: 'Original',
    icon: Icons.threed_rotation,
  ),
  GameDef(
    id: 'shape_rotation',
    titleAr: 'دوران الأشكال',
    titleEn: 'Shape Rotation',
    descAr: 'دوّر الشكل ذهنياً واعثر على المطابق',
    instructionsAr:
        'اختر الشكل المطابق للهدف بعد تدويره ذهنياً. انتبه: الأشكال المعكوسة (كالمرآة) ليست مطابقة. 12 جولة.',
    category: GameCategory.flexibility,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'ShapeRotation',
    license: 'Original',
    icon: Icons.rotate_right,
  ),
  GameDef(
    id: 'mental_switch',
    titleAr: 'التبديل الذهني',
    titleEn: 'Mental Switch',
    descAr: 'بدّل بين القواعد بسرعة ودقة',
    instructionsAr:
        'القاعدة تتبدل! احكم حسب المطلوب في الأعلى: اللون أو الشكل أو الرقم (زوجي/فردي). اضغط الزر الصحيح بسرعة. لديك 60 ثانية.',
    category: GameCategory.flexibility,
    difficulty: 3,
    minutes: 1,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'MentalSwitch',
    license: 'Original',
    icon: Icons.swap_horiz,
  ),
  GameDef(
    id: 'sky_stars',
    titleAr: 'نجوم السماء',
    titleEn: 'Sky Stars',
    descAr: 'احفظ أماكن النجوم ثم اعثر عليها بعد اختفائها',
    instructionsAr:
        'احفظ أماكن النجوم في السماء، ثم اضغط عليها بعد اختفائها. 8 جولات، والنجوم تزداد والوقت يقل.',
    category: GameCategory.memory,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'SkyStars',
    license: 'Original',
    icon: Icons.star,
  ),
  GameDef(
    id: 'people_similarity',
    titleAr: 'تشابه الأشخاص',
    titleEn: 'People Similarity',
    descAr: 'احفظ وجوه المجموعة واكتشف الدخيل',
    instructionsAr:
        'احفظ وجوه المجموعة، ثم قرر: هل الشخص الظاهر كان ضمن المجموعة؟ انتبه للشعر والنظارة والابتسامة. 10 جولات.',
    category: GameCategory.memory,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'PeopleSimilarity',
    license: 'Original',
    icon: Icons.people,
  ),
  GameDef(
    id: 'danger_path',
    titleAr: 'طريق الخطر',
    titleEn: 'Danger Path',
    descAr: 'اعبر المسار الآمن الذي رأيته لثوانٍ',
    instructionsAr:
        'سيظهر المسار الآمن 3 ثوانٍ ثم يختفي. امشِ خطوة خطوة من الأعلى إلى الهدف دون الوقوع في الخطر. لديك 3 قلوب كل جولة. 6 جولات.',
    category: GameCategory.memory,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'DangerPath',
    license: 'Original',
    icon: Icons.warning_amber,
  ),
  GameDef(
    id: 'reverse_path',
    titleAr: 'المسار العكسي',
    titleEn: 'Reverse Path',
    descAr: 'كرر المسار بالترتيب العكسي تماماً',
    instructionsAr:
        'شاهد المسار وهو يتحرك خلية بعد خلية، ثم اضغط على الخلايا بالترتيب العكسي تماماً. 8 جولات والمسار يطول.',
    category: GameCategory.memory,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'ReversePath',
    license: 'Original',
    icon: Icons.replay_circle_filled,
  ),
  GameDef(
    id: 'travel_bag',
    titleAr: 'حقيبة السفر',
    titleEn: 'Travel Bag',
    descAr: 'تذكّر أغراض الحقيبة واخترها من الكل',
    instructionsAr:
        'احفظ الأغراض التي في حقيبة السفر، ثم اخترها من بين كل الأغراض. 8 جولات والأغراض تزداد.',
    category: GameCategory.memory,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'TravelBag',
    license: 'Original',
    icon: Icons.luggage,
  ),
  GameDef(
    id: 'food_list',
    titleAr: 'قائمة المأكولات',
    titleEn: 'Food List',
    descAr: 'احفظ قائمة التسوق واجمع أصنافها',
    instructionsAr:
        'احفظ قائمة المأكولات، ثم اختر أصنافها من رف المتجر. 8 جولات والقائمة تطول.',
    category: GameCategory.memory,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'FoodList',
    license: 'Original',
    icon: Icons.shopping_basket,
  ),
  GameDef(
    id: 'partial_similarity',
    titleAr: 'التشابه الجزئي',
    titleEn: 'Partial Similarity',
    descAr: 'اعثر على الفرق الوحيد بين نمطين',
    instructionsAr:
        'قارن النمطين: إن كانا متطابقين اضغط «متطابقان»، وإن اختلفا في خلية واحدة اضغط عليها في النمط الثاني. 12 جولة.',
    category: GameCategory.focus,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'PartialSimilarity',
    license: 'Original',
    icon: Icons.compare,
  ),
  GameDef(
    id: 'sum_estimate',
    titleAr: 'تقدير المجموع',
    titleEn: 'Sum Estimate',
    descAr: 'خمّن أي مجموعة نقاط أكبر دون عدّ',
    instructionsAr:
        'ستظهر مجموعتا نقاط لثانية ونصف فقط. خمّن أيهما أكثر دون عدّ! 12 جولة والفرق يصغر تدريجياً.',
    category: GameCategory.math,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'SumEstimate',
    license: 'Original',
    icon: Icons.bubble_chart,
  ),
  GameDef(
    id: 'number_challenge',
    titleAr: 'تحدي الأرقام',
    titleEn: 'Number Challenge',
    descAr: 'اكتشف نمط المتتالية وأكمل الرقم الناقص',
    instructionsAr:
        'اكتشف نمط المتتالية واختر الرقم الناقص. الأنماط: جمع، ضرب، تناوب، مربعات، فيبوناتشي. 12 جولة.',
    category: GameCategory.math,
    difficulty: 3,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'NumberChallenge',
    license: 'Original',
    icon: Icons.onetwothree,
  ),
  GameDef(
    id: 'word_builder',
    titleAr: 'تكوين الكلمات',
    titleEn: 'Word Builder',
    descAr: 'كوّن أكبر عدد من الكلمات من الحروف المعطاة',
    instructionsAr:
        'كوّن كلمات عربية صحيحة من الحروف المعطاة بالضغط عليها. كلما طالت الكلمة زادت نقاطها. اعثر على أكبر عدد ممكن خلال 90 ثانية.',
    category: GameCategory.language,
    difficulty: 2,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'WordBuilder',
    license: 'Original',
    icon: Icons.abc,
  ),
  GameDef(
    id: 'word_board',
    titleAr: 'لوحة الكلمات',
    titleEn: 'Word Board',
    descAr: 'ابحث عن الكلمات في لوحة الحروف',
    instructionsAr:
        'اضغط على الحروف المتجاورة (بما فيها القطرية) لتكوين كلمات عربية صحيحة، ثم اضغط تأكيد أو آخر حرف. لديك 90 ثانية.',
    category: GameCategory.language,
    difficulty: 3,
    minutes: 2,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'WordBoard',
    license: 'Original',
    icon: Icons.grid_4x4,
  ),
  GameDef(
    id: 'word_definition',
    titleAr: 'تعريف الكلمة',
    titleEn: 'Word Definition',
    descAr: 'خمّن الكلمة من تعريفها',
    instructionsAr:
        'اقرأ التعريف واختر الكلمة الصحيحة من الخيارات الأربعة. 12 جولة، ولديك 15 ثانية لكل جولة — كلما أسرعت زادت نقاطك.',
    category: GameCategory.language,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'WordDefinition',
    license: 'Original',
    icon: Icons.menu_book,
  ),
  GameDef(
    id: 'sentence_summary',
    titleAr: 'اختصر الجملة',
    titleEn: 'Sentence Summary',
    descAr: 'اختر أفضل اختصار للجملة',
    instructionsAr:
        'اقرأ الجملة واختر الخيار الذي يلخصها بكلمات أقل دون تغيير معناها. احذر الخيارات الطويلة أو التي تغيّر المعنى. 10 جولات.',
    category: GameCategory.language,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'SentenceSummary',
    license: 'Original',
    icon: Icons.short_text,
  ),
  GameDef(
    id: 'synonyms',
    titleAr: 'المترادفات',
    titleEn: 'Synonyms',
    descAr: 'اختر مرادف الكلمة المعروضة',
    instructionsAr:
        'اختر الكلمة المرادفة للكلمة المعروضة من الخيارات الأربعة. انتبه: بعض الخيارات أضداد! 12 جولة، ولديك 15 ثانية لكل جولة.',
    category: GameCategory.language,
    difficulty: 2,
    minutes: 3,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'Synonyms',
    license: 'Original',
    icon: Icons.spellcheck,
  ),
  GameDef(
    id: 'lost_words',
    titleAr: 'الكلمات الضائعة',
    titleEn: 'Lost Words',
    descAr: 'اعثر على الكلمات المخبأة في الشبكة',
    instructionsAr:
        'اعثر على الكلمات المخبأة في شبكة الحروف: اضغط أول حرف ثم آخر حرف من الكلمة. الكلمات أفقية أو عمودية. 5 جولات والشبكة تكبر تدريجياً.',
    category: GameCategory.language,
    difficulty: 2,
    minutes: 4,
    sourceRepo: 'Classic paradigm (original implementation)',
    sourceFile: 'LostWords',
    license: 'Original',
    icon: Icons.find_in_page,
  ),
];

GameDef gameById(String id) => allGames.firstWhere((g) => g.id == id);

GameDef? nextGame(String id) {
  final idx = allGames.indexWhere((g) => g.id == id);
  if (idx < 0 || idx + 1 >= allGames.length) return null;
  return allGames[idx + 1];
}

List<GameDef> dailyGames() {
  final now = DateTime.now();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  final copy = List<GameDef>.of(allGames);
  copy.sort((a, b) => (a.id.hashCode + seed).compareTo(b.id.hashCode + seed));
  return copy.take(3).toList();
}

final Map<String, GameBuilder> gameBuilders = {
  'memory_matrix': (onFinish) => MemoryMatrixGame(onFinish: onFinish),
  'sequence_memory': (onFinish) => SequenceMemoryGame(onFinish: onFinish),
  'digit_span': (onFinish) => DigitSpanGame(onFinish: onFinish),
  'stroop_match': (onFinish) => StroopMatchGame(onFinish: onFinish),
  'flanker_task': (onFinish) => FlankerTaskGame(onFinish: onFinish),
  'speed_tap': (onFinish) => SpeedTapGame(onFinish: onFinish),
  'reaction_grid': (onFinish) => ReactionGridGame(onFinish: onFinish),
  'quick_equations': (onFinish) => QuickEquationsGame(onFinish: onFinish),
  'math_sprint': (onFinish) => MathSprintGame(onFinish: onFinish),
  'memory_match': (onFinish) => MemoryMatchGame(onFinish: onFinish),
  'schulte_table': (onFinish) => SchulteTableGame(onFinish: onFinish),
  'tower_of_hanoi': (onFinish) => TowerOfHanoiGame(onFinish: onFinish),
  'lights_out': (onFinish) => LightsOutGame(onFinish: onFinish),
  'n_back': (onFinish) => NBackGame(onFinish: onFinish),
  'speed_steps': (onFinish) => SpeedStepsGame(onFinish: onFinish),
  'quick_compare': (onFinish) => QuickCompareGame(onFinish: onFinish),
  'matching_shapes': (onFinish) => MatchingShapesGame(onFinish: onFinish),
  'colored_discs': (onFinish) => ColoredDiscsGame(onFinish: onFinish),
  'shape_sort': (onFinish) => ShapeSortGame(onFinish: onFinish),
  'odd_one_out': (onFinish) => OddOneOutGame(onFinish: onFinish),
  'matching_squares': (onFinish) => MatchingSquaresGame(onFinish: onFinish),
  'missing_shape': (onFinish) => MissingShapeGame(onFinish: onFinish),
  'board_split': (onFinish) => BoardSplitGame(onFinish: onFinish),
  'connect_dots': (onFinish) => ConnectDotsGame(onFinish: onFinish),
  'sudoku_cubes': (onFinish) => SudokuCubesGame(onFinish: onFinish),
  'path_finder': (onFinish) => PathFinderGame(onFinish: onFinish),
  'hex_puzzle': (onFinish) => HexPuzzleGame(onFinish: onFinish),
  'symbol_board': (onFinish) => SymbolBoardGame(onFinish: onFinish),
  'cube_puzzle': (onFinish) => CubePuzzleGame(onFinish: onFinish),
  'ball_rush': (onFinish) => BallRushGame(onFinish: onFinish),
  'cube_direction': (onFinish) => CubeDirectionGame(onFinish: onFinish),
  'shape_rotation': (onFinish) => ShapeRotationGame(onFinish: onFinish),
  'mental_switch': (onFinish) => MentalSwitchGame(onFinish: onFinish),
  'sky_stars': (onFinish) => SkyStarsGame(onFinish: onFinish),
  'people_similarity': (onFinish) => PeopleSimilarityGame(onFinish: onFinish),
  'danger_path': (onFinish) => DangerPathGame(onFinish: onFinish),
  'reverse_path': (onFinish) => ReversePathGame(onFinish: onFinish),
  'travel_bag': (onFinish) => TravelBagGame(onFinish: onFinish),
  'food_list': (onFinish) => FoodListGame(onFinish: onFinish),
  'partial_similarity': (onFinish) => PartialSimilarityGame(onFinish: onFinish),
  'sum_estimate': (onFinish) => SumEstimateGame(onFinish: onFinish),
  'number_challenge': (onFinish) => NumberChallengeGame(onFinish: onFinish),
  'word_builder': (onFinish) => WordBuilderGame(onFinish: onFinish),
  'word_board': (onFinish) => WordBoardGame(onFinish: onFinish),
  'word_definition': (onFinish) => WordDefinitionGame(onFinish: onFinish),
  'sentence_summary': (onFinish) => SentenceSummaryGame(onFinish: onFinish),
  'synonyms': (onFinish) => SynonymsGame(onFinish: onFinish),
  'lost_words': (onFinish) => LostWordsGame(onFinish: onFinish),
};
