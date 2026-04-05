import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/home/models/top_headline_body.dart';
import 'package:news_app/features/home/services/home_service.dart';

class HomeRepository {
  HomeRepository(this.homeService);
  final HomeService homeService;

  Future<NewsApiResponse> getHeadlines(TopHeadlineBody body) {
    return homeService.getHeadLines(body);
  }
}
