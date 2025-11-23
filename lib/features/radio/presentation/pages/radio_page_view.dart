import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../bloc/radio_bloc.dart';
import '../widgets/radio_hero_section.dart';
import '../widgets/radio_now_playing_card.dart';
import '../widgets/radio_banner_section.dart';
import '../widgets/radio_player_controls.dart';
import '../widgets/radio_error_state.dart';
import '../widgets/radio_loading_state.dart';

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
              return const _RadioHeroLayout();
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

class _RadioHeroLayout extends StatefulWidget {
  const _RadioHeroLayout();

  @override
  State<_RadioHeroLayout> createState() => _RadioHeroLayoutState();
}

class _RadioHeroLayoutState extends State<_RadioHeroLayout> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar.large(
              expandedHeight: 120,
              collapsedHeight: 64,
              pinned: true,
              stretch: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 8,
                  top: 8,
                  bottom: 8,
                ),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/others/horizontal_logo_dark.png'
                      : 'assets/others/horizontal_logo_light.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
              ),
              leadingWidth: 140,
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to notifications page
                  },
                  icon: const Icon(LucideIcons.bell, size: 20),
                  tooltip: 'Notifications',
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    if (isDark) {
                      AdaptiveTheme.of(context).setLight();
                    } else {
                      AdaptiveTheme.of(context).setDark();
                    }
                  },
                  icon: Builder(
                    builder: (context) {
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return Icon(
                        isDark
                            ? LucideIcons.sun
                            : LucideIcons.moon,
                        size: 20,
                      );
                    },
                  ),
                  tooltip: 'Switch Theme',
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    onPressed: () => _showInfoDialog(context),
                    icon: const Icon(LucideIcons.info, size: 20),
                    tooltip: 'Info',
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [],
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 12,
                  bottom: 28,
                ),
                centerTitle: false,
                expandedTitleScale: 1.3,
                background: const RadioHeroSection(
                  height: 120,
                  scale: 1.0,
                  cardOverlap: 0,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    buildGreeting(context),
                    const SizedBox(height: 12),
                    const AspectRatio(
                      aspectRatio: 5 / 4,
                      child: RadioBannerSection(),
                    ),
                    const SizedBox(height: 16),
                    _PlaceholderScrollContent(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 80,
          child: const RadioNowPlayingCard(compact: false),
        ),
      ],
    );
  }

  Widget buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greetingKey;
    if (hour >= 4 && hour < 11) {
      greetingKey = 'greeting_morning';
    } else if (hour >= 11 && hour < 15) {
      greetingKey = 'greeting_midday';
    } else if (hour >= 15 && hour < 18) {
      greetingKey = 'greeting_evening';
    } else {
      greetingKey = 'greeting_night';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: 'radio_greeting_hi'.tr()),
              TextSpan(
                text: ' pendegar ${'radio_station_name'.tr()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          greetingKey.tr(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.info,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'radio_info_dialog_title'.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(LucideIcons.x),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'radio_info_dialog_heading'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'radio_info_dialog_welcome'.tr(
                  namedArgs: {'radio_station_name': 'radio_station_name'.tr()},
                ),
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                'radio_info_details_title'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _InfoRow(
                label: 'radio_info_frequency_label'.tr(),
                value: 'radio_info_frequency_value'.tr(),
              ),
              _InfoRow(
                label: 'radio_info_location_label'.tr(),
                value: 'radio_info_location_value'.tr(),
              ),
              _InfoRow(
                label: 'radio_info_website_label'.tr(),
                value: 'radio_info_website_value'.tr(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('close'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _PlaceholderScrollContent extends StatelessWidget {
  const _PlaceholderScrollContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Placeholder Content',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          10,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 150,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 80,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
