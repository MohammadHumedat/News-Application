part of 'bookmark_cubit.dart';


sealed class BookmarkState {}

final class BookmarkInitial extends BookmarkState {}

final class BookmarkLoading extends BookmarkState {}
final class BookmarkLoaded extends BookmarkState {
  BookmarkLoaded(this.bookmarkedArticles);
  final List<Article> bookmarkedArticles;
}
final class BookmarkError extends BookmarkState {

  BookmarkError(this.message);
  final String message;
}
