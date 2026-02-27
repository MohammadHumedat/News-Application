// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TopHeadlineBody {
  // this model is used to send the request body to the api, it contains the parameters that are used to filter the news articles
  TopHeadlineBody({
    this.country = 'us',
    this.category,
    this.source,
    this.q,
    this.pageSize,
    this.page,
  });
  final String country;
  final String? category;
  final String? source;
  final String? q;
  final int? pageSize;
  final int? page;

  TopHeadlineBody copyWith({
    String? country,
    String? category,
    String? source,
    String? q,
    int? pageSize,
    int? page,
  }) {
    return TopHeadlineBody(
      country: country ?? this.country,
      category: category ?? this.category,
      source: source ?? this.source,
      q: q ?? this.q,
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'category': category,
      'source': source,
      'q': q,
      'pageSize': pageSize,
      'page': page,
    };
  }

  factory TopHeadlineBody.fromMap(Map<String, dynamic> map) {
    return TopHeadlineBody(
      country: map['country'] as String,
      category: map['category'] != null ? map['category'] as String : null,
      source: map['source'] != null ? map['source'] as String : null,
      q: map['q'] != null ? map['q'] as String : null,
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      page: map['page'] != null ? map['page'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopHeadlineBody.fromJson(String source) =>
      TopHeadlineBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TopHeadlineBody(country: $country, category: $category, source: $source, q: $q, pageSize: $pageSize, page: $page)';
  }

  @override
  bool operator ==(covariant TopHeadlineBody other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.category == category &&
        other.source == source &&
        other.q == q &&
        other.pageSize == pageSize &&
        other.page == page;
  }

  @override
  int get hashCode {
    return country.hashCode ^
        category.hashCode ^
        source.hashCode ^
        q.hashCode ^
        pageSize.hashCode ^
        page.hashCode;
  }
}
