part of 'home_cubit.dart';

class HomeState {}

final class HomeInitial extends HomeState {}

final class TopHeadlinesLoading extends HomeState {}

final class TopHeadlinesLoaded extends HomeState {
  TopHeadlinesLoaded(this.articles);
  final List<Article> articles;
}

final class TopHeadlinesError extends HomeState {
  TopHeadlinesError(this.message);
  final String message;
}

final class RecommendedNewsLoading extends HomeState {}

final class RecommendedNewsLoaded extends HomeState {
  RecommendedNewsLoaded(this.articles);
  final List<Article> articles;
}

final class RecommendedNewsError extends HomeState {}
