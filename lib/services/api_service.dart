import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  /// Mobile/desktop: upload using file path
  Future<TransactionReport> uploadAndAnalyze(String filePath, String fileName) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    return _postAndParse(formData);
  }

  /// Web: upload using raw bytes (file_picker returns bytes on web)
  Future<TransactionReport> uploadAndAnalyzeBytes(List<int> bytes, String fileName) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    return _postAndParse(formData);
  }

  Future<TransactionReport> _postAndParse(FormData formData) async {
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

  bool get isWeb => kIsWeb;
}
