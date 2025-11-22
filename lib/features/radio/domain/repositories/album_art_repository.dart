/// Abstract repository for album art operations
abstract class AlbumArtRepository {
  /// Get album art URL for the given artist and title
  /// Returns null if no album art is found
  Future<String?> getAlbumArtUrl(String artist, String title);

  /// Get album art URL with dynamic configuration and stream URL for AzuraCast detection
  /// Returns null if no album art is found
  Future<String?> getAlbumArtUrlWithStream(
    String artist,
    String title,
    int albumArtSource,
    String streamUrl,
  );
}

