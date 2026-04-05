import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/models/search_body.dart';
import 'package:news_app/features/search/services/search_service.dart';

class SearchRepository {
  SearchRepository(this.searchService);
  final SearchService searchService;

  Future<NewsApiResponse> search(SearchBody body) async {
    return await searchService.search(body);
  }
}
