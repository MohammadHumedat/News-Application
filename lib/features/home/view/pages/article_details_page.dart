import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/home/models/top_headlines_api_response.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatefulWidget {
  const ArticleDetailsPage({super.key, required this.article});
  final Article article;

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  bool _isBookmarked = false;
  double _scrollOffset = 0;

  static const double _heroHeight = 340.0;
  static const double _appBarCollapsePoint = _heroHeight - kToolbarHeight - 60;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() => _scrollOffset = _scrollController.offset);
      });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  double get _appBarOpacity {
    if (_scrollOffset <= 0) return 0.0;
    return (_scrollOffset / _appBarCollapsePoint).clamp(0.0, 1.0);
  }

  Future<void> _launchArticleUrl() async {
    final url = widget.article.url;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatPublishedDate(String? dateStr) {
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
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final period = date.hour >= 12 ? 'PM' : 'AM';
      final min = date.minute.toString().padLeft(2, '0');
      return '${months[date.month - 1]} ${date.day}, ${date.year}  ·  $hour:$min $period';
    } catch (_) {
      return dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  String _cleanContent(String? raw) {
    if (raw == null) return '';

    return raw.replaceAll(RegExp(r'\s*\[\+\d+ chars?\]'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final article = widget.article;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;
    final dividerColor = isDark
        ? AppColors.darkDivider
        : AppColors.lightDivider;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _appBarOpacity > 0.5 && !isDark
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // Main Scrollable Content
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Hero Image
                SliverToBoxAdapter(
                  child: _HeroImage(
                    article: article,
                    height: _heroHeight,
                    onBack: () => Navigator.pop(context),
                    isBookmarked: _isBookmarked,
                    onBookmark: () =>
                        setState(() => _isBookmarked = !_isBookmarked),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        // Pull up to overlap the hero slightly
                        transform: Matrix4.translationValues(0, -28, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag handle
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 12,
                                  bottom: 20,
                                ),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: dividerColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Source chip + Category
                                  Row(
                                    children: [
                                      if (article.source?.name != null)
                                        _SourceChip(
                                          name: article.source!.name!,
                                        ),
                                      const Spacer(),
                                      _ReadTimeChip(
                                        content:
                                            article.content ??
                                            article.description ??
                                            '',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  // Title
                                  Text(
                                    article.title ?? 'No Title',
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      height: 1.35,
                                      letterSpacing: -0.4,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Author + Date row
                                  _AuthorDateRow(
                                    author: article.author,
                                    date: _formatPublishedDate(
                                      article.publishedAt,
                                    ),
                                    textSecondary: textSecondary,
                                    cardBg: cardBg,
                                  ),

                                  const SizedBox(height: 20),

                                  Divider(color: dividerColor, height: 1),

                                  const SizedBox(height: 20),

                                  // Description
                                  if (article.description != null &&
                                      article.description!.isNotEmpty) ...[
                                    _BodyText(
                                      text: article.description!,
                                      color: textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      isLead: true,
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Content
                                  if (article.content != null &&
                                      article.content!.isNotEmpty) ...[
                                    _BodyText(
                                      text: _cleanContent(article.content),
                                      color: textSecondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 24),
                                  ],

                                  // Truncation notice
                                  if (article.content != null &&
                                      article.url != null)
                                    _TruncationNotice(
                                      cardBg: cardBg,
                                      dividerColor: dividerColor,
                                      textSecondary: textSecondary,
                                    ),

                                  const SizedBox(height: 28),
                                ],
                              ),
                            ),

                            // Read Full Article Button
                            if (article.url != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                child: _ReadFullButton(
                                  onTap: _launchArticleUrl,
                                ),
                              ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Floating App Bar (appears on scroll)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _appBarOpacity,
                duration: const Duration(milliseconds: 50),
                child: Container(
                  color: bgColor,
                  child: SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          _CircleIconBtn(
                            icon: Icons.arrow_back_rounded,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            bgColor: Colors.transparent,
                            onTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Text(
                            article.source?.name ?? '',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
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

class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.article,
    required this.height,
    required this.onBack,
    required this.isBookmarked,
    required this.onBookmark,
  });

  final Article article;
  final double height;
  final VoidCallback onBack;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          article.urlToImage != null && article.urlToImage!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  fit: BoxFit.cover,
                  httpHeaders: const {'Referer': 'https://newsapi.org/'},
                  placeholder: (_, __) => Container(
                    color: AppColors.darkSurface,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.darkSurface,
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.white38,
                      size: 48,
                    ),
                  ),
                )
              : Container(
                  color: AppColors.darkSurface,
                  child: const Icon(
                    Icons.article_rounded,
                    color: Colors.white24,
                    size: 64,
                  ),
                ),

          // Top scrim for button visibility
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Color(0xCC000000), Colors.transparent],
              ),
            ),
          ),

          // Bottom scrim
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Color(0xDD000000), Colors.transparent],
              ),
            ),
          ),

          // Buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: onBack,
                    ),
                    _CircleIconBtn(
                      icon: isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      iconColor: isBookmarked ? AppColors.accent : Colors.white,
                      onTap: onBookmark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
    this.color,
    this.bgColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color? color;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: bgColor ?? Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? iconColor, size: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: AppColors.accent.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
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
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadTimeChip extends StatelessWidget {
  const _ReadTimeChip({required this.content});
  final String content;

  int get _readMinutes {
    final wordCount = content.trim().split(RegExp(r'\s+')).length;
    return ((wordCount / 200).ceil()).clamp(1, 60);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$_readMinutes min read',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorDateRow extends StatelessWidget {
  const _AuthorDateRow({
    required this.author,
    required this.date,
    required this.textSecondary,
    required this.cardBg,
  });

  final String? author;
  final String date;
  final Color textSecondary;
  final Color cardBg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Author avatar
        CircleAvatar(
          radius: 18,
          // ignore: deprecated_member_use
          backgroundColor: AppColors.accent.withOpacity(0.15),
          child: Text(
            author != null && author!.isNotEmpty
                ? author![0].toUpperCase()
                : 'N',
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author ?? 'Unknown Author',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: textSecondary.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText({
    required this.text,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    this.isLead = false,
  });

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLead;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: isLead ? 1.55 : 1.7,
        letterSpacing: isLead ? -0.1 : 0,
      ),
    );
  }
}

class _TruncationNotice extends StatelessWidget {
  const _TruncationNotice({
    required this.cardBg,
    required this.dividerColor,
    required this.textSecondary,
  });

  final Color cardBg;
  final Color dividerColor;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Article preview is limited. Tap below to read the full story.',
              style: TextStyle(color: textSecondary, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadFullButton extends StatelessWidget {
  const _ReadFullButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Read Full Article',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.open_in_new_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
