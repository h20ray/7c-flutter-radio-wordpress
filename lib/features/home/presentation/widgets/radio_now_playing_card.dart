import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../config/app_config.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../core/widgets/album_art_widget.dart';
import '../../../../core/widgets/smooth_marquee_text.dart';
import '../../domain/entities/now_playing_entity.dart';
import '../bloc/home_bloc.dart';

class RadioNowPlayingCard extends StatelessWidget {
  final bool skipWrapper;
  final VoidCallback? onTap;

  const RadioNowPlayingCard({
    super.key,
    this.skipWrapper = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final child = BlocSelector<HomeBloc, HomeState, _NowPlayingViewData>(
      selector: (state) {
        return state.maybeWhen(
          loaded: (tabIndex, selectedCategory, nowPlaying, error) =>
              _NowPlayingViewData.fromEntity(nowPlaying),
          orElse: () => _NowPlayingViewData.fallback(),
        );
      },
      builder: (context, viewData) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: _DynamicNowPlayingCard(
            viewData: viewData,
            colors: colors,
            onTap: onTap,
          ),
        );
      },
    );

    final content = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => Navigator.pushNamed(context, AppRoutes.radio),
      child: child,
    );

    if (skipWrapper) {
      return content;
    }

    return Transform.translate(
      offset: Offset(0, -DesignTokens.spacingXl * 1.7),
      child: content,
    );
  }
}

class _DynamicNowPlayingCard extends StatefulWidget {
  final _NowPlayingViewData viewData;
  final AppSemanticColors colors;
  final VoidCallback? onTap;

  const _DynamicNowPlayingCard({
    required this.viewData,
    required this.colors,
    this.onTap,
  });

  @override
  State<_DynamicNowPlayingCard> createState() => _DynamicNowPlayingCardState();
}

class _DynamicNowPlayingCardState extends State<_DynamicNowPlayingCard> {
  static final PaletteService _paletteService = PaletteService();
  PaletteColors? _palette;
  int _paletteRequestId = 0;

  @override
  void initState() {
    super.initState();
    _loadPalette();
  }

