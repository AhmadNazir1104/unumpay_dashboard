class ApiConstants {
  // Change this to your machine's IP when testing on a physical device
  // e.g. 'http://192.168.1.10:8000'
  // Live backend on Vercel
  static const String baseUrl = 'https://unumpay-backend.vercel.app';

  // Uncomment below for local development:
  // static const String baseUrl = 'http://localhost:8000';
  static const String apiV1 = '$baseUrl/api/v1';

  static const String uploadEndpoint = '$apiV1/transactions/upload';
  static const String summaryEndpoint = '$apiV1/transactions/summary';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
}
