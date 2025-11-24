class MockPromoCard {
  final String title;
  final String? thumbnailUrl;
  final String category;
  final String? time;
  final String? distance;
  final List<String> tags;

  const MockPromoCard({
    required this.title,
    this.thumbnailUrl,
    required this.category,
    this.time,
    this.distance,
    required this.tags,
  });

  static const List<MockPromoCard> defaultPromos = [
    MockPromoCard(
      title: 'Local News: City Jazz Night',
      category: 'Radio',
      time: 'Tonight 8 PM',
      distance: '3km away',
      tags: ['Event'],
    ),
    MockPromoCard(
      title: 'Weekend Special: Top 40 Countdown',
      category: 'Radio',
      time: 'Saturday 10 AM',
      distance: '5km away',
      tags: ['Music'],
    ),
    MockPromoCard(
      title: 'Breaking News: Local Event Coverage',
      category: 'News',
      time: 'Today 2 PM',
      distance: '1km away',
      tags: ['News'],
    ),
  ];
}
