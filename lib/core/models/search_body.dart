// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchBody {
  SearchBody({
    required this.query,
     this.searchIn,
     this.pageSize,
     this.page,
  });
  final String query;
  final String? searchIn;
  final int? pageSize;
  final int? page;

  SearchBody copyWith({
    String? query,
    String? searchIn,
    int? pageSize,
    int? page,
  }) {
    return SearchBody(
      query: query ?? this.query,
      searchIn: searchIn ?? this.searchIn,
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'query': query,
      'searchIn': searchIn,
      'pageSize': pageSize,
      'page': page,
    };
  }

  factory SearchBody.fromMap(Map<String, dynamic> map) {
    return SearchBody(
      query: map['query'] as String,
      searchIn: map['searchIn'] as String,
      pageSize: map['pageSize'] as int,
      page: map['page'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchBody.fromJson(String source) =>
      SearchBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchBody(query: $query, searchIn: $searchIn, pageSize: $pageSize, page: $page)';
  }

  @override
  bool operator ==(covariant SearchBody other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.searchIn == searchIn &&
        other.pageSize == pageSize &&
        other.page == page;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        searchIn.hashCode ^
        pageSize.hashCode ^
        page.hashCode;
  }
}
