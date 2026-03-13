import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitial());

  Future<void> loadBookmarks() async {
    emit(BookmarkLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('bookmarkedArticles') ?? [];
      final articles = data.map((e) => Article.fromJson(e)).toList();
      emit(BookmarkLoaded(articles));
    } catch (e) {
      emit(BookmarkError('Failed to load bookmarks: $e'));
    }
  }

  Future<void> toggleBookmark(Article article) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> bookmarkedArticles =
          prefs.getStringList('bookmarkedArticles') ?? [];
      String articleJson = article.toJson();
      if (bookmarkedArticles.contains(articleJson)) {
        bookmarkedArticles.remove(articleJson);
      } else {
        bookmarkedArticles.add(articleJson);
      }
      await prefs.setStringList('bookmarkedArticles', bookmarkedArticles);
      loadBookmarks();
    } catch (e) {
      emit(BookmarkError('Failed to toggle bookmark: $e'));
      rethrow;
    }
  }
}