  @override
  void didUpdateWidget(covariant _DynamicNowPlayingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewData.albumArtUrl != oldWidget.viewData.albumArtUrl) {
      _loadPalette();
    }
  }

  void _loadPalette() {
    final url = widget.viewData.albumArtUrl;
    if (url == null || url.isEmpty) {
      if (_palette != null) {
        setState(() {
          _palette = null;
        });
      }
      return;
    }

    final cached = _paletteService.getCached(url);
    if (cached != null) {
      if (_palette != cached) {
        setState(() {
          _palette = cached;
        });
      }
      return;
    }

    final requestId = ++_paletteRequestId;
    _paletteService
        .fetchForUrl(url, fallback: widget.colors.cardBackground)
        .then((palette) {
          if (!mounted || requestId != _paletteRequestId) return;
          setState(() {
            _palette = palette;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final hasPalette =
        widget.viewData.albumArtUrl != null &&
        widget.viewData.albumArtUrl!.isNotEmpty &&
        _palette != null;

    final Color cardColor = hasPalette
        ? _harmonizeColor(_palette!.dominant, widget.colors.cardBackground)
        : widget.colors.cardBackground;

    final textColor = hasPalette
        ? (ThemeData.estimateBrightnessForColor(cardColor) == Brightness.dark
              ? Colors.white
              : Colors.black87)
        : widget.colors.textPrimary;
    final subtitleColor = hasPalette
        ? textColor.withValues(alpha: 0.8)
        : widget.colors.textSecondary;
    final indicatorColor = hasPalette
        ? textColor.withValues(alpha: 0.9)
        : widget.colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        onTap: widget.onTap ??
            () => Navigator.pushNamed(context, AppRoutes.radio),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(DesignTokens.spacingM),
          constraints: const BoxConstraints(minHeight: 68),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AlbumArt(size: 68),
              SizedBox(width: DesignTokens.spacingL),
              Expanded(
                child: _MetadataSection(
                  title: widget.viewData.title,
                  artist: widget.viewData.artist,
                  isPlaying: widget.viewData.isPlaying,
                  titleColor: textColor,
                  subtitleColor: subtitleColor,
                  indicatorColor: indicatorColor,
                ),
              ),
              SizedBox(width: DesignTokens.spacingS),
              Icon(
                LucideIcons.chevron_right,
                size: 20,
                color: textColor.withValues(alpha: 0.75),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _harmonizeColor(Color source, Color fallbackSurface) {
    final hsl = HSLColor.fromColor(source);
    final double targetLightness =
        ThemeData.estimateBrightnessForColor(source) == Brightness.dark
        ? 0.25
        : 0.92;
    final harmonized = hsl.withLightness(targetLightness.clamp(0.0, 1.0));
    final Color toned = harmonized.toColor();
    return toned.withValues(alpha: 1.0);
  }
}

class _AlbumArt extends StatelessWidget {
  final double size;

  const _AlbumArt({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AlbumArtWidget.roundedRect(
            width: size,
            height: size,
            borderRadius: 12,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _MetadataSection extends StatelessWidget {
  final String title;
  final String artist;
  final bool isPlaying;
  final Color titleColor;
  final Color subtitleColor;
  final Color indicatorColor;

  const _MetadataSection({
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.titleColor,
    required this.subtitleColor,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedTitle = title.trim().isNotEmpty
        ? title.trim()
        : RadioConfig.fallbackTitle;
    final normalizedArtist = artist.trim().isNotEmpty
        ? artist.trim()
        : RadioConfig.fallbackArtist;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _LiveIndicator(
          isActive: isPlaying,
          textColor: indicatorColor,
          indicatorColor: indicatorColor,
        ),
        SizedBox(height: 2),
        Flexible(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: SmoothMarqueeAuto(
              text: normalizedTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              scrollDuration: const Duration(seconds: 12),
              pauseDuration: const Duration(seconds: 3),
            ),
          ),
        ),
        SizedBox(height: 2),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SmoothMarqueeAuto(
            text: normalizedArtist,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
            scrollDuration: const Duration(seconds: 10),
            pauseDuration: const Duration(seconds: 3),
          ),
        ),
      ],
    );
  }
}

class _LiveIndicator extends StatefulWidget {
  final bool isActive;
  final Color textColor;
  final Color indicatorColor;

  const _LiveIndicator({
    required this.isActive,
    this.textColor = Colors.white,
    this.indicatorColor = Colors.white,
  });

  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _breathing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _breathing = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _LiveIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isActive
        ? Colors.greenAccent
        : widget.indicatorColor.withValues(alpha: 0.4);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _breathing,
          builder: (context, child) {
            final scale = widget.isActive ? 0.9 + _breathing.value * 0.25 : 1.0;
            final glowOpacity = widget.isActive
                ? 0.3 + _breathing.value * 0.4
                : 0.0;
            return Container(
              width: 12,
              height: 12,
              alignment: Alignment.center,
              child: Container(
                width: 8 * scale,
                height: 8 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: baseColor.withValues(alpha: glowOpacity),
                            blurRadius: 12 * scale,
                            spreadRadius: 1.5 * scale,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          },
        ),
        SizedBox(width: DesignTokens.spacingS),
        Text(
          AppConfig.appName,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: widget.textColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _NowPlayingViewData extends Equatable {
  final String title;
  final String artist;
  final bool isPlaying;
  final String? albumArtUrl;

  const _NowPlayingViewData({
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.albumArtUrl,
  });

  factory _NowPlayingViewData.fromEntity(NowPlayingEntity entity) {
    return _NowPlayingViewData(
      title: entity.title,
      artist: entity.artist,
      isPlaying: entity.isPlaying,
      albumArtUrl: entity.albumArtUrl,
    );
  }

  factory _NowPlayingViewData.fallback() {
    return _NowPlayingViewData(
      title: RadioConfig.fallbackTitle,
      artist: RadioConfig.fallbackArtist,
      isPlaying: false,
      albumArtUrl: null,
    );
  }

  @override
  List<Object?> get props => [title, artist, isPlaying, albumArtUrl];
}
