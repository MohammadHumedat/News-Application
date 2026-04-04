// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:news_app/core/models/article_model.dart';

class NewsApiResponse {
  // this model is used to parse the response from the api, it contains the status of the response, the total number of results and a list of articles
  NewsApiResponse({
    required this.status,
    required this.totalResults,
    this.articles,
  });

  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  NewsApiResponse copyWith({
    String? status,
    int? totalResults,
    List<Article>? articles,
  }) {
    return NewsApiResponse(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'totalResults': totalResults,
      'articles': articles?.map((x) => x.toMap()).toList(),
    };
  }

  factory NewsApiResponse.fromMap(Map<String, dynamic> map) {
    return NewsApiResponse(
      status: map['status'] != null ? map['status'] as String : null,
      totalResults: map['totalResults'] != null
          ? map['totalResults'] as int
          : null,
      articles: map['articles'] != null
          ? List<Article>.from(
              (map['articles'] as List<dynamic>).map<Article?>(
                (x) => Article.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsApiResponse.fromJson(String source) =>
      NewsApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TopHeadlinesApiResponse(status: $status, totalResults: $totalResults, articles: $articles)';
}
