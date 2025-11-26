import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../bloc/home_bloc.dart';
import '../widgets/header_section.dart';
import '../widgets/swipeable_card_container.dart';
import '../widgets/mode_tabs.dart';
import '../widgets/latest_news_carousel.dart';
import '../widgets/local_promos_section.dart';
import '../../../tamtama/presentation/widgets/tamtama_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  int _selectedRadioGameTab = 0;
  NavItem _selectedNavItem = NavItem.home;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadFeaturedContentEvent());
  }

  Future<bool> _onWillPop() async {
    final result = await ConfirmationDialog.show(
      context: context,
      titleKey: 'dialog_exit_title',
      messageKey: 'dialog_exit_message',
      confirmTextKey: 'dialog_exit_confirm',
      cancelTextKey: 'dialog_cancel',
      icon: LucideIcons.log_out,
      iconColor: Theme.of(context).colorScheme.error,
    );

    if (result == true) {
      exit(0);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: context.appColors.primaryBackground,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        HeaderSection(
                          selectedGameTab: _selectedRadioGameTab,
                          onGameTabChanged: (index) {
                            if (_selectedRadioGameTab == index) {
                              return;
                            }
                            setState(() {
                              _selectedRadioGameTab = index;
                            });
                          },
                        ),
                        SwipeableCardContainer(
                          selectedIndex: _selectedRadioGameTab,
                          onIndexChanged: (index) {
                            setState(() {
                              _selectedRadioGameTab = index;
                            });
                          },
                        ),
                        SizedBox(height: DesignTokens.spacingM),
                        ModeTabs(
                          selectedIndex: _selectedTabIndex,
                          onTabChanged: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                            context.read<HomeBloc>().add(
                              TabChangedEvent(index),
                            );
                          },
                        ),
                        SizedBox(height: DesignTokens.spacingM),
                        if (_selectedTabIndex == 0) ...[
                          const TamtamaSection(),
                          SizedBox(height: DesignTokens.spacingXl),
                        ],
                        const LatestNewsCarousel(),
                        SizedBox(height: DesignTokens.spacingXl),
                        LocalPromosSection(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                            context.read<HomeBloc>().add(
                              FilterChipSelectedEvent(category),
                            );
                          },
                        ),
                        SizedBox(height: 120),
                      ],
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
                          key: const ValueKey('home-play-fab'),
                          size: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
