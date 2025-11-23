import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_user_profile.dart';

class HeaderSection extends StatelessWidget {
  final MockUserProfile? userProfile;

  const HeaderSection({
    super.key,
    this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final profile = userProfile ?? MockUserProfile.defaultProfile;

    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignTokens.colorHeaderGradientStart,
            DesignTokens.colorHeaderGradientEnd,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: 32,
        left: DesignTokens.spacingL,
        right: DesignTokens.spacingL,
        bottom: DesignTokens.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: profile.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                profile.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              LucideIcons.user,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                    SizedBox(width: DesignTokens.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'home_header_listener_id'.tr(namedArgs: {'id': profile.listenerId}),
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeH2,
                              fontWeight: DesignTokens.fontWeightH2,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 2),
                          Text(
                            profile.favoriteStation != null
                                ? 'home_header_favorite_station'.tr(
                                    namedArgs: {'station': profile.favoriteStation!},
                                  )
                                : 'home_header_now_playing'.tr(
                                    namedArgs: {'show': 'Radio Show'},
                                  ),
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeCaption,
                              fontWeight: DesignTokens.fontWeightCaption,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: DesignTokens.spacingS),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 32,
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusButton),
                    ),
                    child: Center(
                      child: Text(
                        'home_header_go_premium'.tr(),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeCaption,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(width: DesignTokens.spacingS),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: Icon(LucideIcons.bell),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingL),
          Text(
            'home_header_your_radio_plan'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeBody,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

