

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/utils/route/app_routes.dart';
// import 'package:news_app/core/utils/theme/app_colors.dart';

// class BookmarksPage extends StatelessWidget {
//   const BookmarksPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bookmarks'),
//         backgroundColor:
//             isDark ? AppColors.darkBackground : AppColors.lightBackground,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: BlocBuilder<BookmarkCubit, BookmarkState>(
//         builder: (context, state) {
//           if (state is BookmarkLoading) {
//             return const Center(child: CircularProgressIndicator.adaptive());
//           } else if (state is BookmarkLoaded) {
//             if (state.articles.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: AppColors.accent.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.bookmark_outline_rounded,
//                           color: AppColors.accent, size: 36),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No bookmarks yet',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge
//                           ?.copyWith(fontWeight: FontWeight.w700),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Save articles to read them later',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return ListView.builder(
//               itemCount: state.articles.length,
//               itemBuilder: (context, index) {
//                 return ArticleCard(
//                   article: state.articles[index],
//                   onTap: () => Navigator.pushNamed(
//                     context,
//                     AppRoutes.articleDetail,
//                     arguments: state.articles[index],
//                   ),
//                 );
//               },
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }