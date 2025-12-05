import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GreetingRepository {
  static final GreetingRepository _instance = GreetingRepository._internal();
  factory GreetingRepository() => _instance;
  GreetingRepository._internal();

  Map<String, dynamic>? _quotesId;
  Map<String, dynamic>? _quotesEn;
  
  final _random = Random();

  Future<void> initialize() async {
    try {
      final String idString = await rootBundle.loadString('assets/others/greeting_id.json');
      final String enString = await rootBundle.loadString('assets/others/greeting_en.json');
      
      _quotesId = json.decode(idString);
      _quotesEn = json.decode(enString);
    } catch (e) {
      debugPrint('Error loading greeting quotes: $e');
    }
  }

  Future<String> getDailyQuote(String timeKey, String languageCode) async {
    // Ensure data is loaded
    if (_quotesId == null || _quotesEn == null) {
      await initialize();
    }

    try {
      final box = await Hive.openBox('greeting_cache');
      
      final now = DateTime.now();
      final dateKey = '${now.year}-${now.month}-${now.day}';
      final cacheKey = 'quote_${dateKey}_${timeKey}_$languageCode';
      
      final cachedQuote = box.get(cacheKey);
      if (cachedQuote != null && cachedQuote is String) {
        return cachedQuote;
      }
      
      // If not cached, get new random quote
      final newQuote = _getRandomQuote(timeKey, languageCode);
      if (newQuote.isNotEmpty) {
        await box.put(cacheKey, newQuote);
      }
      return newQuote;
    } catch (e) {
      debugPrint('Error accessing greeting cache: $e');
      // Fallback to random if cache fails
      return _getRandomQuote(timeKey, languageCode);
    }
  }

  String _getRandomQuote(String timeKey, String languageCode) {
    final quotesMap = languageCode == 'id' ? _quotesId : _quotesEn;
    
    // Fallback to ID if EN is missing, or vice versa if needed, but let's assume safely
    final targetMap = quotesMap ?? _quotesId;
    
    if (targetMap == null) return '';

    // Handle "noon" vs "midday" mismatch if any
    // The JSON uses "noon", the code uses "greeting_midday".
    String jsonKey = timeKey;
    if (timeKey == 'greeting_morning') jsonKey = 'morning';
    if (timeKey == 'greeting_midday') jsonKey = 'noon';
    if (timeKey == 'greeting_evening') jsonKey = 'evening';
    if (timeKey == 'greeting_night') jsonKey = 'night';

    final List<dynamic>? quotes = targetMap[jsonKey];
    
    if (quotes != null && quotes.isNotEmpty) {
      return quotes[_random.nextInt(quotes.length)] as String;
    }
    
    return '';
  }
}
