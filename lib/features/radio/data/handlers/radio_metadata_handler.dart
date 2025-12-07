import '../../../../config/radio_config.dart';

/// Result of metadata normalization
class NormalizedMetadata {
  final String artist;
  final String title;

  const NormalizedMetadata(this.artist, this.title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormalizedMetadata &&
          runtimeType == other.runtimeType &&
          artist == other.artist &&
          title == other.title;

  @override
  int get hashCode => artist.hashCode ^ title.hashCode;

  @override
  String toString() => 'NormalizedMetadata(artist: $artist, title: $title)';
}

/// Handler for normalizing and sanitizing radio stream metadata.
///
/// This class encapsulates the metadata normalization logic that was previously
/// embedded in RadioPlayerRepositoryImpl, making it testable and reusable.
class RadioMetadataHandler {
  /// Phrases to remove from metadata (e.g., "Now Playing:", "On Air:")
  final List<String> removePhrases;

  /// Fallback artist name when metadata is empty
  final String fallbackArtist;

  /// Fallback title when metadata is empty
  final String fallbackTitle;

  /// Creates a new metadata handler with the given configuration.
  ///
  /// If no configuration is provided, uses defaults from [RadioConfig].
  RadioMetadataHandler({
    List<String>? removePhrases,
    String? fallbackArtist,
    String? fallbackTitle,
  })  : removePhrases = removePhrases ?? RadioConfig.metadataRemovePhrases,
        fallbackArtist = fallbackArtist ?? RadioConfig.fallbackArtist,
        fallbackTitle = fallbackTitle ?? RadioConfig.fallbackTitle;

  /// Normalizes and sanitizes the given metadata.
  ///
  /// This method:
  /// - Removes configured phrases (case-insensitive)
  /// - Removes newlines and tabs
  /// - Collapses multiple spaces
  /// - Trims whitespace
  /// - Falls back to configured defaults if empty
  NormalizedMetadata normalize(String? artist, String? title) {
    String? sanitizedArtist = artist;
    String? sanitizedTitle = title;

    // Remove configured phrases
    for (final phrase in removePhrases) {
      final regex = RegExp(RegExp.escape(phrase), caseSensitive: false);
      if (sanitizedArtist != null) {
        sanitizedArtist = sanitizedArtist.replaceAll(regex, '');
      }
      if (sanitizedTitle != null) {
        sanitizedTitle = sanitizedTitle.replaceAll(regex, '');
      }
    }

    // Clean up whitespace
    sanitizedArtist = _sanitizeWhitespace(sanitizedArtist);
    sanitizedTitle = _sanitizeWhitespace(sanitizedTitle);

    // Apply fallbacks if empty
    final normalizedArtist =
        (sanitizedArtist != null && sanitizedArtist.isNotEmpty)
            ? sanitizedArtist
            : fallbackArtist;
    final normalizedTitle =
        (sanitizedTitle != null && sanitizedTitle.isNotEmpty)
            ? sanitizedTitle
            : fallbackTitle;

    return NormalizedMetadata(normalizedArtist, normalizedTitle);
  }

  /// Sanitizes whitespace in a string.
  String? _sanitizeWhitespace(String? value) {
    if (value == null) return null;

    return value
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Checks if two metadata values are effectively the same after normalization.
  bool isSameMetadata(
    String? artist1,
    String? title1,
    String? artist2,
    String? title2,
  ) {
    final normalized1 = normalize(artist1, title1);
    final normalized2 = normalize(artist2, title2);
    return normalized1 == normalized2;
  }

  /// Checks if the given metadata has actual content (not just fallbacks).
  bool hasRealContent(String? artist, String? title) {
    final normalized = normalize(artist, title);
    return normalized.artist != fallbackArtist ||
        normalized.title != fallbackTitle;
  }
}
