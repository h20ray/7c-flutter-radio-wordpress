import '../../../../core/network/api_client.dart';
import '../models/radio_model.dart';

abstract class RadioRemoteDataSource {
  Future<RadioModel> getRadioConfig();
}

class RadioRemoteDataSourceImpl implements RadioRemoteDataSource {
  final ApiClient apiClient;

  RadioRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RadioModel> getRadioConfig() async {
    final response = await apiClient.get('/wp-json/tujuhcahaya/v2/radio-config');
    return RadioModel.fromJson(response.data as Map<String, dynamic>);
  }
}

