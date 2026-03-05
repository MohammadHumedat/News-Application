import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/models/top_headline_body.dart';

import 'package:news_app/features/home/models/top_headlines_api_response.dart';
import 'package:news_app/features/home/services/home_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final HomeService _homeService = HomeService();

  Future<void> fetchTopHeadlines() async {
    emit(TopHeadlinesLoading());
    try {
      final body = TopHeadlineBody(
        country: 'us',
        category: 'technology',
        page: 1,
        pageSize: 10,
      );
      final response = await _homeService.getHeadLines(body);
      emit(TopHeadlinesLoaded(response.articles!));
    } catch (error) {
      emit(TopHeadlinesError(error.toString()));
    }
  }

  Future<void> recommendedTopHeadlines() async {
    try {
      final body = TopHeadlineBody(page: 1, pageSize: 15);
      final response = await _homeService.getHeadLines(body);
      emit(TopHeadlinesLoaded(response.articles!));
    } catch (error) {
      emit(TopHeadlinesError(error.toString()));
    }
  }
}
