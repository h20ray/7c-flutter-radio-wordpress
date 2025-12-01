import '../../../../config/news_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class WordPressRemoteDataSource {
  Future<List<PostModel>> getPosts({
    int? categoryId,
    int page = 1,
    int perPage = 10,
    String? search,
  });

  Future<Map<int, String>> getMediaByIds(List<int> ids);

  Future<Map<int, String>> getCategoriesByIds(List<int> ids);

  Future<Map<int, String>> getUsersByIds(List<int> ids);
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
    };

    if (!NewsConfig.useMinimalNewsPayload) {
      queryParams['_embed'] = true;
    } else {
      queryParams['_fields'] =
          'id,slug,title,excerpt,content,date,link,featured_media,categories,author';
    }
    
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

  @override
  Future<Map<int, String>> getMediaByIds(List<int> ids) async {
    final uniqueIds = ids.toSet().where((id) => id > 0).toList();
    if (uniqueIds.isEmpty) {
      return {};
    }

    final response = await apiClient.get(
      '/wp-json/wp/v2/media',
      queryParameters: {
        'include': uniqueIds.join(','),
        '_fields': 'id,source_url',
        'per_page': uniqueIds.length,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;
    final result = <int, String>{};
    for (final item in data) {
      if (item is Map<String, dynamic>) {
        final id = item['id'];
        final url = item['source_url'];
        if (id is int && url is String && url.isNotEmpty) {
          result[id] = url;
        }
      }
    }
    return result;
  }

  @override
  Future<Map<int, String>> getCategoriesByIds(List<int> ids) async {
    final uniqueIds = ids.toSet().where((id) => id > 0).toList();
    if (uniqueIds.isEmpty) {
      return {};
    }

    final response = await apiClient.get(
      '/wp-json/wp/v2/categories',
      queryParameters: {
        'include': uniqueIds.join(','),
        '_fields': 'id,name',
        'per_page': uniqueIds.length,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;
    final result = <int, String>{};
    for (final item in data) {
      if (item is Map<String, dynamic>) {
        final id = item['id'];
        final name = item['name'];
        if (id is int && name is String && name.isNotEmpty) {
          result[id] = name;
        }
      }
    }
    return result;
  }

  @override
  Future<Map<int, String>> getUsersByIds(List<int> ids) async {
    final uniqueIds = ids.toSet().where((id) => id > 0).toList();
    if (uniqueIds.isEmpty) {
      return {};
    }

    final response = await apiClient.get(
      '/wp-json/wp/v2/users',
      queryParameters: {
        'include': uniqueIds.join(','),
        '_fields': 'id,name',
        'per_page': uniqueIds.length,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;
    final result = <int, String>{};
    for (final item in data) {
      if (item is Map<String, dynamic>) {
        final id = item['id'];
        final name = item['name'];
        if (id is int && name is String && name.isNotEmpty) {
          result[id] = name;
        }
      }
    }
    return result;
  }
}

