import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_featured_show.dart';

class FeaturedRadioSection extends StatelessWidget {
  final MockFeaturedShow? featuredShow;

  const FeaturedRadioSection({
    super.key,
    this.featuredShow,
  });

  @override
  Widget build(BuildContext context) {
    final show = featuredShow ?? MockFeaturedShow.defaultShow;

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
              color: DesignTokens.colorTextPrimary,
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
                  color: DesignTokens.colorBorderSubtle,
                  borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: show.hostImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                        child: Image.network(
                          show.hostImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 60,
                        color: DesignTokens.colorTextSecondary,
                      ),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    color: DesignTokens.colorCard,
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                          color: DesignTokens.colorTextPrimary,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: tag == 'Live'
                                  ? Colors.red
                                  : DesignTokens.colorSecondaryAccent,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Center(
                              child: Text(
                                tag == 'Live' ? 'home_featured_live'.tr() : tag,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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
                          color: DesignTokens.colorTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
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
                                    color: DesignTokens.colorTextSecondary,
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
                                    color: DesignTokens.colorTextPrimary,
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
                                backgroundColor: DesignTokens.colorPrimaryAccent,
                                foregroundColor: Colors.white,
                                minimumSize: Size(0, 36),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusButton),
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

