import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/home/cubit/home_cubit.dart';

import 'package:news_app/features/home/view/widgets/HomeTitleBuilder.dart';
import 'package:news_app/features/home/view/widgets/home_carousel_slider.dart';
import 'package:news_app/features/home/view/widgets/recommendations_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocProvider(
      create: (context) {
        final cubit = HomeCubit();
        cubit.fetchTopHeadlines();
        cubit.recommendedTopHeadlines();
        return cubit;
      },
      child: Scaffold(
        drawer: const Drawer(child: Center(child: Text('Drawer content here'))),
        appBar: AppBar(
          title: const Text('News App'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          leading: AppBarButton(
            iconNeeded: Icons.menu,
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            AppBarButton(
              iconNeeded: Icons.search,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.searchPage);
              },
            ),
            AppBarButton(
              iconNeeded: Icons.notifications,
              onTap: () {
                // Implement notification functionality
              },
            ),
          ],
        ),
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeTitleBuilder(title: 'Breaking news', onTap: () {}),
                const SizedBox(height: 15),
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      current is TopHeadlinesLoading ||
                      current is TopHeadlinesLoaded ||
                      current is TopHeadlinesError,
                  builder: (context, state) {
                    if (state is TopHeadlinesLoading) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (state is TopHeadlinesError) {
                      return ErrorWidget(Exception);
                    } else if (state is TopHeadlinesLoaded) {
                      final articles = state.articles
                          .where(
                            (x) =>
                                x.url != null &&
                                x.url!.isNotEmpty &&
                                x.urlToImage != null &&
                                x.urlToImage!.isNotEmpty,
                          )
                          .take(10)
                          .toList();
                      return Column(
                        // CarouselSlider widget
                        children: [
                          HomeCarouselSlider(articles: articles),
                          const SizedBox(height: 20),
                          HomeTitleBuilder(
                            title: 'Recommendation',
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          RecommendationsListView(articles: articles),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
