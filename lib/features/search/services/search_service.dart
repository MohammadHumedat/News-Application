import 'package:dio/dio.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/models/search_body.dart';
import 'package:news_app/core/utils/constants/app_constants.dart';

class SearchService {
  SearchService(this.dio);
  final Dio dio;
  Future<NewsApiResponse> search(SearchBody body) async {
    try {
      final response = await dio.get(
        AppConstants.everythingEndpoint,

        queryParameters: body.toMap(),
      );
      if (response.statusCode == 200) {
        return NewsApiResponse.fromMap(response.data);
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
