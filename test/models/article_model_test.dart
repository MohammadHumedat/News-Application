import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/models/news_api_response.dart';

void main() {
  group('Source Model', () {
    test('fromMap creates Source correctly', () {
      final map = {'id': 'bbc-news', 'name': 'BBC News'};
      final source = Source.fromMap(map);

      expect(source.id, 'bbc-news');
      expect(source.name, 'BBC News');
    });

    test('toMap returns correct map', () {
      const source = Source(id: 'bbc-news', name: 'BBC News');
      final map = source.toMap();

      expect(map['id'], 'bbc-news');
      expect(map['name'], 'BBC News');
    });

    test('fromMap handles null values', () {
      final source = Source.fromMap({'id': null, 'name': null});

      expect(source.id, isNull);
      expect(source.name, isNull);
    });

    test('two Sources with same data are equal', () {
      const a = Source(id: 'bbc-news', name: 'BBC News');
      const b = Source(id: 'bbc-news', name: 'BBC News');

      expect(a, equals(b));
    });
  });

  group('Article Model', () {
    late Map<String, dynamic> articleMap;

    setUp(() {
      articleMap = {
        'source': {'id': 'bbc-news', 'name': 'BBC News'},
        'author': 'John Doe',
        'title': 'Flutter is awesome',
        'description': 'A deep dive into Flutter',
        'url': 'https://example.com/article',
        'urlToImage': 'https://example.com/image.jpg',
        'publishedAt': '2024-01-01T00:00:00Z',
        'content': 'Flutter content here...',
      };
    });

    test('fromMap creates Article correctly', () {
      final article = Article.fromMap(articleMap);

      expect(article.author, 'John Doe');
      expect(article.title, 'Flutter is awesome');
      expect(article.source?.name, 'BBC News');
    });

    test('toMap returns correct map', () {
      final article = Article.fromMap(articleMap);
      final map = article.toMap();

      expect(map['author'], 'John Doe');
      expect(map['title'], 'Flutter is awesome');
    });

    test('fromMap handles null fields', () {
      final article = Article.fromMap({
        'source': null,
        'author': null,
        'title': null,
        'description': null,
        'url': null,
        'urlToImage': null,
        'publishedAt': null,
        'content': null,
      });

      expect(article.author, isNull);
      expect(article.title, isNull);
      expect(article.source, isNull);
    });

    test('toJson and fromJson roundtrip', () {
      final original = Article.fromMap(articleMap);
      final json = original.toJson();
      final restored = Article.fromJson(json);

      expect(restored, equals(original));
    });

    test('two Articles with same data are equal', () {
      final a = Article.fromMap(articleMap);
      final b = Article.fromMap(articleMap);

      expect(a, equals(b));
    });
  });

  group('NewsApiResponse Model', () {
    test('fromMap creates response correctly', () {
      final map = {
        'status': 'ok',
        'totalResults': 2,
        'articles': [
          {
            'source': {'id': null, 'name': 'CNN'},
            'author': 'Jane',
            'title': 'Test Article',
            'description': null,
            'url': 'https://cnn.com',
            'urlToImage': null,
            'publishedAt': '2024-01-01T00:00:00Z',
            'content': null,
          },
        ],
      };

      final response = NewsApiResponse.fromMap(map);

      expect(response.status, 'ok');
      expect(response.totalResults, 2);
      expect(response.articles?.length, 1);
      expect(response.articles?.first.title, 'Test Article');
    });

    test('fromMap handles null articles', () {
      final response = NewsApiResponse.fromMap({
        'status': 'ok',
        'totalResults': 0,
        'articles': null,
      });

      expect(response.articles, isNull);
    });
  });
}