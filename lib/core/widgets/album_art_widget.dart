import 'package:flutter/material.dart';
import '../models/album_art_state.dart';
import '../../features/radio/data/services/album_art_service.dart';
import '../../config/radio_config.dart';

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
    this.showLoadingIndicator = true,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  /// Create a circular album art widget (for FAB)
  const AlbumArtWidget.circle({
    super.key,
    required double size,
    this.filterQuality = FilterQuality.high,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = true,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 500),
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
    this.showLoadingIndicator = true,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : shape = AlbumArtShape.roundedRect;

  /// Create a rectangle album art widget (for hero backgrounds)
  const AlbumArtWidget.rectangle({
    super.key,
    required this.width,
    required this.height,
    this.filterQuality = FilterQuality.low,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = true,
    this.loadingColor,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : shape = AlbumArtShape.rectangle,
       borderRadius = null;

  @override
  State<AlbumArtWidget> createState() => _AlbumArtWidgetState();
}

class _AlbumArtWidgetState extends State<AlbumArtWidget> {
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
    return AnimatedSwitcher(
      duration: widget.transitionDuration,
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
      child: _buildAlbumArt(albumArtState),
    );
  }

  Widget _buildAlbumArt(AlbumArtState albumArtState) {
    if (albumArtState.isLoading && widget.showLoadingIndicator) {
      return _buildLoadingState();
    }

    if (albumArtState.hasUrl) {
      return _buildNetworkImage(albumArtState.url!);
    }

    return _buildFallbackImage();
  }

  Widget _buildLoadingState() {
    return Container(
      key: const ValueKey('loading'),
      decoration: _getShapeDecoration(),
      child: Center(
        child: SizedBox(
          width: widget.width * 0.3,
          height: widget.height * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.loadingColor ?? Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return Container(
      key: ValueKey('network_$url'),
      decoration: _getShapeDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        filterQuality: widget.filterQuality,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          // Show loading indicator while image loads
          if (widget.showLoadingIndicator) {
            return Stack(
              fit: StackFit.expand,
              children: [
                _buildFallbackImage(),
                Center(
                  child: SizedBox(
                    width: widget.width * 0.3,
                    height: widget.height * 0.3,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.loadingColor ?? Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return child;
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
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
              Icons.music_note,
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

