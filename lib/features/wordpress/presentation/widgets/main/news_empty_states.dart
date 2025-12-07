import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/themes/app_color_system.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../bloc/news_feed_bloc.dart';

class NewsEmptyState extends StatelessWidget {
  final bool isSearch;

  const NewsEmptyState({
    super.key,
    required this.isSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSearch ? LucideIcons.search : LucideIcons.newspaper,
                size: 64,
                color: colors.textSecondary,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                isSearch ? 'news_empty_no_results'.tr() : 'news_empty_no_items'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH2,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingS),
              Text(
                isSearch 
                    ? 'news_empty_no_results_desc'.tr() 
                    : 'news_empty_no_items_desc'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBody,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isSearch) ...[
                const SizedBox(height: DesignTokens.spacingXl),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<NewsFeedBloc>().add(
                      const NewsFeedEvent.getPosts(
                        useNewsPageLimit: true,
                        forceRefresh: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text('retry'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.colorScheme.primary,
                    foregroundColor: colors.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                      vertical: DesignTokens.spacingM,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NewsSearchLoadingState extends StatelessWidget {
  const NewsSearchLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              colors.primaryAccent,
            ),
          ),
          SizedBox(height: DesignTokens.spacingM),
          Text(
            'news_search_hint'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeBody,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class NewsErrorState extends StatelessWidget {
  const NewsErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingXl,
        vertical: DesignTokens.spacingXl,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colors.colorScheme.error,
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'news_error_failed_to_load'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeH2,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              'news_error_failed_to_load_desc'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBody,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXl),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NewsFeedBloc>().add(
                  const NewsFeedEvent.getPosts(
                    useNewsPageLimit: true,
                    forceRefresh: true,
                  ),
                );
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.colorScheme.primary,
                foregroundColor: colors.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: DesignTokens.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

