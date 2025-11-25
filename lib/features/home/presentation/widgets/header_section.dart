import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_user_profile.dart';
import 'radio_game_tabs.dart';

class HeaderSection extends StatelessWidget {
  final MockUserProfile? userProfile;
  final int selectedGameTab;
  final ValueChanged<int> onGameTabChanged;

  const HeaderSection({
    super.key,
    this.userProfile,
    required this.selectedGameTab,
    required this.onGameTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final profile = userProfile ?? MockUserProfile.defaultProfile;
    final tokens = HomeHeaderTokens.of(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: 190 + statusBarHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tokens.backgroundStart, tokens.backgroundEnd],
        ),
      ),
      padding: EdgeInsets.only(
        top: statusBarHeight + 32,
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
                        color: tokens.avatarFill,
                        border: Border.all(
                          color: tokens.avatarBorder,
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
                              color: tokens.primaryText,
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
                            'home_header_listener_id'.tr(
                              namedArgs: {'id': profile.listenerId},
                            ),
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeH2,
                              fontWeight: DesignTokens.fontWeightH2,
                              color: tokens.primaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 2),
                          Text(
                            profile.favoriteStation != null
                                ? 'home_header_favorite_station'.tr(
                                    namedArgs: {
                                      'station': profile.favoriteStation!,
                                    },
                                  )
                                : 'home_header_now_playing'.tr(
                                    namedArgs: {'show': 'Radio Show'},
                                  ),
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeCaption,
                              fontWeight: DesignTokens.fontWeightCaption,
                              color: tokens.secondaryText,
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
                      color: tokens.badgeBackground,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.cornerRadiusButton,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'home_header_go_premium'.tr(),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeCaption,
                          fontWeight: FontWeight.w600,
                          color: tokens.badgeText,
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
                      color: tokens.tileBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: Icon(LucideIcons.bell, color: tokens.tileIcon),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingL),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: DesignTokens.spacingL),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _getGreeting().tr(),
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeBody,
                        color: tokens.secondaryText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: DesignTokens.spacingM),
              RadioGameTabs(
                selectedIndex: selectedGameTab,
                onChanged: onGameTabChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return 'greeting_morning';
    } else if (hour >= 11 && hour < 15) {
      return 'greeting_midday';
    } else if (hour >= 15 && hour < 19) {
      return 'greeting_evening';
    } else {
      return 'greeting_night';
    }
  }
}
