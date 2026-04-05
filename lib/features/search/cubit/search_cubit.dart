import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/search_body.dart';
import 'package:news_app/features/search/cubit/search_state.dart';
import 'package:news_app/features/search/repo/search_repo.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.repo) : super(SearchInitial());
  final SearchRepository repo;

  Future<void> search(String keyword) async {
    emit(SearchLoading());
    try {
      final body = SearchBody(query: keyword, pageSize: 20, page: 1);
      final response = await repo.search(body);
      emit(SearchSuccess(response));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  void clear() {
    emit(SearchInitial());
  }
}
