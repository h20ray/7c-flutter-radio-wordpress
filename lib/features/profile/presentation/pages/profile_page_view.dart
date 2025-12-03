import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../widgets/profile_app_bar.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  late ScrollController _scrollController;
  NavItem _selectedNavItem = NavItem.profile;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final bottomSpacing = DesignTokens.spacingS;
    final extraSpacing = DesignTokens.spacingXl;
    final totalBottomSpacing =
        FloatingBottomNavBar.totalHeight + bottomSpacing + safeAreaBottom + extraSpacing;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colors.primaryBackground,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              ProfileAppBar(
                onScrollToTop: _scrollToTop,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      _buildPlaceholderSection(),
                      SizedBox(height: totalBottomSpacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: DesignTokens.spacingL,
                  right: DesignTokens.spacingL,
                  bottom: DesignTokens.spacingS,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FloatingBottomNavBar(
                        selectedItem: _selectedNavItem,
                        onItemSelected: (item) {
                          setState(() {
                            _selectedNavItem = item;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: DesignTokens.spacingM),
                    FloatingPlayFab(
                      key: const ValueKey('profile-play-fab'),
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.user,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'profile_placeholder_title'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'profile_placeholder_message'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

