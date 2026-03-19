import 'package:dio/dio.dart';
import 'package:keycloack_integrations/src/data/model/property_model.dart';

class PropertyService {
  static const String _baseUrl =
      'https://68ebcab876b3362414ceaf0b.mockapi.io/api/v1';

  final Dio _dio;

  PropertyService({Dio? dio})
    : _dio =
          dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  Future<List<PropertyModel>> getProperties({int limit = 3}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/properties',
        queryParameters: {'page': 1, 'limit': limit},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => PropertyModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al cargar propiedades: ${e.message}');
    }
  }
}
