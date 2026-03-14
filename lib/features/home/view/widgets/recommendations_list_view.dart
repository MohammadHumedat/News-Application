import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/views/widgets/bookmark_news.dart';
import 'package:news_app/features/bookmark/cubit/bookmark_cubit.dart';

class RecommendationsListView extends StatelessWidget {
  const RecommendationsListView({super.key, required this.articles});
  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemBuilder: (_, index) {
        final article = articles[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.articleDetailsPage,
              arguments: article,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: article.urlToImage ?? '',
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,

                        memCacheHeight: 110,
                        memCacheWidth: 110,
                        httpHeaders: const {
                          'Referer': 'https://videocardz.com/',
                        },
                        placeholder: (context, url) => Container(
                          width: 110,
                          height: 110,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 6,
                      right: 6,
                      height: 40,
                      width: 40,
                      child: BlocBuilder<BookmarkCubit, BookmarkState>(
                        buildWhen: (previous, current) =>
                            current is BookmarkLoaded ||
                            current is BookmarkError,

                        builder: (context, state) {
                          if (state is BookmarkLoaded) {
                            final isBookmarked = state.bookmarkedArticles.any(
                              (x) => x.url == article.url,
                            );
                            return BookmarkNews(
                              isBookmarked: isBookmarked,
                              onBookmarkToggle: () {
                                context.read<BookmarkCubit>().toggleBookmark(
                                  article,
                                );
                              },
                            );
                          } else if (state is BookmarkError) {
                            return const Icon(Icons.error, color: Colors.red);
                          } else {
                            return BookmarkNews(
                              isBookmarked: true,
                              onBookmarkToggle: () {
                                context.read<BookmarkCubit>().toggleBookmark(
                                  article,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.publishedAt.toString().substring(0, 10),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        article.title ?? 'No Title',
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        article.description ?? 'No Description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, index) => const SizedBox(height: 10),
      itemCount: articles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
