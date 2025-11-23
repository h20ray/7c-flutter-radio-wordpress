import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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
    context.read<WordPressBloc>().add(const GetPostsEvent());
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
                  color: DesignTokens.colorTextPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'home_news_subtitle'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeCaption,
                  color: DesignTokens.colorTextSecondary,
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
                        style: TextStyle(
                          color: DesignTokens.colorTextSecondary,
                        ),
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
                          return _buildNewsCard(context, post, index);
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
                                ? DesignTokens.colorHeaderGradientStart
                                : DesignTokens.colorBorderSubtle,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (failure) => SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    'Failed to load news',
                    style: TextStyle(
                      color: DesignTokens.colorTextSecondary,
                    ),
                  ),
                ),
              ),
              orElse: () => SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(BuildContext context, PostEntity post, int index) {
    return Container(
      margin: EdgeInsets.only(
        left: DesignTokens.spacingL,
        right: index == 4 ? DesignTokens.spacingL : DesignTokens.spacingM,
      ),
      padding: EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignTokens.colorHeaderGradientStart.withValues(alpha: 0.8),
            DesignTokens.colorHeaderGradientEnd.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'home_news_featured'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spacingS),
              Expanded(
                child: Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: DesignTokens.spacingS),
              Text(
                'Live coverage · Today 7 PM',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeCaption,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              Spacer(),
              Container(
                height: 36,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    'home_news_read_on_site'.tr(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeBody,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.colorHeaderGradientStart,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.article,
                color: Colors.white.withValues(alpha: 0.7),
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

