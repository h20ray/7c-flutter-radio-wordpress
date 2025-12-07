import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../config/radio_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/action_chip_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../core/services/greeting_service.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/mixins/radio_state_accessor_mixin.dart';
import '../../data/repositories/greeting_repository.dart';
import 'dialogs/radio_now_playing_share_dialog.dart';
import 'dialogs/radio_quote_dialog.dart';

/// Radio action buttons widget displaying a horizontally scrollable
/// row of action chips for quick access to radio features.
///
/// Contains:
/// - Greeting chip (time-based greeting with daily quote)
/// - Share chip (now playing share with Instagram mode)
/// - Optional menu chips (Lyrics, Request, About, Song History)
class RadioActionButtons extends StatelessWidget {
  const RadioActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final menuChips = <Widget>[];

    menuChips.add(const _ShareChip());

    if (RadioConfig.showLyrics) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.music,
          label: 'radio_menu_lyrics',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.lyrics);
          },
        ),
      );
    }

    if (RadioConfig.showRequest) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.send,
          label: 'radio_menu_request',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.request);
          },
        ),
      );
    }

    if (RadioConfig.showAbout) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.info,
          label: 'radio_menu_about',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.radioAbout);
          },
        ),
      );
    }

    if (RadioConfig.showSongHistory) {
      menuChips.add(
        _MenuChip(
          icon: LucideIcons.history,
          label: 'radio_menu_song_history',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.songHistory);
          },
        ),
      );
    }

    return Row(
      children: [
        const _GreetingChip(),
        if (menuChips.isNotEmpty) ...[
          const SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: menuChips
                    .expand(
                      (chip) =>
                          [chip, const SizedBox(width: DesignTokens.spacingS)],
                    )
                    .take(menuChips.length * 2 - 1)
                    .toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Generic action chip for menu items.
///
/// Uses [ActionChipTokens] for consistent styling.
class _MenuChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ActionChipTokens.of(context);
    final theme = Theme.of(context);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: onTap,
      child: Container(
        padding: tokens.padding,
        decoration: BoxDecoration(
          color: tokens.background,
          borderRadius: BorderRadius.circular(tokens.cornerRadius),
          border: Border.all(
            color: tokens.border,
            width: DimensionTokens.borderWidthThin,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: tokens.iconSize, color: tokens.icon),
            SizedBox(width: tokens.spacing),
            Text(
              label.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: tokens.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Greeting chip displaying time-based greeting.
///
/// When tapped, shows a dialog with a daily quote and share options.
class _GreetingChip extends StatefulWidget {
  const _GreetingChip();

  @override
  State<_GreetingChip> createState() => _GreetingChipState();
}

class _GreetingChipState extends State<_GreetingChip>
    with RadioStateAccessorMixin {
  final GreetingRepository _greetingRepository = getIt<GreetingRepository>();
  bool _isTapped = false;

  Future<void> _handleTap() async {
    if (_isTapped) return;
    _isTapped = true;

    try {
      final greetingKey = GreetingService.getGreetingKey();
      final quote = await _greetingRepository.getDailyQuote(
        greetingKey,
        context.locale.languageCode,
      );

      if (!mounted) return;

      final albumArtUrl = currentAlbumArtUrl;
      final displayQuote =
          quote.isNotEmpty ? quote : 'quote_default_message'.tr();

      if (!mounted) return;

      await RadioQuoteDialog.show(
        context: context,
        quote: displayQuote,
        albumArtUrl: albumArtUrl,
      );
    } finally {
      _isTapped = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greetingKey = GreetingService.getGreetingKey();
    final chipColor = GreetingService.getGreetingColor(context, greetingKey);
    final textColor =
        GreetingService.getGreetingTextColor(context, greetingKey);
    final borderColor = textColor.withValues(alpha: 0.15);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingS,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
          border: Border.all(
            color: borderColor,
            width: DimensionTokens.borderWidthThin,
          ),
        ),
        child: Text(
          greetingKey.tr(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: textColor,
            letterSpacing: DesignTokens.letterSpacingLabelSmall,
          ),
        ),
      ),
    );
  }
}

/// Share chip for sharing currently playing track.
///
/// When tapped, shows a dialog with preview and Instagram mode toggle.
class _ShareChip extends StatefulWidget {
  const _ShareChip();

  @override
  State<_ShareChip> createState() => _ShareChipState();
}

class _ShareChipState extends State<_ShareChip> with RadioStateAccessorMixin {
  final PaletteService _paletteService = getIt<PaletteService>();
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final radioState = getRadioState();
      if (radioState == null) {
        setState(() => _isLoading = false);
        return;
      }

      final palette = await _getPalette(radioState.albumArtUrl);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (!mounted) return;

      await RadioNowPlayingShareDialog.show(
        context: context,
        artist: radioState.artist,
        title: radioState.title,
        albumArtUrl: radioState.albumArtUrl,
        palette: palette,
        isPlaying: radioState.isPlaying,
      );
    } catch (e) {
      debugPrint('Error opening share dialog: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<dynamic> _getPalette(String? albumArtUrl) async {
    if (albumArtUrl == null || albumArtUrl.isEmpty) {
      return null;
    }
    try {
      return await _paletteService.fetchForUrl(albumArtUrl);
    } catch (e) {
      debugPrint('Error fetching palette: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ActionChipTokens.of(context);
    final theme = Theme.of(context);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: DesignTokens.animationDurationShort,
        padding: tokens.padding,
        decoration: BoxDecoration(
          color: tokens.background,
          borderRadius: BorderRadius.circular(tokens.cornerRadius),
          border: Border.all(
            color: tokens.border,
            width: DimensionTokens.borderWidthThin,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              SizedBox(
                width: tokens.iconSize,
                height: tokens.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    tokens.loadingIndicator,
                  ),
                ),
              )
            else
              Icon(LucideIcons.share_2, size: tokens.iconSize, color: tokens.icon),
            SizedBox(width: tokens.spacing),
            Text(
              'share_action'.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: tokens.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
