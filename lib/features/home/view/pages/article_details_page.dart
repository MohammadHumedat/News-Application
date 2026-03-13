import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/views/widgets/bookmark_news.dart';
import 'package:news_app/features/bookmark/cubit/bookmark_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatelessWidget {
  const ArticleDetailsPage({super.key, required this.article});

  final Article article;

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final min = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '${months[date.month - 1]} ${date.day}, ${date.year}  ·  $hour:$min $period';
    } catch (_) {
      return dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  String _cleanContent(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    return raw.replaceAll(RegExp(r'\s*\[\+\d+ chars?\]'), '').trim();
  }

  int _estimateReadTime(String text) {
    final words = text.trim().split(RegExp(r'\s+')).length;
    return (words / 200).ceil().clamp(1, 60);
  }

  Future<void> _launchUrl() async {
    if (article.url == null || article.url!.isEmpty) return;
    final uri = Uri.parse(article.url!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final dividerColor = isDark
        ? AppColors.darkDivider
        : AppColors.lightDivider;
    final cardBg = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;
    final cleanContent = _cleanContent(article.content);

    return Scaffold(
      backgroundColor: bgColor,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            _HeroImage(article: article, onBack: () => Navigator.pop(context)),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source + Read time
                  Row(
                    children: [
                      if (article.source?.name != null)
                        _SourceChip(name: article.source!.name!),
                      const Spacer(),
                      Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_estimateReadTime(article.content ?? article.description ?? '')} min read',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Title
                  Text(
                    article.title ?? '',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Author + Date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.accent.withValues(
                          alpha: 0.15,
                        ),
                        child: Text(
                          article.author?.isNotEmpty == true
                              ? article.author![0].toUpperCase()
                              : 'N',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author ?? 'Unknown Author',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatDate(article.publishedAt),
                              style: TextStyle(
                                color: textSecondary.withValues(alpha: 0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: dividerColor, height: 1),
                  const SizedBox(height: 20),

                  // Description
                  if (article.description?.isNotEmpty == true)
                    Text(
                      article.description!,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),

                  // Content
                  if (cleanContent.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      cleanContent,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),
                  ],

                  // Truncation notice
                  if (article.content != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: dividerColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Article preview is limited. Read the full story below.',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Read Full Article
                  if (article.url != null)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _launchUrl,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text(
                          'Read Full Article',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// helper classes

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.article, required this.onBack});

  final Article article;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarkCubit(),
      child: SizedBox(
        height: 300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            article.urlToImage?.isNotEmpty == true
                ? CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    httpHeaders: const {'Referer': 'https://newsapi.org/'},
                    placeholder: (_, __) =>
                        Container(color: AppColors.darkSurface),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.darkSurface,
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  )
                : Container(color: AppColors.darkSurface),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x88000000),
                    Colors.transparent,
                    Color(0xBB000000),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),

            BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                if (state is BookmarkLoaded) {
                  final isBookmarked = state.bookmarkedArticles.any(
                    (a) => a.url == article.url,
                  );
                  return BookmarkNews(
                    isBookmarked: isBookmarked,
                    onBookmarkToggle: () {
                      final cubit = context.read<BookmarkCubit>();
                      if (isBookmarked) {
                        cubit.toggleBookmark(article);
                      } else {
                        cubit.toggleBookmark(article);
                      }
                    },
                  );
                }
                return BookmarkNews(
                  isBookmarked: false,
                  onBookmarkToggle: () {},
                );
              },
            ),

            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                bottom: false,
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
