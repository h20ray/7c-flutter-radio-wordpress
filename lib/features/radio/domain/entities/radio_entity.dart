import 'package:equatable/equatable.dart';

class RadioBanner extends Equatable {
  final String imageUrl;
  final String targetUrl;
  
  const RadioBanner({
    required this.imageUrl,
    required this.targetUrl,
  });
  
  @override
  List<Object> get props => [imageUrl, targetUrl];
}

class RadioEntity extends Equatable {
  final bool enabled;
  final String streamUrl;
  final bool autoplay;
  final bool showAlbumCover;
  final bool textScrolling;
  final String metadataUrl;
  final String logoNetworkUrl;
  final int albumArtSource;
  final DateTime lastUpdated;
  final List<String> backupStreamUrls;
  final bool radioCoreV2Enabled;
  final List<RadioBanner> banners;

  const RadioEntity({
    required this.enabled,
    required this.streamUrl,
    required this.autoplay,
    required this.showAlbumCover,
    required this.textScrolling,
    required this.metadataUrl,
    required this.logoNetworkUrl,
    required this.albumArtSource,
    required this.lastUpdated,
    this.backupStreamUrls = const [],
    this.radioCoreV2Enabled = false,
    this.banners = const [],
  });

  @override
  List<Object> get props => [
        enabled,
        streamUrl,
        autoplay,
        showAlbumCover,
        textScrolling,
        metadataUrl,
        logoNetworkUrl,
        albumArtSource,
        lastUpdated,
        backupStreamUrls,
        radioCoreV2Enabled,
        banners,
      ];
}

