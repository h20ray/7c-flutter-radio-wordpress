import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_user_profile.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/themes/m3x_menu_style.dart';
import '../../data/social_media_service.dart';
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
                    MenuAnchor(
                      style: M3XMenuStyle.menuStyle,
                      alignmentOffset: const Offset(0, 8),
                      builder: (context, controller, child) {
                        return GestureDetector(
                          onTap: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          child: Container(
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
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          style: M3XMenuStyle.itemStyle,
                          leadingIcon: Icon(LucideIcons.log_in, size: 20),
                          child: Text('Login'),
                          onPressed: () {
                            // TODO: Implement Login
                          },
                        ),
                        Builder(
                          builder: (context) {
                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;
                            final adaptiveTheme = AdaptiveTheme.of(context);
                            return MenuItemButton(
                          style: M3XMenuStyle.itemStyle,
                          leadingIcon: Icon(
                                isDark ? LucideIcons.sun : LucideIcons.moon,
                            size: 20,
                          ),
                              child: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                          onPressed: () {
                                if (isDark) {
                                  adaptiveTheme.setLight();
                                } else {
                                  adaptiveTheme.setDark();
                                }
                              },
                            );
                          },
                        ),
                        MenuItemButton(
                          style: M3XMenuStyle.itemStyle,
                          leadingIcon: Icon(LucideIcons.settings, size: 20),
                          child: Text('Settings'),
                          onPressed: () {
                            // TODO: Implement Settings
                          },
                        ),
                        const SizedBox(height: M3XMenuStyle.gapSize),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        const SizedBox(height: M3XMenuStyle.gapSize),
                        SubmenuButton(
                          style: M3XMenuStyle.itemStyle,
                          leadingIcon: Icon(LucideIcons.share_2, size: 20),
                          menuChildren: [
                            FutureBuilder<Map<String, String>>(
                              future: SocialMediaService().getSocialMediaLinks(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }

                                if (snapshot.hasError ||
                                    !snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const MenuItemButton(
                                    child: Text('No links available'),
                                  );
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: snapshot.data!.entries.map((entry) {
                                    IconData icon;
                                    switch (entry.key) {
                                      case 'facebookUrl':
                                        icon = LucideIcons.facebook;
                                        break;
                                      case 'twitterUrl':
                                        icon = LucideIcons.twitter;
                                        break;
                                      case 'instagramUrl':
                                        icon = LucideIcons.instagram;
                                        break;
                                      case 'youtubeUrl':
                                        icon = LucideIcons.youtube;
                                        break;
                                      case 'tiktokUrl':
                                        icon = LucideIcons.video;
                                        break;
                                      case 'telegramUrl':
                                        icon = LucideIcons.send;
                                        break;
                                      case 'whatsappUrl':
                                        icon = LucideIcons.message_circle;
                                        break;
                                      default:
                                        icon = LucideIcons.link;
                                    }
                                    return MenuItemButton(
                                      leadingIcon: Icon(icon, size: 18),
                                      child: Text(entry.key
                                          .replaceAll('Url', '')
                                          .toUpperCase()),
                                      onPressed: () async {
                                        try {
                                          String url = entry.value.trim();
                                          
                                          if (url.isEmpty) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('URL is empty'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                            return;
                                          }
                                          
                                          if (!url.startsWith('http://') && 
                                              !url.startsWith('https://') &&
                                              !url.startsWith('mailto:') &&
                                              !url.startsWith('tel:') &&
                                              !url.startsWith('sms:')) {
                                            url = 'https://$url';
                                          }
                                          
                                          final uri = Uri.parse(url);
                                          
                                          if (!uri.hasScheme) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Invalid URL format'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                            return;
                                          }
                                          
                                          final launched = await launchUrl(
                                            uri,
                                            mode: LaunchMode.platformDefault,
                                          );
                                          
                                          if (!launched && context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Unable to open ${entry.key.replaceAll('Url', '')}'),
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: ${e.toString()}'),
                                                duration: const Duration(seconds: 3),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                          child: const Text('Follow Us'),
                        ),
                      ],
                    ),
                    SizedBox(width: DesignTokens.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'home_header_listener_id'.tr(),
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
                            '${'radio_greeting_hi'.tr()} ${_getGreeting().tr()}',
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
          Align(
            alignment: Alignment.centerRight,
            child: RadioGameTabs(
              selectedIndex: selectedGameTab,
              onChanged: onGameTabChanged,
            ),
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
