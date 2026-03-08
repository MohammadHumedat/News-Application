import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/search_body.dart';
import 'package:news_app/features/search/cubit/search_state.dart';
import 'package:news_app/features/search/services/search_service.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final _searchService = SearchService();
  Future<void> search(String keyword) async {
    emit(SearchLoading());
    try {
      final body = SearchBody(query: keyword, pageSize: 20, page: 1);
      final response = await _searchService.search(body);
      emit(SearchSuccess(response));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  void clear() {
    emit(SearchInitial());
  }
}
