import 'dart:math';

/// Deterministic RNG system for TamTama evolution.
/// 
/// Uses seeded random for reproducible per-user evolution outcomes.
/// Based on Tamagotchi-style determinism where evolution is
/// influenced by consistent user-specific factors.
class TTRng {
  final Random _rng;
  final int seed;

  TTRng(this.seed) : _rng = Random(seed);

  /// Generate a random double [0.0, 1.0)
  double nextDouble() => _rng.nextDouble();

  /// Generate a random integer [0, max)
  int nextInt(int max) => _rng.nextInt(max);

  /// Generate a random boolean with optional probability (default 0.5)
  bool nextBool([double probability = 0.5]) => _rng.nextDouble() < probability;

  /// Factory to create from user context
  factory TTRng.fromContext({
    required String userId,
    required int familyIndex,
    required int stage,
    required DateTime installDate,
  }) {
    final seed = computeSeed(
      userId: userId,
      familyIndex: familyIndex,
      stage: stage,
      installDate: installDate,
    );
    return TTRng(seed);
  }

  /// Factory for daily RNG (changes each day)
  factory TTRng.daily({
    required String userId,
    required DateTime date,
  }) {
    final dayHash = date.year * 10000 + date.month * 100 + date.day;
    final seed = userId.hashCode ^ dayHash;
    return TTRng(seed & 0x7FFFFFFF);
  }

  /// Compute deterministic seed from user context
  static int computeSeed({
    required String userId,
    required int familyIndex,
    required int stage,
    required DateTime installDate,
  }) {
    // Combine factors using prime multipliers for distribution
    final base = userId.hashCode ^
        installDate.millisecondsSinceEpoch ^
        (familyIndex * 7919) ^  // Large prime
        (stage * 48611);         // Another prime
    // Ensure positive 31-bit integer for Random compatibility
    return base & 0x7FFFFFFF;
  }

  /// Choose from weighted options
  /// 
  /// [weights] maps option key to weight value.
  /// Returns the chosen key based on weighted random selection.
  T chooseWeighted<T>(Map<T, double> weights, {double? rngBoost}) {
    if (weights.isEmpty) {
      throw ArgumentError('Weights map cannot be empty');
    }

    double totalWeight = weights.values.reduce((a, b) => a + b);
    if (rngBoost != null) {
      totalWeight += rngBoost;
    }

    final roll = nextDouble() * totalWeight;
    double cumulative = 0;

    for (final entry in weights.entries) {
      cumulative += entry.value;
      if (roll <= cumulative) {
        return entry.key;
      }
    }

    // Fallback to last entry
    return weights.keys.last;
  }

  /// Choose evolution branch from weighted candidates
  /// 
  /// [branchWeights] maps branch ID (e.g., 15011) to its computed score.
  /// [noiseEpsilon] adds small random noise [0, epsilon) to each score.
  int chooseEvolutionBranch({
    required Map<int, double> branchWeights,
    double noiseEpsilon = 0.05,
  }) {
    // Add noise to each branch for anti-predictability
    final noisyWeights = <int, double>{};
    for (final entry in branchWeights.entries) {
      final noise = nextDouble() * noiseEpsilon;
      noisyWeights[entry.key] = entry.value + noise;
    }

    return chooseWeighted(noisyWeights);
  }
}
