import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class BookmarkNews extends StatelessWidget {
  const BookmarkNews({
    super.key,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        heightFactor: 1,
        widthFactor: 1,
        child: IconButton(
          constraints: const BoxConstraints(),
          onPressed: onBookmarkToggle,
          icon: isBookmarked
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_outline),
        ),
      ),
    );
  }
}
