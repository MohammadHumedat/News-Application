import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/search/cubit/search_cubit.dart';
import 'package:news_app/features/search/cubit/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _searchFocusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        context.read<SearchCubit>().search(query.trim());
      } else {
        context.read<SearchCubit>().clear();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _onSearchChanged,
            cursorColor: AppColors.accent,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Search news by title...',
              hintStyle: TextStyle(color: textSecondary, fontSize: 15),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: textSecondary,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _clearSearch,
                      child: Icon(
                        Icons.cancel_rounded,
                        color: textSecondary,
                        size: 18,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: isDark
                  ? AppColors.darkCardBg
                  : const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, state) {
          if (state is SearchInitial) return _buildInitialState(textSecondary);
          if (state is SearchLoading) return _buildLoading();
          if (state is SearchSuccess) return _buildResults(state, isDark);
          if (state is SearchFailure) return _buildError(state.error);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // States

  Widget _buildInitialState(Color textSecondary) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'Search for any news topic',
            style: TextStyle(color: textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation(AppColors.accent),
      ),
    );
  }

  Widget _buildResults(SearchSuccess state, bool isDark) {
    final articles = state.response.articles ?? [];

    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color:
                  (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No results for "${_searchController.text}"',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: articles.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
      ),
      itemBuilder: (context, index) => _SearchResultItem(
        article: articles[index],
        isDark: isDark,
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.articleDetailsPage,
          arguments: articles[index],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.accent),
          const SizedBox(height: 12),
          const Text(
            'Something went wrong',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Search Result Item

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({
    required this.article,
    required this.isDark,
    required this.onTap,
  });

  final Article article;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 90,
                height: 90,
                child: article.urlToImage?.isNotEmpty == true
                    ? CachedNetworkImage(
                        imageUrl: article.urlToImage!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: isDark
                              ? AppColors.darkShimmer
                              : AppColors.lightShimmer,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: isDark
                              ? AppColors.darkShimmer
                              : AppColors.lightShimmer,
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      )
                    : Container(
                        color: isDark
                            ? AppColors.darkShimmer
                            : AppColors.lightShimmer,
                        child: const Icon(
                          Icons.article_rounded,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.source?.name != null)
                    Text(
                      article.source!.name!,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 3),
                  Text(
                    article.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(article.publishedAt),
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}
