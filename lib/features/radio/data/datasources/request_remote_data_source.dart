import '../../../../config/radio_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<void> submitRequest(RequestModel request);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final ApiClient apiClient;

  RequestRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> submitRequest(RequestModel request) async {
    await apiClient.post(
      RadioConfig.requestApiEndpoint,
      data: request.toMap(),
    );
  }
}

