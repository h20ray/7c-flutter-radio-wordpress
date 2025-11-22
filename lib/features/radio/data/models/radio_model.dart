import '../../domain/entities/radio_entity.dart';

class RadioModel extends RadioEntity {
  const RadioModel({
    required super.enabled,
    required super.streamUrl,
    required super.autoplay,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      enabled: json['enabled'] ?? false,
      streamUrl: json['stream_url'] ?? '',
      autoplay: json['autoplay'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'stream_url': streamUrl,
      'autoplay': autoplay,
    };
  }
}

