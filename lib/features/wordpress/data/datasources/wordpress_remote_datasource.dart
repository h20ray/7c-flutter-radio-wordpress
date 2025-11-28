import '../../../../config/news_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class WordPressRemoteDataSource {
  Future<List<PostModel>> getPosts({int? categoryId});
}

class WordPressRemoteDataSourceImpl implements WordPressRemoteDataSource {
  final ApiClient apiClient;

  WordPressRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts({int? categoryId}) async {
    final perPage = NewsConfig.homeNewsListLimit;
    String endpoint = '/wp-json/wp/v2/posts?per_page=$perPage&_embed';
    if (categoryId != null) {
      endpoint += '&categories=$categoryId';
    }
    final response = await apiClient.get(endpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

