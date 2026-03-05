import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/home/models/top_headlines_api_response.dart';

class ArticleDetailsPage extends StatelessWidget {
  const ArticleDetailsPage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(elevation: 0),
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? '',
            placeholder: (context, url) => Container(
              width: 110,
              height: 110,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.backgroundColor),
              child: Column(children: [Text(article.content ?? ' ')]),
            ),
          ),
        ],
      ),
    );
  }
}
