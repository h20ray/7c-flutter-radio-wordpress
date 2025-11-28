import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/widgets/smooth_marquee_text.dart';
import '../../../radio/presentation/bloc/radio_player_bloc.dart';
import '../../../radio/presentation/bloc/radio_player_state.dart';

class HomeStickyPlayer extends StatelessWidget {
  const HomeStickyPlayer({super.key});

  String _displayOrFallback(String? value, String fallback) {
    if (value == null) return fallback;
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        // Extract metadata from state using Dart 3 records
        final (artist, title) = state.maybeWhen(
          ready: (isPlaying, currentUrl, currentArtist, currentTitle,
              currentAlbumArtUrl, isDucking, canAutoResume) =>
              (currentArtist, currentTitle),
          orElse: () => (null, null),
        );

        final theme = Theme.of(context);
        final brightness = theme.brightness;
        final appColors = context.appColors;

        final bgColor = appColors.surfaces.surfaceContainerHigh;
        final textColor = appColors.textPrimary;
        final textSecondaryColor = appColors.textSecondary;

        final statusBarHeight = MediaQuery.of(context).padding.top;
        final statusBarIconBrightness =
            brightness == Brightness.dark ? Brightness.light : Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: statusBarIconBrightness,
            statusBarBrightness: brightness,
          ),
          child: Container(
            height: 64 + statusBarHeight,
            padding: EdgeInsets.only(top: statusBarHeight),
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: AppShadowTokens.elevation8(context),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                _StickyLogo(appColors: appColors, theme: theme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmoothMarqueeAuto(
                        text: _displayOrFallback(title, RadioConfig.fallbackTitle),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        scrollDuration: const Duration(seconds: 10),
                      ),
                      const SizedBox(height: 2),
                      SmoothMarqueeAuto(
                        text: _displayOrFallback(artist, RadioConfig.fallbackArtist),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textSecondaryColor,
                        ),
                        scrollDuration: const Duration(seconds: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StickyLogo extends StatelessWidget {
  final AppSemanticColors appColors;
  final ThemeData theme;

  const _StickyLogo({
    required this.appColors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        RadioConfig.stickyLogoPath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appColors.colorScheme.primary.withValues(alpha: 0.8),
                  appColors.colorScheme.primary.withValues(alpha: 0.4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
