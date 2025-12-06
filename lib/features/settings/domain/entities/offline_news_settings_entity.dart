import 'package:equatable/equatable.dart';

class OfflineNewsSettingsEntity extends Equatable {
  final int maxPosts;
  final int maxSizeMB;
  final bool autoSaveEnabled;

  const OfflineNewsSettingsEntity({
    required this.maxPosts,
    required this.maxSizeMB,
    required this.autoSaveEnabled,
  });

  @override
  List<Object> get props => [maxPosts, maxSizeMB, autoSaveEnabled];
}

