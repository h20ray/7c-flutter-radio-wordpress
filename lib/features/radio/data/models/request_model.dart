import '../../domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    required super.songTitle,
    required super.artist,
    super.requesterName,
    super.message,
  });

  factory RequestModel.fromEntity(RequestEntity entity) {
    return RequestModel(
      songTitle: entity.songTitle,
      artist: entity.artist,
      requesterName: entity.requesterName,
      message: entity.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'songTitle': songTitle,
      'artist': artist,
      if (requesterName != null && requesterName!.isNotEmpty)
        'requesterName': requesterName,
      if (message != null && message!.isNotEmpty) 'message': message,
    };
  }
}

