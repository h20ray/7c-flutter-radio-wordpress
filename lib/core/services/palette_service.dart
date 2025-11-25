import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import '../utils/palette_cache.dart';

class PaletteService {
  static final PaletteLruCache _sharedCache = PaletteLruCache();
  
  PaletteService({PaletteLruCache? cache}) : _cache = cache ?? _sharedCache;

  final PaletteLruCache _cache;

  PaletteColors? getCached(String? url) {
    if (url == null || url.isEmpty) return null;
    return _cache.get(url);
  }

  Future<PaletteColors> fetchForUrl(String? url, {Color fallback = const Color(0xFF15232B)}) async {
    if (url == null || url.isEmpty) {
      return _fallbackFrom(fallback);
    }
    final cached = _cache.get(url);
    if (cached != null) {
      return cached;
    }

    try {
      final result = await _extract(PaletteImageProvider.network(url));
      _cache.put(url, result);
      return result;
    } catch (e) {
      return _fallbackFrom(fallback);
    }
  }

  Future<PaletteColors> fetchForImage(ImageProvider provider, {String? cacheKey, Color fallback = const Color(0xFF15232B)}) async {
    if (cacheKey != null) {
      final cached = _cache.get(cacheKey);
      if (cached != null) return cached;
    }
    try {
      final result = await _extract(provider);
      if (cacheKey != null) _cache.put(cacheKey, result);
      return result;
    } catch (_) {
      return _fallbackFrom(fallback);
    }
  }

  Future<PaletteColors> _extract(ImageProvider provider) async {
    try {
      final colors = await _getColorsFromImage(provider);
      if (colors.isEmpty) {
        throw Exception('No colors extracted from image');
      }

      final dominant = colors.first;
      final vibrant = colors.length > 1 ? colors[1] : dominant;
      final darkVibrant = _darkenColor(colors.length > 2 ? colors[2] : dominant);
      final muted = _muteColor(colors.length > 3 ? colors[3] : dominant);

      return PaletteColors(
        dominant: dominant,
        vibrant: vibrant,
        darkVibrant: darkVibrant,
        muted: muted,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Color>> _getColorsFromImage(ImageProvider provider) async {
    try {
      final quantizerResult = await _extractColorsFromImageProvider(provider);
      final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
        (key, value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
      );

      final List<int> filteredResults = Score.score(
        colorToCount,
        desired: 1,
        filter: true,
      );
      final List<int> scoredResults = Score.score(
        colorToCount,
        desired: 4,
        filter: false,
      );
      return <dynamic>{...filteredResults, ...scoredResults}
          .toList()
          .map((argb) => Color(argb))
          .toList();
    } catch (e) {
      throw Exception('Error getting colors from image: $e');
    }
  }

  Future<QuantizerResult> _extractColorsFromImageProvider(
      ImageProvider imageProvider) async {
    final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
    final ByteData? imageBytes = await scaledImage.toByteData();

    final Uint32List pixelData = imageBytes!.buffer.asUint32List();
    
    final QuantizerResult quantizerResult = await compute(
      _quantizeInIsolate,
      pixelData,
    );
    return quantizerResult;
  }

  Future<ui.Image> _imageProviderToScaled(ImageProvider imageProvider) async {
    const double maxDimension = 112.0;
    final ImageStream stream = imageProvider.resolve(
        const ImageConfiguration(size: Size(maxDimension, maxDimension)));
    final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    late ui.Image scaledImage;
    Timer? loadFailureTimeout;

    listener = ImageStreamListener((ImageInfo info, bool sync) async {
      loadFailureTimeout?.cancel();
      stream.removeListener(listener);
      final ui.Image image = info.image;
      final int width = image.width;
      final int height = image.height;
      double paintWidth = width.toDouble();
      double paintHeight = height.toDouble();
      assert(width > 0 && height > 0);

      final bool rescale = width > maxDimension || height > maxDimension;
      if (rescale) {
        paintWidth =
            (width > height) ? maxDimension : (maxDimension / height) * width;
        paintHeight =
            (height > width) ? maxDimension : (maxDimension / width) * height;
      }
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
          image: image,
          filterQuality: FilterQuality.none);

      final ui.Picture picture = pictureRecorder.endRecording();
      scaledImage =
          await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
      imageCompleter.complete(scaledImage);
    }, onError: (Object exception, StackTrace? stackTrace) {
      stream.removeListener(listener);
      imageCompleter.completeError(
          Exception('Failed to render image: $exception'));
    });

    loadFailureTimeout = Timer(const Duration(seconds: 5), () {
      stream.removeListener(listener);
      imageCompleter.completeError(
          TimeoutException('Timeout occurred trying to load image'));
    });

    stream.addListener(listener);
    await imageCompleter.future;
    return scaledImage;
  }

  int _getArgbFromAbgr(int abgr) {
    const int exceptRMask = 0xFF00FFFF;
    const int onlyRMask = ~exceptRMask;
    const int exceptBMask = 0xFFFFFF00;
    const int onlyBMask = ~exceptBMask;
    final int r = (abgr & onlyRMask) >> 16;
    final int b = abgr & onlyBMask;
    return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
  }

  Color _darkenColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0)).toColor();
  }

  Color _muteColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withSaturation((hsl.saturation * 0.6).clamp(0.0, 1.0)).toColor();
  }

  PaletteColors _fallbackFrom(Color base) {
    final dark = _darkenColor(base);
    final vib = HSLColor.fromColor(base)
        .withSaturation((HSLColor.fromColor(base).saturation * 1.1).clamp(0.0, 1.0))
        .toColor();
    final muted = _muteColor(base);
    return PaletteColors(dominant: base, vibrant: vib, darkVibrant: dark, muted: muted);
  }
}

Future<QuantizerResult> _quantizeInIsolate(Uint32List pixelData) async {
  return await QuantizerCelebi().quantize(
    pixelData,
    128,
    returnInputPixelToClusterPixel: true,
  );
}

class PaletteImageProvider {
  static ImageProvider network(String url) => NetworkImage(url);
}

