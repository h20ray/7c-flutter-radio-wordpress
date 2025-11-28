import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class WordPressRemoteDataSource {
  Future<List<PostModel>> getPosts({
    int? categoryId,
    int page = 1,
    int perPage = 10,
    String? search,
  });
}

class WordPressRemoteDataSourceImpl implements WordPressRemoteDataSource {
  final ApiClient apiClient;

  WordPressRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts({
    int? categoryId,
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'per_page': perPage,
      'page': page,
      '_embed': true,
    };
    
    if (categoryId != null) {
      queryParams['categories'] = categoryId;
    }
    
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    
    final response = await apiClient.get(
      '/wp-json/wp/v2/posts',
      queryParameters: queryParams,
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

