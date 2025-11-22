import 'package:equatable/equatable.dart';

class RadioEntity extends Equatable {
  final bool enabled;
  final String streamUrl;
  final bool autoplay;

  const RadioEntity({
    required this.enabled,
    required this.streamUrl,
    required this.autoplay,
  });

  @override
  List<Object> get props => [enabled, streamUrl, autoplay];
}

