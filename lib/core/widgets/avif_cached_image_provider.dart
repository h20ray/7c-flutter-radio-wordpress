import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_avif/flutter_avif.dart';
import '../cache/image_cache_manager.dart';

/// Custom ImageProvider for AVIF images that works with Flutter's image caching system
/// This allows AVIF images to be used with the Image widget and cached properly
class AvifCachedImageProvider extends ImageProvider<AvifCachedImageProvider> {
  final String url;
  final ImageCacheManager _cacheManager;

  AvifCachedImageProvider(this.url) : _cacheManager = ImageCacheManager();

  @override
  Future<AvifCachedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AvifCachedImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    AvifCachedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<AvifCachedImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    AvifCachedImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    try {
      // Get cached file from disk
      final file = await _cacheManager.getCachedFile(url);
      
      // Read file bytes
      final bytes = await file.readAsBytes();
      
      // Decode AVIF using flutter_avif
      final codec = await decodeAvifFromBuffer(bytes);
      
      return codec;
    } catch (e) {
      // If AVIF fails, throw so error handler can deal with it
      throw Exception('Failed to load AVIF image: $e');
    }
  }

  /// Decode AVIF bytes to Codec
  Future<ui.Codec> decodeAvifFromBuffer(Uint8List bytes) async {
    // Use flutter_avif to decode the AVIF image
    final frames = await decodeAvif(bytes);
    
    if (frames.isEmpty) {
      throw Exception('AVIF decoding returned no frames');
    }
    
    // Use the first frame (for static images, there's only one frame)
    final firstFrame = frames.first;
    
    // Create single-frame codec
    return _SingleFrameCodec(firstFrame.image, firstFrame.duration);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AvifCachedImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '${objectRuntimeType(this, 'AvifCachedImageProvider')}("$url")';
}

/// Single-frame codec implementation
class _SingleFrameCodec implements ui.Codec {
  final ui.Image _image;
  final Duration _duration;

  _SingleFrameCodec(this._image, this._duration);

  @override
  int get frameCount => 1;

  @override
  int get repetitionCount => 0;

  @override
  Future<ui.FrameInfo> getNextFrame() async {
    return _SingleFrameInfo(_image, _duration);
  }

  @override
  void dispose() {
  }
}

class _SingleFrameInfo implements ui.FrameInfo {
  @override
  final ui.Image image;

  @override
  final Duration duration;

  _SingleFrameInfo(this.image, this.duration);
}
