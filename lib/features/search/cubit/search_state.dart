import 'package:news_app/core/models/news_api_response.dart';

class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  SearchSuccess(this.response);
  final NewsApiResponse response;
}

final class SearchFailure extends SearchState {
  SearchFailure(this.error);
  final String error;
}
