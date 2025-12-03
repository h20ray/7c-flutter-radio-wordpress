import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../bloc/radio_bloc.dart';
import '../widgets/radio_app_bar.dart';
import '../widgets/radio_banner_section.dart';
import '../widgets/radio_error_state.dart';
import '../widgets/radio_loading_state.dart';
import '../widgets/radio_metadata_section.dart';
import '../widgets/radio_page_background.dart';
import '../widgets/radio_big_album_art.dart';
import '../widgets/radio_song_history_section.dart';
import '../widgets/radio_menu_chips_section.dart';

class RadioPageView extends StatelessWidget {
  const RadioPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        body: Stack(
          children: [
            const RadioPageBackground(),
            BlocBuilder<RadioBloc, RadioState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const RadioLoadingState(),
                  error: (failure) => RadioErrorState(failure: failure),
                  loaded: (radioEntity) {
                    if (!radioEntity.enabled) {
                      return _buildDisabledState();
                    }
                    return const _RadioPageViewContent();
                  },
                  orElse: () => const RadioLoadingState(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.radio, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'radio_disabled_title'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'radio_disabled_message'.tr(),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RadioPageViewContent extends StatefulWidget {
  const _RadioPageViewContent();

  @override
  State<_RadioPageViewContent> createState() => _RadioPageViewContentState();
}

class _RadioPageViewContentState extends State<_RadioPageViewContent> {
  late ScrollController _scrollController;
  NavItem _selectedNavItem = NavItem.radio;

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
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final bottomSpacing = DesignTokens.spacingS;
    final extraSpacing = DesignTokens.spacingXl;
    final totalBottomSpacing = FloatingBottomNavBar.totalHeight + bottomSpacing + safeAreaBottom + extraSpacing;

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            RadioAppBar(
              onScrollToTop: _scrollToTop,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    // Big Album Art
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RadioBigAlbumArt(),
                    ),
                    const SizedBox(height: 20),
                    // Metadata Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RadioMetadataSection(),
                    ),
                    const SizedBox(height: 32),
                    // Subtle divider
                    Builder(
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Menu Chips Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RadioMenuChipsSection(),
                    ),
                    const SizedBox(height: 24),
                    const AspectRatio(
                      aspectRatio: 5 / 4,
                      child: RadioBannerSection(),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RadioSongHistorySection(),
                    ),
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
                    key: const ValueKey('radio-play-fab'),
                    size: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}
