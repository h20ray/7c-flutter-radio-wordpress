class MockFeaturedShow {
  final String title;
  final String? hostImageUrl;
  final String schedule;
  final List<String> tags;
  final String? nextUpIn;

  const MockFeaturedShow({
    required this.title,
    this.hostImageUrl,
    required this.schedule,
    required this.tags,
    this.nextUpIn,
  });

  static const MockFeaturedShow defaultShow = MockFeaturedShow(
    title: 'Morning Drive with Alex',
    schedule: 'Weekdays · 6:00–9:00 AM',
    tags: ['Live', 'Pop Hits'],
    nextUpIn: '15 min',
  );
}
