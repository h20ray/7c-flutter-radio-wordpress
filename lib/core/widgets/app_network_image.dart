import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import '../cache/image_cache_manager.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final ImageWidgetBuilder? imageBuilder;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final FilterQuality filterQuality;
  final Duration? fadeInDuration;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.imageBuilder,
    this.memCacheWidth,
    this.memCacheHeight,
    this.filterQuality = FilterQuality.low,
    this.fadeInDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget(context, 'Empty URL');
    }

    final isAvif = imageUrl.toLowerCase().endsWith('.avif');

    if (isAvif) {
      return _AvifCachedImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: placeholder,
        errorWidget: errorWidget,
        imageBuilder: imageBuilder,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        filterQuality: filterQuality,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      filterQuality: filterQuality,
      placeholder: placeholder,
      errorWidget: errorWidget,
      imageBuilder: imageBuilder,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      cacheKey: imageUrl,
    );
  }

  Widget _buildErrorWidget(BuildContext context, dynamic error) {
    if (errorWidget != null) {
      return errorWidget!(context, imageUrl, error);
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.error),
    );
  }
}

class _AvifCachedImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final ImageWidgetBuilder? imageBuilder;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final FilterQuality filterQuality;

  const _AvifCachedImage({
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.imageBuilder,
    this.memCacheWidth,
    this.memCacheHeight,
    this.filterQuality = FilterQuality.low,
  });

  @override
  State<_AvifCachedImage> createState() => _AvifCachedImageState();
}

class _AvifCachedImageState extends State<_AvifCachedImage> {
  final _cacheManager = ImageCacheManager();
  String? _currentUrl;
  int _fallbackIndex = 0;
  bool _avifDecodeFailed = false;

  static const List<String> _fallbackExtensions = ['.jpg', '.png', '.webp'];

  String _getFallbackUrl(String originalUrl, int index) {
    if (index == 0) return originalUrl;
    if (index > _fallbackExtensions.length) return originalUrl;

    final extension = _fallbackExtensions[index - 1];
    return originalUrl.replaceAll(RegExp(r'\.avif$', caseSensitive: false), extension);
  }

  bool _isAvifUrl(String url) {
    return url.toLowerCase().endsWith('.avif');
  }

  Future<File?> _loadCachedFile(String url) async {
    try {
      return await _cacheManager.getCachedFile(url);
    } catch (e) {
      return null;
    }
  }

  Widget _buildAvifImageFromFile(File file) {
    final avifWidget = AvifImage.file(
      file,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: (context, error, stackTrace) {
        if (!_avifDecodeFailed && _fallbackIndex < _fallbackExtensions.length) {
          _avifDecodeFailed = true;
          WidgetsBinding.instance.addPostFrameCallback((duration) {
            if (mounted) {
              setState(() {
                _fallbackIndex++;
                _currentUrl = _getFallbackUrl(widget.imageUrl, _fallbackIndex);
                _avifDecodeFailed = false;
              });
            }
          });
          return widget.placeholder?.call(context, _currentUrl!) ??
              const SizedBox.shrink();
        }
        return _buildErrorWidget(error);
      },
    );

    if (widget.imageBuilder != null) {
      final fileImage = FileImage(file);
      return widget.imageBuilder!(context, fileImage);
    }

    return avifWidget;
  }

  Widget _buildErrorWidget(dynamic error) {
    if (widget.errorWidget != null) {
      return widget.errorWidget!(context, widget.imageUrl, error);
    }
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: const Icon(Icons.error),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(_AvifCachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      _currentUrl = widget.imageUrl;
      _fallbackIndex = 0;
      _avifDecodeFailed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvifUrl(_currentUrl!)) {
      return CachedNetworkImage(
        imageUrl: _currentUrl!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        memCacheWidth: widget.memCacheWidth,
        memCacheHeight: widget.memCacheHeight,
        filterQuality: widget.filterQuality,
        placeholder: widget.placeholder,
        errorWidget: (context, url, error) {
          if (_fallbackIndex < _fallbackExtensions.length) {
            WidgetsBinding.instance.addPostFrameCallback((duration) {
              if (mounted) {
                setState(() {
                  _fallbackIndex++;
                  _currentUrl = _getFallbackUrl(widget.imageUrl, _fallbackIndex);
                });
              }
            });
            return widget.placeholder?.call(context, _currentUrl!) ??
                const SizedBox.shrink();
          }
          return _buildErrorWidget(error);
        },
        imageBuilder: widget.imageBuilder,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: Duration.zero,
      );
    }

    return FutureBuilder<File?>(
      future: _loadCachedFile(_currentUrl!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder?.call(context, _currentUrl!) ??
              const SizedBox.shrink();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (_fallbackIndex < _fallbackExtensions.length) {
            WidgetsBinding.instance.addPostFrameCallback((duration) {
              if (mounted) {
                setState(() {
                  _fallbackIndex++;
                  _currentUrl = _getFallbackUrl(widget.imageUrl, _fallbackIndex);
                });
              }
            });
            return widget.placeholder?.call(context, _currentUrl!) ??
                const SizedBox.shrink();
          }
          return _buildErrorWidget(snapshot.error ?? 'Failed to load image');
        }

        return _buildAvifImageFromFile(snapshot.data!);
      },
    );
  }
}
