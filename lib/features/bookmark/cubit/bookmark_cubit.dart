import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';

import 'package:news_app/core/services/local_database_hive.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitial());
  // Hive instance to manage local storage of bookmarks
  final LocalDataBaseHive localDataBaseHive = LocalDataBaseHive();

  Future<void> loadBookmarks() async {
    emit(BookmarkLoading());
    try {
      final data =
          await localDataBaseHive.getData<List>('bookmarkedArticles') ?? [];
      final articles = data
          .map((json) => Article.fromJson(json as String))
          .toList();
      emit(BookmarkLoaded(articles));
    } catch (e) {
      emit(BookmarkError('Failed to load bookmarks: $e'));
    }
  }

  Future<void> toggleBookmark(Article article) async {
    try {
      final stored =
          await localDataBaseHive.getData<List>('bookmarkedArticles') ?? [];
      // Copy to a mutable list since Hive may return an unmodifiable one
      final bookmarkedArticles = List<dynamic>.from(stored);
      final articleJson = article.toJson();
      if (bookmarkedArticles.contains(articleJson)) {
        bookmarkedArticles.remove(articleJson);
      } else {
        bookmarkedArticles.add(articleJson);
      }
      await localDataBaseHive.saveData(
        'bookmarkedArticles',
        bookmarkedArticles,
      );
      loadBookmarks();
    } catch (e) {
      emit(BookmarkError('Failed to toggle bookmark: $e'));
      rethrow;
    }
  }

  Future<bool> isBookmarked(Article article) async {
    try {
      final bookmarkedArticles =
          await localDataBaseHive.getData<List>('bookmarkedArticles') ?? [];
      return bookmarkedArticles.contains(article.toJson());
    } catch (e) {
      emit(BookmarkError('Failed to check bookmark: $e'));
      rethrow;
    }
  }

  Future<void> clearBookmarks() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.remove('bookmarkedArticles');
      await localDataBaseHive.deleteData('bookmarkedArticles');
      loadBookmarks();
    } catch (e) {
      emit(BookmarkError('Failed to clear bookmarks: $e'));
    }
  }
}
