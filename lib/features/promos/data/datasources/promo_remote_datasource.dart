import '../../../../core/network/api_client.dart';
import '../../../wordpress/data/models/post_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PostModel>> getPromosByCategory(int? categoryId);
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final ApiClient apiClient;

  PromoRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPromosByCategory(int? categoryId) async {
    String endpoint = '/wp-json/wp/v2/posts?per_page=10&_embed';
    if (categoryId != null) {
      endpoint += '&categories=$categoryId';
    }
    
    final response = await apiClient.get(endpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

