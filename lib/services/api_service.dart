import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/transaction_report.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Accept': 'application/json'},
    ));
  }

  /// Upload file as bytes — works on mobile, desktop, and web
  Future<TransactionReport> uploadAndAnalyzeBytes(List<int> bytes, String fileName) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final response = await _dio.post(
      ApiConstants.uploadEndpoint,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode == 200) {
      return TransactionReport.fromJson(response.data);
    }
    throw Exception('Server returned ${response.statusCode}');
  }
}
