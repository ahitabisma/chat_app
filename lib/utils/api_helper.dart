import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class ApiHelper {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _getFormattedBaseUrl(),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static String _getFormattedBaseUrl() {
    String url = dotenv.env['API_URL'] ?? '';

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    return url;
  }
}
