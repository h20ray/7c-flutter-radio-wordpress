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
import '../../../tamtama/presentation/widgets/tamtama_section.dart';
import '../bloc/home_bloc.dart';
import '../widgets/header_section.dart';
import '../widgets/latest_news_carousel.dart';
import '../widgets/home_news_list_section.dart';
import '../widgets/mode_tabs.dart';
import '../widgets/swipeable_card_container.dart';
import '../widgets/home_sticky_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  int _selectedRadioGameTab = 0;
  NavItem _selectedNavItem = NavItem.home;

  late ScrollController _scrollController;
  bool _showStickyPlayer = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<HomeBloc>().add(const LoadFeaturedContentEvent());
    context.read<HomeBloc>().add(const LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky player when scrolled past the header stack height (approx)
    // The header stack height is calculated in build, but we can estimate or use a fixed threshold.
    // The main player card is at the top. Let's say 250px.
    if (_scrollController.offset > 280 && !_showStickyPlayer) {
      setState(() {
        _showStickyPlayer = true;
      });
    } else if (_scrollController.offset <= 280 && _showStickyPlayer) {
      setState(() {
        _showStickyPlayer = false;
      });
    }
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const double cardOverlap = DesignTokens.spacingXl * 1.7;
    final double headerHeight = 180 + statusBarHeight;
    final double headerStackHeight =
        headerHeight + (DesignTokens.cardHeightStandard - cardOverlap);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PrimaryScrollController(
          controller: _scrollController,
          child: Scaffold(
            backgroundColor: context.appColors.primaryBackground,
            body: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: headerStackHeight,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              height: headerHeight,
                              child: HeaderSection(
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
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: headerHeight - cardOverlap,
                              child: SwipeableCardContainer(
                                selectedIndex: _selectedRadioGameTab,
                                onIndexChanged: (index) {
                                  setState(() {
                                    _selectedRadioGameTab = index;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    if (_selectedTabIndex == 0)
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const TamtamaSection(),
                            SizedBox(height: DesignTokens.spacingXl),
                          ],
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: LatestNewsCarousel(),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: DesignTokens.spacingXl),
                    ),
                    const SliverToBoxAdapter(
                      child: HomeNewsListSection(),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: DesignTokens.spacingXl),
                          SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    offset: _showStickyPlayer
                        ? Offset.zero
                        : const Offset(0, -1),
                    child: TickerMode(
                      enabled: _showStickyPlayer,
                      child: const RepaintBoundary(
                        child: HomeStickyPlayer(),
                      ),
                    ),
                  ),
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
      ),
    );
  }
}
