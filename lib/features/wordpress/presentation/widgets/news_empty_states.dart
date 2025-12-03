import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearch ? Icons.search_off : Icons.article_outlined,
              size: 64,
              color: colors.textSecondary,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              isSearch ? 'news_empty_no_results'.tr() : 'news_empty_no_items'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeH2,
                color: colors.textSecondary,
              ),
            ),
          ],
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
      padding: EdgeInsets.only(top: DesignTokens.spacingXl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colors.textSecondary,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              'news_error_failed_to_load'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeH2,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

