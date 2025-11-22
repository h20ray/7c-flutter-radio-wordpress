import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../utils/palette_cache.dart';

class PaletteService {
  PaletteService({PaletteLruCache? cache}) : _cache = cache ?? PaletteLruCache();

  final PaletteLruCache _cache;

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
      final generator = await PaletteGenerator.fromImageProvider(
        provider,
        size: const Size(200, 200),
        maximumColorCount: 12,
      );

      final dominant = generator.dominantColor?.color;
      final vibrant = generator.vibrantColor?.color ?? dominant;
      final darkVibrant = generator.darkVibrantColor?.color ?? dominant;
      final muted = generator.mutedColor?.color ?? dominant;

      final Color resolvedDominant = dominant ?? const Color(0xFF15232B);
      return PaletteColors(
        dominant: resolvedDominant,
        vibrant: vibrant ?? resolvedDominant,
        darkVibrant: darkVibrant ?? resolvedDominant,
        muted: muted ?? resolvedDominant,
      );
    } catch (e) {
      rethrow;
    }
  }

  PaletteColors _fallbackFrom(Color base) {
    final dark = HSLColor.fromColor(base).withLightness((HSLColor.fromColor(base).lightness * 0.6).clamp(0.0, 1.0)).toColor();
    final vib = HSLColor.fromColor(base).withSaturation((HSLColor.fromColor(base).saturation * 1.1).clamp(0.0, 1.0)).toColor();
    final muted = HSLColor.fromColor(base).withSaturation((HSLColor.fromColor(base).saturation * 0.6).clamp(0.0, 1.0)).toColor();
    return PaletteColors(dominant: base, vibrant: vib, darkVibrant: dark, muted: muted);
  }
}

class PaletteImageProvider {
  static ImageProvider network(String url) => NetworkImage(url);
}

