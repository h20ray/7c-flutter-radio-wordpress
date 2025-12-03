class SearchQueryHelper {
  SearchQueryHelper._();

  static String sanitize(String query) {
    return query
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s-]', unicode: true), '')
        .trim();
  }

  static String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]', unicode: true), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static int _calculateTitleMatchScore(String title, String query) {
    final normalizedTitle = _normalizeText(title);
    final normalizedQuery = _normalizeText(query);
    final queryWords = normalizedQuery.split(' ').where((w) => w.isNotEmpty).toList();
    
    if (queryWords.isEmpty) return 0;
    
    int score = 0;
    
    // Exact phrase match (highest priority)
    if (normalizedTitle == normalizedQuery) {
      score += 10000;
    }
    
    // Title starts with exact phrase
    if (normalizedTitle.startsWith(normalizedQuery)) {
      score += 5000;
    }
    
    // Title contains exact phrase as whole words
    final phrasePattern = RegExp(r'\b' + RegExp.escape(normalizedQuery) + r'\b');
    if (phrasePattern.hasMatch(normalizedTitle)) {
      score += 3000;
    }
    
    // Title contains exact phrase (anywhere)
    if (normalizedTitle.contains(normalizedQuery)) {
      score += 2000;
    }
    
    // All query words appear in title (in order) - consecutive
    bool allWordsConsecutive = false;
    if (queryWords.length > 1) {
      final combinedQuery = queryWords.join(' ');
      if (normalizedTitle.contains(combinedQuery)) {
        allWordsConsecutive = true;
        score += 1500;
      }
    }
    
    // All query words appear in title (in order)
    bool allWordsInOrder = true;
    int lastIndex = -1;
    for (final word in queryWords) {
      final index = normalizedTitle.indexOf(word, lastIndex + 1);
      if (index == -1) {
        allWordsInOrder = false;
        break;
      }
      lastIndex = index;
    }
    if (allWordsInOrder && !allWordsConsecutive) {
      score += 1000;
    }
    
    // Title starts with first word
    if (queryWords.isNotEmpty && normalizedTitle.startsWith(queryWords.first)) {
      score += 500;
    }
    
    // Count how many words match
    int matchingWords = 0;
    for (final word in queryWords) {
      final wordPattern = RegExp(r'\b' + RegExp.escape(word) + r'\b');
      if (wordPattern.hasMatch(normalizedTitle)) {
        matchingWords++;
        score += 100;
        
        // Bonus if word appears at start
        if (normalizedTitle.startsWith(word)) {
          score += 50;
        }
      } else if (normalizedTitle.contains(word)) {
        matchingWords++;
        score += 30;
      }
    }
    
    // Bonus if all words match
    if (matchingWords == queryWords.length) {
      score += 200;
    }
    
    return score;
  }

  static List<T> prioritizeTitleMatches<T>({
    required List<T> items,
    required String query,
    required String Function(T) getTitle,
  }) {
    if (query.trim().isEmpty) return items;
    
    final sanitizedQuery = sanitize(query);
    if (sanitizedQuery.isEmpty) return items;
    
    final itemsWithScores = items.map((item) {
      final title = getTitle(item);
      final score = _calculateTitleMatchScore(title, sanitizedQuery);
      return (item: item, score: score);
    }).toList();
    
    itemsWithScores.sort((a, b) {
      if (a.score != b.score) {
        return b.score.compareTo(a.score);
      }
      return 0;
    });
    
    return itemsWithScores.map((e) => e.item).toList();
  }
}

