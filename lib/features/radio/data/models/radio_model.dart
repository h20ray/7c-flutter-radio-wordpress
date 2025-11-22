import '../../domain/entities/radio_entity.dart';

class RadioModel extends RadioEntity {
  const RadioModel({
    required super.enabled,
    required super.streamUrl,
    required super.autoplay,
    required super.showAlbumCover,
    required super.textScrolling,
    required super.metadataUrl,
    required super.logoNetworkUrl,
    required super.albumArtSource,
    required super.lastUpdated,
    super.backupStreamUrls,
    super.radioCoreV2Enabled,
    super.banners,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    final albumArtSource = json['albumArtSource'] ?? json['album_art_source'] ?? 1;
    
    // Extract streamUrl with proper handling
    final streamUrlValue = json['streamUrl'] ?? json['stream_url'];
    String streamUrl = '';
    if (streamUrlValue != null) {
      if (streamUrlValue is String) {
        streamUrl = streamUrlValue;
      } else {
        streamUrl = streamUrlValue.toString();
      }
    }

    return RadioModel(
      enabled: json['enabled'] ?? false,
      streamUrl: streamUrl,
      autoplay: json['autoplay'] ?? false,
      showAlbumCover: json['showAlbumCover'] ?? json['show_album_cover'] ?? true,
      textScrolling: json['textScrolling'] ?? json['text_scrolling'] ?? true,
      metadataUrl: json['metadataUrl'] ?? json['metadata_url'] ?? '',
      logoNetworkUrl: _extractLogoNetworkUrl(json['logoNetworkUrl'] ?? json['logo_network_url']),
      albumArtSource: albumArtSource is int ? albumArtSource : int.tryParse(albumArtSource.toString()) ?? 1,
      lastUpdated: _parseDateTime(json['lastUpdated'] ?? json['last_updated']),
      backupStreamUrls: _extractBackupStreamUrls(json['backupStreamUrls'] ?? json['backup_stream_urls']),
      radioCoreV2Enabled: json['radioCoreV2Enabled'] ?? json['radio_core_v2_enabled'] ?? false,
      banners: _extractBanners(json['banners']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'stream_url': streamUrl,
      'autoplay': autoplay,
      'showAlbumCover': showAlbumCover,
      'textScrolling': textScrolling,
      'metadataUrl': metadataUrl,
      'logoNetworkUrl': logoNetworkUrl,
      'albumArtSource': albumArtSource,
      'lastUpdated': lastUpdated.toIso8601String(),
      'backupStreamUrls': backupStreamUrls,
      'radioCoreV2Enabled': radioCoreV2Enabled,
      'banners': banners.map((banner) => {
        'imageUrl': banner.imageUrl,
        'targetUrl': banner.targetUrl,
      }).toList(),
    };
  }

  /// Extract logo network URL from various formats (string, object, etc.)
  static String _extractLogoNetworkUrl(dynamic logoData) {
    if (logoData == null) return '';

    if (logoData is String) {
      return logoData;
    }

    if (logoData is Map<String, dynamic>) {
      // Handle WordPress attachment object
      if (logoData.containsKey('guid')) {
        return logoData['guid'] ?? '';
      }
      if (logoData.containsKey('ID')) {
        // If we have an ID but no guid, we can't resolve it on the client side
        // The server should have already resolved this
        return '';
      }
    }

    return '';
  }

  /// Extract backup stream URLs from JSON
  static List<String> _extractBackupStreamUrls(dynamic backupUrlsData) {
    if (backupUrlsData == null) return [];

    if (backupUrlsData is List) {
      return backupUrlsData
          .where((url) => url is String && url.isNotEmpty)
          .cast<String>()
          .toList();
    }

    return [];
  }

  /// Extract banners from JSON
  static List<RadioBanner> _extractBanners(dynamic bannersData) {
    if (bannersData == null) return [];

    if (bannersData is List) {
      return bannersData
          .whereType<Map<String, dynamic>>()
          .map((banner) {
            final imageUrl = banner['imageUrl'] ?? banner['image_url'] ?? '';
            final targetUrl = banner['targetUrl'] ?? banner['target_url'] ?? '';
            return RadioBanner(
              imageUrl: imageUrl.toString(),
              targetUrl: targetUrl.toString(),
            );
          })
          .where((banner) => banner.imageUrl.isNotEmpty && banner.targetUrl.isNotEmpty)
          .toList();
    }

    return [];
  }

  /// Parse DateTime from various formats
  static DateTime _parseDateTime(dynamic dateData) {
    if (dateData == null) return DateTime.now();

    if (dateData is DateTime) return dateData;

    if (dateData is String) {
      try {
        return DateTime.parse(dateData);
      } catch (e) {
        return DateTime.now();
      }
    }

    return DateTime.now();
  }
}

