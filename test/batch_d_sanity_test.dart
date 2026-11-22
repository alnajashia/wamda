import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:wamda/games/shared/arabic_words.dart';

void main() {
  test('content bank sizes meet minimums', () {
    expect(wordBank.length, greaterThanOrEqualTo(120));
    expect(definitions.length, greaterThanOrEqualTo(40));
    expect(synonyms.length, greaterThanOrEqualTo(40));
    expect(sentences.length, greaterThanOrEqualTo(30));
    // All bank words are 3-7 letters.
    for (final w in wordBank) {
      expect(w.runes.length, inInclusiveRange(3, 7), reason: w);
    }
    // No duplicate words.
    expect(wordBankSet.length, wordBank.length);
    // Definitions/synonyms/sentences have exactly 3 distractors.
    for (final d in definitions) {
      expect(d.distractors.length, 3, reason: d.word);
      expect(d.distractors.contains(d.word), isFalse, reason: d.word);
    }
    for (final s in synonyms) {
      expect(s.distractors.length, 3, reason: s.word);
      expect(s.distractors.contains(s.synonym), isFalse, reason: s.word);
    }
    for (final s in sentences) {
      expect(s.distractors.length, 3, reason: s.sentence);
      expect(s.distractors.contains(s.summary), isFalse, reason: s.sentence);
      // Summary must be shorter than the sentence.
      expect(s.summary.length, lessThan(s.sentence.length),
          reason: s.sentence);
    }
  });

  test('word search generation places words correctly', () {
    final rand = Random(42);
    for (var round = 0; round < 20; round++) {
      final size = 8 + (round % 3);
      final puzzle =
          generateWordSearch(size: size, wordCount: 6, rand: rand);
      expect(puzzle.words.length, 6);
      expect(puzzle.grid.length, size);
      for (final row in puzzle.grid) {
        expect(row.length, size);
        for (final cell in row) {
          expect(cell.runes.length, 1);
        }
      }
      for (final w in puzzle.words) {
        final idxs = puzzle.placements[w]!;
        final read =
            idxs.map((i) => puzzle.grid[i ~/ size][i % size]).join();
        expect(read, w);
      }
    }
  });

  test('boggle generation places findable words', () {
    final rand = Random(7);
    for (var round = 0; round < 20; round++) {
      final grid = generateBoggleGrid(rand: rand);
      expect(grid.cells.length, 16);
      expect(grid.placedWords.length, 5);
      for (final cell in grid.cells) {
        expect(cell.runes.length, 1);
      }
      // Each placed word must be traceable along adjacent cells.
      for (final w in grid.placedWords) {
        expect(_traceable(grid.cells, lettersOf(w)), isTrue, reason: w);
      }
    }
  });

  test('word builder seeds yield enough possible words', () {
    var goodSeeds = 0;
    for (final w in wordBank) {
      final l = w.runes.length;
      if (l < 5 || l > 7) continue;
      if (possibleWords(lettersOf(w)).length >= 4) goodSeeds++;
    }
    expect(goodSeeds, greaterThanOrEqualTo(5));
  });
}

bool _traceable(List<String> cells, List<String> letters) {
  const size = 4;
  bool dfs(int idx, int pos, Set<int> used) {
    if (cells[idx] != letters[pos]) return false;
    if (pos == letters.length - 1) return true;
    final r = idx ~/ size, c = idx % size;
    for (var dr = -1; dr <= 1; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = r + dr, nc = c + dc;
        if (nr < 0 || nr >= size || nc < 0 || nc >= size) continue;
        final n = nr * size + nc;
        if (used.contains(n)) continue;
        if (dfs(n, pos + 1, {...used, n})) return true;
      }
    }
    return false;
  }

  for (var i = 0; i < cells.length; i++) {
    if (dfs(i, 0, {i})) return true;
  }
  return false;
}
