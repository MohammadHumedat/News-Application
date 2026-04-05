import 'package:dio/dio.dart';
import 'package:news_app/core/utils/constants/app_constants.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Authorization': 'Bearer ${AppConstants.apiKey}'},
    ),
  );
}
