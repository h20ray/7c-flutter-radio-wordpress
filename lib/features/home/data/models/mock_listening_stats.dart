class MockListeningStats {
  final String planName;
  final String hoursListened;
  final int renewalDays;

  const MockListeningStats({
    required this.planName,
    required this.hoursListened,
    required this.renewalDays,
  });

  static const MockListeningStats defaultStats = MockListeningStats(
    planName: 'Premium Radio',
    hoursListened: '16h 45m',
    renewalDays: 12,
  );
}

