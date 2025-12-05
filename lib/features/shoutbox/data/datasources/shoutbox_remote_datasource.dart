import '../../../../core/network/api_client.dart';
import '../models/shoutbox_message_model.dart';

abstract class ShoutboxRemoteDataSource {
  Future<List<ShoutboxMessageModel>> getMessages({
    int afterId = 0,
    int limit = 50,
  });
  Future<ShoutboxMessageModel> sendMessage({
    required String username,
    required String message,
  });
  Future<void> deleteMessage(int id);
}

class ShoutboxRemoteDataSourceImpl implements ShoutboxRemoteDataSource {
  final ApiClient apiClient;

  ShoutboxRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ShoutboxMessageModel>> getMessages({
    int afterId = 0,
    int limit = 50,
  }) async {
    final response = await apiClient.get(
      '/wp-json/tujuhcahaya/shoutbox/messages',
      queryParameters: {
        'after_id': afterId,
        'limit': limit,
      },
    );
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> messages = data['data'] ?? [];
    return messages
        .map((json) => ShoutboxMessageModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ShoutboxMessageModel> sendMessage({
    required String username,
    required String message,
  }) async {
    final response = await apiClient.post(
      '/wp-json/tujuhcahaya/shoutbox/messages',
      data: {
        'username': username,
        'message': message,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return ShoutboxMessageModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMessage(int id) async {
    await apiClient.delete('/wp-json/tujuhcahaya/shoutbox/messages/$id');
  }
}

