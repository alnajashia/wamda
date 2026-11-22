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
};
