import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../bloc/home_bloc.dart';
import '../widgets/header_section.dart';
import '../widgets/top_status_card.dart';
import '../widgets/mode_tabs.dart';
import '../widgets/featured_radio_section.dart';
import '../widgets/latest_news_carousel.dart';
import '../widgets/local_promos_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  NavItem _selectedNavItem = NavItem.home;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadFeaturedContentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.colorPrimaryBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const HeaderSection(),
                    const TopStatusCard(),
                    SizedBox(height: DesignTokens.spacingXl),
                    ModeTabs(
                      selectedIndex: _selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                        context.read<HomeBloc>().add(TabChangedEvent(index));
                      },
                    ),
                    SizedBox(height: DesignTokens.spacingXl),
                    if (_selectedTabIndex == 0) ...[
                      const FeaturedRadioSection(),
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
              child: FloatingBottomNavBar(
                selectedItem: _selectedNavItem,
                onItemSelected: (item) {
                  setState(() {
                    _selectedNavItem = item;
                  });
                },
              ),
            ),
          ),
          const FloatingPlayFab(),
        ],
      ),
    );
  }
}

