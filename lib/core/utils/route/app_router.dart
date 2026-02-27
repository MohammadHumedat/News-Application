import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/home/view/pages/home_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePage:
        return CupertinoPageRoute(
          builder: (_) => const HomePage(),
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
