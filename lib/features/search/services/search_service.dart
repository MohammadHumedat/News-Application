import 'package:dio/dio.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/models/search_body.dart';
import 'package:news_app/core/utils/constants/app_constants.dart';

class SearchService {
  final aDio = Dio();

  Future<NewsApiResponse> search(SearchBody body) async {
    try {
      aDio.options.baseUrl = AppConstants.baseUrl;
      final headers = {'Authorization': 'Bearer ${AppConstants.apiKey}'};
      final response = await aDio.get(
        AppConstants.everythingEndpoint,

        queryParameters: body.toMap(),
        options: Options(headers: headers),
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
