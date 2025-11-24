class MockRewardPoints {
  final int points;
  final String redemptionInfo;

  const MockRewardPoints({required this.points, required this.redemptionInfo});

  static const MockRewardPoints defaultPoints = MockRewardPoints(
    points: 625,
    redemptionInfo: 'Tap to redeem',
  );
}
