import 'package:equatable/equatable.dart';

class PromoEntity extends Equatable {
  final int id;
  final String title;
  final int? categoryId;
  final String? categoryName;
  final String? thumbnailUrl;
  final String? time;
  final String? distance;
  final List<String> tags;

  const PromoEntity({
    required this.id,
    required this.title,
    this.categoryId,
    this.categoryName,
    this.thumbnailUrl,
    this.time,
    this.distance,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [id, title, categoryId, categoryName, thumbnailUrl, time, distance, tags];
}

