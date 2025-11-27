import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get('/wp-json/wp/v2/categories?per_page=100');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

