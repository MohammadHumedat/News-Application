// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

class Article {
  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  Article copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
  }) {
    return Article(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source?.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: map['source'] != null
          ? Source.fromMap(map['source'] as Map<String, dynamic>)
          : null,
      author: map['author'] != null ? map['author'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      url: map['url'] != null ? map['url'] as String : null,
      urlToImage: map['urlToImage'] != null
          ? map['urlToImage'] as String
          : null,
      publishedAt: map['publishedAt'] != null
          ? map['publishedAt'] as String
          : null,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content)';
  }

  @override
  bool operator ==(covariant Article other) {
    if (identical(this, other)) return true;

    return other.source == source &&
        other.author == author &&
        other.title == title &&
        other.description == description &&
        other.url == url &&
        other.urlToImage == urlToImage &&
        other.publishedAt == publishedAt &&
        other.content == content;
  }

  @override
  int get hashCode {
    return source.hashCode ^
        author.hashCode ^
        title.hashCode ^
        description.hashCode ^
        url.hashCode ^
        urlToImage.hashCode ^
        publishedAt.hashCode ^
        content.hashCode;
  }
}

class Source {
  const Source({this.id, this.name});
  final String? id;
  final String? name;

  Source copyWith({String? id, String? name}) {
    return Source(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Source.fromJson(String source) =>
      Source.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Source(id: $id, name: $name)';

  @override
  bool operator ==(covariant Source other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
