import 'dart:convert';

/// Utility class for generating deterministic cache keys
/// Replaces hashCode-based keys to avoid collisions
class CacheKeyGenerator {
  /// Generates a deterministic, URL-safe cache key from a search string
  /// Uses base64url encoding to ensure uniqueness and avoid collisions
  static String generateSearchKey(String search) {
    // Normalize the search string (trim, lowercase for consistency)
    final normalized = search.trim().toLowerCase();
    
    // Use base64url encoding (URL-safe, no padding) for deterministic keys
    // This ensures same search strings always produce same keys
    final bytes = utf8.encode(normalized);
    final base64 = base64Url.encode(bytes);
    
    // Limit key length to avoid extremely long keys
    // Base64url encoding typically produces ~33% longer strings
    // For a 100 char search, we get ~133 chars, which is acceptable
    return base64.length > 200 ? base64.substring(0, 200) : base64;
  }
  
  /// Generates a cache key for posts query
  static String generatePostsKey({
    int? categoryId,
    int page = 1,
    String? search,
  }) {
    final categoryPart = categoryId == null ? 'all' : 'cat_$categoryId';
    final searchPart = search != null && search.isNotEmpty 
        ? '_search_${generateSearchKey(search)}' 
        : '';
    final pagePart = page > 1 ? '_page_$page' : '';
    return 'posts_$categoryPart$searchPart$pagePart';
  }
  
  /// Generates a cache key for timestamp
  static String generateTimestampKey({
    int? categoryId,
    int page = 1,
    String? search,
  }) {
    final categoryPart = categoryId == null ? 'all' : 'cat_$categoryId';
    final searchPart = search != null && search.isNotEmpty 
        ? '_search_${generateSearchKey(search)}' 
        : '';
    final pagePart = page > 1 ? '_page_$page' : '';
    return 'timestamp_$categoryPart$searchPart$pagePart';
  }
}

