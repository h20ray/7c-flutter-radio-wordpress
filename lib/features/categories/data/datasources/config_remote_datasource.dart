import '../../../../core/network/api_client.dart';

abstract class ConfigRemoteDataSource {
  Future<List<int>> getHomeTopTabCategories();
  Future<List<int>> getBlockedCategories();
}

class ConfigRemoteDataSourceImpl implements ConfigRemoteDataSource {
  final ApiClient apiClient;

  ConfigRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<int>> getHomeTopTabCategories() async {
    final response = await apiClient.get('/wp-json/tujuhcahaya/v2/config');
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    final categories = data['homeTopTabCategories'];
    if (categories is List) {
      return categories.map((e) => int.tryParse(e.toString()) ?? 0).where((e) => e > 0).toList();
    }
    return [];
  }

  @override
  Future<List<int>> getBlockedCategories() async {
    final response = await apiClient.get('/wp-json/tujuhcahaya/v2/config');
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    final categories = data['blockedCategories'];
    if (categories is List) {
      return categories.map((e) => int.tryParse(e.toString()) ?? 0).where((e) => e > 0).toList();
    }
    return [];
  }
}

