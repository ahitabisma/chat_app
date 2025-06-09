import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class ApiHelper {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
}
