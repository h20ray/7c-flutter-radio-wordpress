import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../models/album_art_state.dart';
import '../../features/radio/data/services/album_art_service.dart';
import '../../config/radio_config.dart';
import '../cache/album_art_image_cache_manager.dart';
import 'app_network_image.dart';

/// Shape options for album art display
enum AlbumArtShape {
  circle,
  roundedRect,
  rectangle,
}

/// Reusable widget for displaying album art
/// Subscribes to AlbumArtService stream and handles all states automatically
class AlbumArtWidget extends StatefulWidget {
  final double width;
  final double height;
  final AlbumArtShape shape;
  final double? borderRadius;
  final FilterQuality filterQuality;
  final BoxFit fit;
  final bool showLoadingIndicator;
  final Color? loadingColor;
  final Duration transitionDuration;

  const AlbumArtWidget({
    super.key,
    required this.width,
    required this.height,
    this.shape = AlbumArtShape.roundedRect,
    this.borderRadius,
    this.filterQuality = FilterQuality.low,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = false,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 1000),
  });

  /// Create a circular album art widget (for FAB)
  const AlbumArtWidget.circle({
    super.key,
    required double size,
    this.filterQuality = FilterQuality.high,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = false,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 1000),
  }) : width = size,
       height = size,
       shape = AlbumArtShape.circle,
       borderRadius = null;

  /// Create a rounded rectangle album art widget (for cards)
  const AlbumArtWidget.roundedRect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.filterQuality = FilterQuality.low,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = false,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 1000),
  }) : shape = AlbumArtShape.roundedRect;

  /// Create a rectangle album art widget (for hero backgrounds)
  const AlbumArtWidget.rectangle({
    super.key,
    required this.width,
    required this.height,
    this.filterQuality = FilterQuality.low,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = false,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 1000),
  }) : shape = AlbumArtShape.rectangle,
       borderRadius = null;

  @override
  State<AlbumArtWidget> createState() => _AlbumArtWidgetState();
}

class _AlbumArtWidgetState extends State<AlbumArtWidget> {
  String? _lastKnownUrl;
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 75);

  @override
  void initState() {
    super.initState();
    final initialState = AlbumArtService.instance.currentState;
    _lastKnownUrl = initialState.hasUrl ? initialState.url : null;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: StreamBuilder<AlbumArtState>(
        stream: AlbumArtService.instance.albumArtStream,
        initialData: AlbumArtService.instance.currentState,
        builder: (context, snapshot) {
          final albumArtState = snapshot.data ?? AlbumArtService.instance.currentState;
          return _buildContentWithState(albumArtState);
        },
      ),
    );
  }

  Widget _buildContentWithState(AlbumArtState albumArtState) {
    final currentUrl = albumArtState.hasUrl ? albumArtState.url : null;
    final urlChanged = currentUrl != null && currentUrl != _lastKnownUrl;
    
    String? effectiveUrl;
    bool useZeroTransition = false;

    if (currentUrl != null) {
      effectiveUrl = currentUrl;
      useZeroTransition = !urlChanged;
      if (urlChanged) {
        _debounceTimer?.cancel();
        _lastKnownUrl = currentUrl;
      }
    } else if (_lastKnownUrl != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounceDuration, () {
        if (mounted) {
          final currentState = AlbumArtService.instance.currentState;
          if (!currentState.hasUrl) {
            setState(() {
              _lastKnownUrl = null;
            });
          }
        }
      });
      effectiveUrl = _lastKnownUrl;
      useZeroTransition = true;
    } else {
      _lastKnownUrl = null;
    }

    final transitionDuration = useZeroTransition ? Duration.zero : widget.transitionDuration;

    return AnimatedSwitcher(
      duration: transitionDuration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: _buildAlbumArt(effectiveUrl, useZeroTransition),
    );
  }

  Widget _buildAlbumArt(String? effectiveUrl, bool useZeroTransition) {
    if (effectiveUrl != null) {
      return _buildNetworkImage(effectiveUrl, useZeroTransition: useZeroTransition);
    }

    return _buildFallbackImage();
  }

  Widget _buildNetworkImage(String url, {bool useZeroTransition = false}) {
    return Container(
      key: ValueKey('network_$url'),
      decoration: _getShapeDecoration(),
      clipBehavior: Clip.antiAlias,
      child: AppNetworkImage(
        imageUrl: url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        filterQuality: widget.filterQuality,
        cacheManager: AlbumArtImageCacheManager(),
        fadeInDuration: useZeroTransition ? Duration.zero : null,
        placeholder: (context, url) {
          if (useZeroTransition && _lastKnownUrl == url) {
            return const SizedBox.shrink();
          }
          return _buildFallbackImage();
        },
        errorWidget: (context, url, error) => _buildFallbackImage(),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      key: const ValueKey('fallback'),
      decoration: _getShapeDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        RadioConfig.fallbackArtworkPath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        filterQuality: widget.filterQuality,
        errorBuilder: (context, error, stackTrace) {
          // Ultimate fallback - gradient with icon
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                ],
              ),
            ),
            child: Icon(
              LucideIcons.music,
              color: Colors.white,
              size: widget.width * 0.4,
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _getShapeDecoration() {
    switch (widget.shape) {
      case AlbumArtShape.circle:
        return BoxDecoration(
          shape: BoxShape.circle,
        );
      case AlbumArtShape.roundedRect:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? widget.width * 0.1,
          ),
        );
      case AlbumArtShape.rectangle:
        return const BoxDecoration();
    }
  }
}

