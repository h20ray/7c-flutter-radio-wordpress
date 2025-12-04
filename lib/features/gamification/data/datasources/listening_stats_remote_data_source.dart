import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_listening_stats_model.dart';

abstract class ListeningStatsRemoteDataSource {
  Future<UserListeningStatsModel> syncStatsToServer(
    UserListeningStatsModel stats,
  );
  
  Future<UserListeningStatsModel> getStatsFromServer();
}

class ListeningStatsRemoteDataSourceImpl
    implements ListeningStatsRemoteDataSource {
  final ApiClient apiClient;

  ListeningStatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserListeningStatsModel> syncStatsToServer(
    UserListeningStatsModel stats,
  ) async {
    try {
      final response = await apiClient.post(
        '/wp-json/tujuhcahaya/v2/gamification/stats/sync',
        data: {
          'totalListeningSeconds': stats.totalListeningSeconds,
          'currentLevel': stats.currentLevel,
        },
      );

      if (response.data == null) {
        throw const ServerException('Empty response from server');
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException('Invalid response format from server');
      }

      return UserListeningStatsModel(
        userId: data['userId'] as String? ?? stats.userId,
        totalListeningSeconds: data['totalListeningSeconds'] as int? ?? 0,
        currentLevel: data['currentLevel'] as String? ?? 'level_1',
        lastUpdatedAt: data['lastUpdatedAt'] != null
            ? DateTime.tryParse(data['lastUpdatedAt'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sync stats to server: ${e.toString()}');
    }
  }

  @override
  Future<UserListeningStatsModel> getStatsFromServer() async {
    try {
      final response = await apiClient.get(
        '/wp-json/tujuhcahaya/v2/gamification/stats',
      );

      if (response.data == null) {
        throw const ServerException('Empty response from server');
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException('Invalid response format from server');
      }

      return UserListeningStatsModel(
        userId: data['userId'] as String? ?? '0',
        totalListeningSeconds: data['totalListeningSeconds'] as int? ?? 0,
        currentLevel: data['currentLevel'] as String? ?? 'level_1',
        lastUpdatedAt: data['lastUpdatedAt'] != null
            ? DateTime.tryParse(data['lastUpdatedAt'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get stats from server: ${e.toString()}');
    }
  }
}

