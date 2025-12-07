import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../config/radio_config.dart';
import '../../../../config/share_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../core/services/image_capture_service.dart';
import '../../../../core/services/greeting_service.dart';
import '../../../../core/constants/share_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../data/repositories/greeting_repository.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';
import 'radio_quote_share_card.dart';
import 'radio_share_card.dart';

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
          SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: menuChips
                    .expand(
                      (chip) => [chip, SizedBox(width: DesignTokens.spacingS)],
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
    final tokens = ModeTabsTokens.of(context);
    final theme = Theme.of(context);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingS,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: tokens.unselectedBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
          border: Border.all(
            color: tokens.unselectedText.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: tokens.unselectedText),
            SizedBox(width: DesignTokens.spacingXs),
            Text(
              label.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: tokens.unselectedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingChip extends StatefulWidget {
  const _GreetingChip();

  @override
  State<_GreetingChip> createState() => _GreetingChipState();
}

class _GreetingChipState extends State<_GreetingChip> {
  final GlobalKey _shareCardKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  final GreetingRepository _greetingRepository = getIt<GreetingRepository>();
  bool _isLoading = false;

  Future<void> _captureAndShareQuote(String quote, String? albumArtUrl) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final pixelRatio = _imageCaptureService.getOptimalPixelRatio(context);
      await _imageCaptureService.captureAndShare(
        key: _shareCardKey,
        text: quote,
        subject: 'Daily Quote',
        pixelRatio: pixelRatio,
      );
    } catch (e) {
      debugPrint('Error capturing quote share card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('radio_unknown_error'.tr()),
            duration: const Duration(seconds: ShareConstants.snackBarDurationSeconds),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _getAlbumArtUrl() {
    try {
      final radioPlayerBloc = context.read<RadioPlayerBloc>();
      final radioState = radioPlayerBloc.state;
      String? albumArtUrl;
      radioState.maybeWhen(
        ready: (
          isPlaying,
          currentUrl,
          currentArtist,
          currentTitle,
          currentAlbumArtUrl,
          isDucking,
          canAutoResume,
        ) {
          albumArtUrl = currentAlbumArtUrl;
        },
        orElse: () {},
      );
      return albumArtUrl;
    } catch (e) {
      debugPrint('Error accessing RadioPlayerBloc: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greetingKey = GreetingService.getGreetingKey();
    final chipColor = GreetingService.getGreetingColor(context, greetingKey);
    final textColor = GreetingService.getGreetingTextColor(context, greetingKey);
    final borderColor = textColor.withValues(alpha: 0.15);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: () async {
        if (_isLoading) return;

        setState(() => _isLoading = true);
        final quote = await _greetingRepository.getDailyQuote(
          greetingKey,
          context.locale.languageCode,
        );

        if (!mounted) return;

        setState(() => _isLoading = false);

        if (!mounted) return;

        final albumArtUrl = _getAlbumArtUrl();
        final displayQuote = quote.isNotEmpty ? quote : 'Have a wonderful day!';

        if (!mounted) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final dialogContext = context;
          final dialogTheme = Theme.of(context);
          showDialog(
            context: dialogContext,
            builder: (builderContext) => Stack(
              children: [
                Transform.translate(
                  offset: const Offset(-10000, -10000),
                  child: RepaintBoundary(
                    key: _shareCardKey,
                    child: RadioQuoteShareCard(
                      quote: displayQuote,
                      albumArtUrl: albumArtUrl,
                    ),
                  ),
                ),
                Dialog(
                  backgroundColor: dialogTheme.colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(DesignTokens.spacingL),
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            LucideIcons.quote,
                            size: 32,
                            color: dialogTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingM),
                        Text(
                          displayQuote,
                          style: dialogTheme.textTheme.headlineSmall?.copyWith(
                            height: 1.3,
                            color: dialogTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      await _captureAndShareQuote(
                                        displayQuote,
                                        albumArtUrl,
                                      );
                                    },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacingM,
                                  vertical: DesignTokens.spacingS,
                                ),
                              ),
                              icon: Icon(
                                LucideIcons.share_2,
                                size: 18,
                                color: dialogTheme.colorScheme.primary,
                              ),
                              label: Text(
                                'Share',
                                style: dialogTheme.textTheme.labelLarge?.copyWith(
                                  color: dialogTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: DesignTokens.spacingS),
                            TextButton(
                              onPressed: () => Navigator.pop(builderContext),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacingM,
                                  vertical: DesignTokens.spacingS,
                                ),
                              ),
                              child: Text(
                                'Close',
                                style: dialogTheme.textTheme.labelLarge?.copyWith(
                                  color: dialogTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingS,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
          border: Border.all(color: borderColor, width: 1),
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

class _ShareChip extends StatefulWidget {
  const _ShareChip();

  @override
  State<_ShareChip> createState() => _ShareChipState();
}

class _ShareChipState extends State<_ShareChip> {
  final GlobalKey _previewCardKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  final PaletteService _paletteService = getIt<PaletteService>();
  bool _isLoading = false;
  bool _isCapturing = false;

  Future<void> _captureAndShare({
    required String? artist,
    required String? title,
    required String? albumArtUrl,
    required PaletteColors? palette,
    required bool isPlaying,
    required BuildContext dialogContext,
  }) async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final pixelRatio = _imageCaptureService.getOptimalPixelRatio(context);
      final shareText = title != null && title.trim().isNotEmpty
          ? '$title${artist != null && artist.trim().isNotEmpty ? ' - $artist' : ''}'
          : 'Now Playing on ${ShareConfig.appNameFull}';

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      await _imageCaptureService.captureAndShare(
        key: _previewCardKey,
        text: shareText,
        subject: 'Now Playing',
        pixelRatio: pixelRatio,
        initialDelayMs: ShareConstants.initialCaptureDelayMs,
        finalDelayMs: ShareConstants.finalCaptureDelayMs,
        maxWaitAttempts: ShareConstants.maxPaintWaitAttempts,
        waitDelayMs: ShareConstants.paintWaitDelayMs,
      );
    } catch (e) {
      debugPrint('Error capturing radio share card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('radio_unknown_error'.tr()),
            duration: const Duration(seconds: ShareConstants.snackBarDurationSeconds),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<PaletteColors?> _getPalette(String? albumArtUrl) async {
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

  ({
    String? artist,
    String? title,
    String? albumArtUrl,
    bool isPlaying,
  })? _getRadioState() {
    try {
      final radioPlayerBloc = context.read<RadioPlayerBloc>();
      final radioState = radioPlayerBloc.state;
      String? artist;
      String? title;
      String? albumArtUrl;
      bool isPlaying = false;

      radioState.maybeWhen(
        ready: (
          playing,
          currentUrl,
          currentArtist,
          currentTitle,
          currentAlbumArtUrl,
          isDucking,
          canAutoResume,
        ) {
          artist = currentArtist;
          title = currentTitle;
          albumArtUrl = currentAlbumArtUrl;
          isPlaying = playing;
        },
        orElse: () {},
      );

      return (
        artist: artist,
        title: title,
        albumArtUrl: albumArtUrl,
        isPlaying: isPlaying,
      );
    } catch (e) {
      debugPrint('Error accessing RadioPlayerBloc: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ModeTabsTokens.of(context);
    final theme = Theme.of(context);

    return HapticGestureDetector(
      hapticType: HapticFeedbackType.selectionClick,
      onTap: () async {
        if (_isLoading || _isCapturing) return;

        setState(() => _isLoading = true);

        final radioState = _getRadioState();
        if (radioState == null) {
          setState(() => _isLoading = false);
          return;
        }

        final palette = await _getPalette(radioState.albumArtUrl);

        if (!mounted) return;

        setState(() => _isLoading = false);

        if (!mounted) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final dialogContext = context;
          final dialogTheme = Theme.of(context);
          final mediaQuery = MediaQuery.of(context);
          showDialog(
            context: dialogContext,
            builder: (builderContext) => Dialog(
              backgroundColor: dialogTheme.colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                padding: EdgeInsets.all(DesignTokens.spacingL),
                constraints: BoxConstraints(
                  maxWidth: mediaQuery.size.width * 0.9,
                  maxHeight: mediaQuery.size.height * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 500),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: dialogTheme.colorScheme.surfaceContainerHigh,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: RepaintBoundary(
                            key: _previewCardKey,
                            child: RadioShareCard(
                              artist: radioState.artist,
                              title: radioState.title,
                              albumArtUrl: radioState.albumArtUrl,
                              palette: palette,
                              isPlaying: radioState.isPlaying,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(builderContext),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingM,
                              vertical: DesignTokens.spacingS,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: dialogTheme.textTheme.labelLarge?.copyWith(
                              color: dialogTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(width: DesignTokens.spacingS),
                        FilledButton(
                          onPressed: _isCapturing
                              ? null
                              : () async {
                                  await _captureAndShare(
                                    artist: radioState.artist,
                                    title: radioState.title,
                                    albumArtUrl: radioState.albumArtUrl,
                                    palette: palette,
                                    isPlaying: radioState.isPlaying,
                                    dialogContext: builderContext,
                                  );
                                },
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingM,
                              vertical: DesignTokens.spacingS,
                            ),
                          ),
                          child: _isCapturing
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      dialogTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingS,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: tokens.unselectedBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
          border: Border.all(
            color: tokens.unselectedText.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.share_2, size: 16, color: tokens.unselectedText),
            SizedBox(width: DesignTokens.spacingXs),
            Text(
              'Share',
              style: theme.textTheme.labelSmall?.copyWith(
                color: tokens.unselectedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
