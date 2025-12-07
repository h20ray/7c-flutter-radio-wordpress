import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/app_color_system.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/haptic_widgets.dart';

class NewsSearchResultsHeader extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClear;

  const NewsSearchResultsHeader({
    super.key,
    required this.searchQuery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(
        top: DesignTokens.spacingL,
        bottom: DesignTokens.spacingS,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'news_search_results_for'.tr(namedArgs: {'query': searchQuery}),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBody,
                color: colors.textSecondary,
              ),
            ),
          ),
          HapticTextButton(
            onPressed: onClear,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.close, size: 16),
                const SizedBox(width: DesignTokens.spacingXs),
                Text('news_search_clear'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

