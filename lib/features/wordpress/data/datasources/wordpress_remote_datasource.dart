import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class WordPressRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class WordPressRemoteDataSourceImpl implements WordPressRemoteDataSource {
  final ApiClient apiClient;

  WordPressRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await apiClient.get('/wp-json/wp/v2/posts?per_page=5&_embed');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

