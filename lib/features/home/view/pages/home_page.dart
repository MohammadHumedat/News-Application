import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/cubit/home_cubit.dart';

import 'package:news_app/features/home/view/widgets/HomeTitleBuilder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = HomeCubit();
        cubit.fetchTopHeadlines();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

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
                        children: [
                          CarouselSlider(
                            items: articles
                                .map(
                                  (article) => Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl: article.urlToImage!,
                                            fit: BoxFit.cover,
                                            width: 1000.0,
                                            httpHeaders: const {
                                              'Referer':
                                                  'https://videocardz.com/',
                                            },

                                            placeholder: (context, url) =>
                                                const Center(
                                                  child:
                                                      CircularProgressIndicator.adaptive(),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                      ),
                                                    ),
                                          ),
                                          Positioned(
                                            bottom: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                      200,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    Color.fromARGB(0, 0, 0, 0),
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0,
                                                  ),
                                              child: Text(
                                                article.title!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              height: 230,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                              aspectRatio: 16 / 9,
                              initialPage: 0,
                            ),
                          ),
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
