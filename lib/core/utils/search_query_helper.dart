class SearchQueryHelper {
  SearchQueryHelper._();

  /// Sanitizes a search query by trimming whitespace and removing special characters
  static String sanitize(String query) {
    return query
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s-]', unicode: true), '')
        .trim();
  }
}
