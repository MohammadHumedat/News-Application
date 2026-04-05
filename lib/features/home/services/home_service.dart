import 'package:dio/dio.dart';
import 'package:news_app/core/utils/constants/app_constants.dart';
import 'package:news_app/features/home/models/top_headline_body.dart';
import 'package:news_app/core/models/news_api_response.dart';

class HomeService {
  HomeService(this.dio);
  final Dio dio;

  Future<NewsApiResponse> getHeadLines(TopHeadlineBody body) async {
    try {
      final response = await dio.get(
        AppConstants.topHeadlinesEndpoint,
        queryParameters: body.toMap(),
      );
      if (response.statusCode == 200) {
        return NewsApiResponse.fromMap(response.data);
      } else {
        throw Exception('Failed to load top headlines');
      }
    } catch (error) {
      rethrow;
    }
  }
}
