import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/radio_bloc.dart';
import '../widgets/radio_hero_section.dart';
import '../widgets/radio_now_playing_card.dart';
import '../widgets/radio_banner_section.dart';
import '../widgets/radio_player_controls.dart';
import '../widgets/radio_error_state.dart';
import '../widgets/radio_loading_state.dart';

/// Main view widget for the Radio Page
/// Orchestrates the layout and handles state management
class RadioPageView extends StatelessWidget {
  const RadioPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RadioPlayerControls(),
      body: BlocBuilder<RadioBloc, RadioState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const RadioLoadingState(),
            error: (failure) => RadioErrorState(failure: failure),
            loaded: (radioEntity) {
              if (!radioEntity.enabled) {
                return _buildDisabledState();
              }
              return const _RadioContentLayout();
            },
            orElse: () => const RadioLoadingState(),
          );
        },
      ),
    );
  }

  Widget _buildDisabledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.radio_button_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'radio_disabled_title'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'radio_disabled_message'.tr(),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Main content layout with hero section, now playing card, and banners
class _RadioContentLayout extends StatelessWidget {
  const _RadioContentLayout();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double heroHeight = (constraints.maxHeight * 0.35).clamp(220.0, 320.0);
          final double screenH = constraints.maxHeight;
          final bool isSmall = screenH < 720;
          final bool isLarge = screenH > 840;

          final double cardArtSize = isSmall ? 68 : 92;
          final double cardPadding = 8;
          final double cardHeight = cardArtSize + (cardPadding * 2);
          final double cardOverlap = cardHeight * 0.25;

          return Stack(
            children: [
              RadioHeroSection(
                height: heroHeight,
                scale: 1.5,
                cardOverlap: cardOverlap,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FractionalTranslation(
                      translation: const Offset(0, -0.25),
                      child: const RadioNowPlayingCard(),
                    ),
                    SizedBox(height: isSmall ? 16 : (isLarge ? 24 : 20)),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 5 / 4,
                          child: const RadioBannerSection(),
                        ),
                      ),
                    ),
                    SizedBox(height: ((isSmall ? 20 : (isLarge ? 28 : 24)).clamp(12.0, 24.0)).toDouble()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

