import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../wordpress/presentation/bloc/wordpress_bloc.dart';
import '../../../wordpress/domain/entities/post_entity.dart';

class LatestNewsCarousel extends StatefulWidget {
  const LatestNewsCarousel({super.key});

  @override
  State<LatestNewsCarousel> createState() => _LatestNewsCarouselState();
}

class _LatestNewsCarouselState extends State<LatestNewsCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final state = context.read<WordPressBloc>().state;
    state.maybeWhen(
      loaded: (_) {},
      loading: () {},
      orElse: () {
        context.read<WordPressBloc>().add(const GetPostsEvent());
      },
    );
    
    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tokens = NewsCardTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home_news_title'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH1,
                  fontWeight: DesignTokens.fontWeightH1,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'home_news_subtitle'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeCaption,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        BlocBuilder<WordPressBloc, WordPressState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (posts) {
                if (posts.isEmpty) {
                  return SizedBox(
                    height: 160,
                    child: Center(
                      child: Text(
                        'No news available',
                        style: TextStyle(color: colors.textSecondary),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: posts.length > 5 ? 5 : posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return _buildNewsCard(context, post, index, tokens);
                        },
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        posts.length > 5 ? 5 : posts.length,
                        (index) => Container(
                          width: 6,
                          height: 6,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? colors.gradientStart
                                : colors.borderSubtle,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (failure) => SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    'Failed to load news',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
              ),
              orElse: () => SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(
    BuildContext context,
    PostEntity post,
    int index,
    NewsCardTokens tokens,
  ) {
    final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;
    
    return Container(
      margin: EdgeInsets.only(
        left: DesignTokens.spacingL,
        right: index == 4 ? DesignTokens.spacingL : DesignTokens.spacingM,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(color: tokens.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      child: Stack(
        children: [
            if (hasImage)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: post.featuredImageUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  memCacheHeight: 600,
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [tokens.gradientStart, tokens.gradientEnd],
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [tokens.gradientStart, tokens.gradientEnd],
                      ),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 48,
                    ),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [tokens.gradientStart, tokens.gradientEnd],
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  if (post.categoryName != null && post.categoryName!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tokens.badgeBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                        post.categoryName!,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    fontWeight: FontWeight.w600,
                    color: tokens.badgeText,
                  ),
                ),
              ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                      if (post.date != null) ...[
              SizedBox(height: DesignTokens.spacingS),
              Text(
                          _formatDate(post.date!, context),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeCaption,
                            color: Colors.white.withValues(alpha: 0.9),
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black.withValues(alpha: 0.5),
              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'news_just_now'.tr();
    } else if (difference.inMinutes < 60) {
      return 'news_minutes_ago'.tr(namedArgs: {'minutes': '${difference.inMinutes}'});
    } else if (difference.inHours < 24) {
      return 'news_hours_ago'.tr(namedArgs: {'hours': '${difference.inHours}'});
    } else if (difference.inDays < 7) {
      return 'news_days_ago'.tr(namedArgs: {'days': '${difference.inDays}'});
    } else {
      final locale = context.locale;
      if (locale.languageCode == 'id') {
        return '${date.day}/${date.month}/${date.year}';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    }
  }
}
