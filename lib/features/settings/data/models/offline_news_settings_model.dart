import '../../../../config/offline_news_config.dart';
import '../../domain/entities/offline_news_settings_entity.dart';

class OfflineNewsSettingsModel extends OfflineNewsSettingsEntity {
  const OfflineNewsSettingsModel({
    required super.maxPosts,
    required super.maxSizeMB,
    required super.autoSaveEnabled,
  });

  factory OfflineNewsSettingsModel.fromJson(Map<String, dynamic> json) {
    return OfflineNewsSettingsModel(
      maxPosts: json['maxPosts'] as int? ??
          OfflineNewsConfig.defaultMaxPosts,
      maxSizeMB: json['maxSizeMB'] as int? ??
          OfflineNewsConfig.defaultMaxSizeMB,
      autoSaveEnabled: json['autoSaveEnabled'] as bool? ??
          OfflineNewsConfig.defaultAutoSaveEnabled,
    );
  }

  factory OfflineNewsSettingsModel.defaults() {
    return const OfflineNewsSettingsModel(
      maxPosts: OfflineNewsConfig.defaultMaxPosts,
      maxSizeMB: OfflineNewsConfig.defaultMaxSizeMB,
      autoSaveEnabled: OfflineNewsConfig.defaultAutoSaveEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxPosts': maxPosts,
      'maxSizeMB': maxSizeMB,
      'autoSaveEnabled': autoSaveEnabled,
    };
  }

  OfflineNewsSettingsModel copyWith({
    int? maxPosts,
    int? maxSizeMB,
    bool? autoSaveEnabled,
  }) {
    return OfflineNewsSettingsModel(
      maxPosts: maxPosts ?? this.maxPosts,
      maxSizeMB: maxSizeMB ?? this.maxSizeMB,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
    );
  }
}

