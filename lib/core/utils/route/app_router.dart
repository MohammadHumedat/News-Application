import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/bookmark/views/pages/bookmarks_page.dart';
import 'package:news_app/features/home/view/pages/article_details_page.dart';
import 'package:news_app/features/home/view/pages/home_page.dart';
import 'package:news_app/features/search/cubit/search_cubit.dart';
import 'package:news_app/features/search/views/pages/search_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePage:
        return CupertinoPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case AppRoutes.bookmark:
        return MaterialPageRoute(
          builder: (_) => const BookmarksPage(),
          settings: settings,
        );
      case AppRoutes.searchPage:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SearchCubit(),
            child: const SearchPage(),
          ),
          settings: settings,
        );
      case AppRoutes.articleDetailsPage:
        final article = settings.arguments as Article;
        return CupertinoPageRoute(
          builder: (_) => ArticleDetailsPage(article: article),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
          settings: settings,
        );
    }
  }
}
