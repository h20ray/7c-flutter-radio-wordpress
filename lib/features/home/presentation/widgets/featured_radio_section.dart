import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_featured_show.dart';

class FeaturedRadioSection extends StatelessWidget {
  final MockFeaturedShow? featuredShow;

  const FeaturedRadioSection({super.key, this.featuredShow});

  @override
  Widget build(BuildContext context) {
    final show = featuredShow ?? MockFeaturedShow.defaultShow;
    final colors = context.appColors;
    final tokens = FeaturedRadioTokens.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Text(
            'home_featured_shows_title'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH1,
              fontWeight: DesignTokens.fontWeightH1,
              color: colors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: 200,
                decoration: BoxDecoration(
                  color: tokens.hostFrameBackground,
                  borderRadius: BorderRadius.circular(
                    DesignTokens.cornerRadiusCard,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: tokens.shadowSoft,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: show.hostImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.cornerRadiusCard,
                        ),
                        child: Image.network(
                          show.hostImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.person, size: 60, color: colors.textSecondary),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 200),
                  padding: EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: tokens.shadowStrong,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        show.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: DesignTokens.spacingS),
                      Wrap(
                        spacing: DesignTokens.spacingS,
                        runSpacing: DesignTokens.spacingS,
                        children: show.tags.map((tag) {
                          return Container(
                            height: 22,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: tag == 'Live'
                                  ? tokens.tagLiveBackground
                                  : tokens.tagDefaultBackground,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Center(
                              child: Text(
                                tag == 'Live' ? 'home_featured_live'.tr() : tag,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: tokens.tagText,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: DesignTokens.spacingS),
                      Text(
                        show.schedule,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: DesignTokens.spacingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'home_featured_next_up_in'.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  show.nextUpIn ?? '0 min',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: DesignTokens.spacingS),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primaryAccent,
                                foregroundColor: colorScheme.onTertiary,
                                minimumSize: Size(0, 36),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.cornerRadiusButton,
                                  ),
                                ),
                              ),
                              child: Text(
                                'home_featured_listen'.tr(),
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
