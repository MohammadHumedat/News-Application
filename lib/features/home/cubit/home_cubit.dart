import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/features/home/models/top_headline_body.dart';
import 'package:news_app/features/home/repo/home_repository.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repo) : super(HomeInitial());
  final HomeRepository repo;

  Future<void> fetchTopHeadlines() async {
    emit(TopHeadlinesLoading());
    try {
      final body = TopHeadlineBody(
        country: 'us',
        category: 'technology',
        page: 1,
        pageSize: 10,
      );
      final response = await repo.getHeadlines(body);
      emit(TopHeadlinesLoaded(response.articles!));
    } catch (error) {
      emit(TopHeadlinesError(error.toString()));
    }
  }

  Future<void> recommendedTopHeadlines() async {
    try {
      final body = TopHeadlineBody(page: 1, pageSize: 15);
      final response = await repo.getHeadlines(body);
      emit(TopHeadlinesLoaded(response.articles!));
    } catch (error) {
      emit(TopHeadlinesError(error.toString()));
    }
  }
}
