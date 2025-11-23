class MockUserProfile {
  final String name;
  final String listenerId;
  final String? avatarUrl;
  final String? favoriteStation;

  const MockUserProfile({
    required this.name,
    required this.listenerId,
    this.avatarUrl,
    this.favoriteStation,
  });

  static const MockUserProfile defaultProfile = MockUserProfile(
    name: 'Andi Gilang',
    listenerId: '0851-5521-9777',
    favoriteStation: 'Tujuh Cahaya Radio',
  );
}

