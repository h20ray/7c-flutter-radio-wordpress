class NewsConfig {
  static const Duration newsCacheTTL = Duration(hours: 1);
  static const Duration categoryCacheTTL = Duration(hours: 24);
  static const int homeNewsListLimit = 7;
  static const int newsPageListLimit = 10;
  static const bool useMinimalNewsPayload = true;
}

