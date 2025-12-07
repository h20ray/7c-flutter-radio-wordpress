import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class SocialMediaService {
  final Dio _dio = Dio();
  final String _configUrl = 'https://tujuhcahaya.com/wp-json/tujuhcahaya/v2/config';

  Future<Map<String, String>> getSocialMediaLinks() async {
    try {
      final response = await _dio.get(_configUrl);
      
      if (response.statusCode == 200) {
        final data = response.data;
        // Handle both string (if JSON encoded) and Map response types
        final Map<String, dynamic> jsonMap = data is String ? json.decode(data) : data;
        
        final Map<String, String> links = {};
        
        // Extract known social media keys
        final keys = [
          'facebookUrl',
          'twitterUrl',
          'telegramUrl',
          'instagramUrl',
          'tiktokUrl',
          'youtubeUrl',
          'whatsappUrl'
        ];

        for (final key in keys) {
          if (jsonMap.containsKey(key) && jsonMap[key] != null && jsonMap[key].toString().isNotEmpty) {
            links[key] = jsonMap[key].toString();
          }
        }
        
        return links;
      }
      return {};
    } catch (e) {
      // Silently fail or log error
      debugPrint('Error fetching social media links: $e');
      return {};
    }
  }
}
