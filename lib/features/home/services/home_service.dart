import 'package:dio/dio.dart';
import 'package:news_app/core/utils/constants/app_constants.dart';
import 'package:news_app/features/home/models/top_headline_body.dart';
import 'package:news_app/features/home/models/top_headlines_api_response.dart';

class HomeService {
  final aDio = Dio();
  Future<TopHeadlinesApiResponse> getHeadLines(TopHeadlineBody body) async {
    try {
      final header = {'Authorization': 'Bearer ${AppConstants.apiKey}'};
      aDio.options.baseUrl = AppConstants.baseUrl;
      final response = await aDio.get(
        AppConstants.topHeadlinesEndpoint,
        queryParameters: body.toMap(),
        options: Options(headers: header),
      );
      if (response.statusCode == 200) {
        return TopHeadlinesApiResponse.fromMap(response.data);
      } else {
        throw Exception('Failed to load top headlines');
      }
    } catch (error) {
      rethrow;
    }
  }
}
