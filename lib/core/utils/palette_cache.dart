import 'dart:collection';
import 'package:flutter/material.dart';

class PaletteColors {
  final Color dominant;
  final Color vibrant;
  final Color darkVibrant;
  final Color muted;

  const PaletteColors({
    required this.dominant,
    required this.vibrant,
    required this.darkVibrant,
    required this.muted,
  });
}

class PaletteLruCache {
  final int maxEntries;
  final LinkedHashMap<String, PaletteColors> _map;

  PaletteLruCache({this.maxEntries = 64}) : _map = LinkedHashMap();

  PaletteColors? get(String key) {
    final existing = _map.remove(key);
    if (existing != null) {
      _map[key] = existing;
    }
    return existing;
  }

  void put(String key, PaletteColors value) {
    if (_map.containsKey(key)) {
      _map.remove(key);
    }
    _map[key] = value;
    if (_map.length > maxEntries) {
      _map.remove(_map.keys.first);
    }
  }

  void clear() => _map.clear();
}

