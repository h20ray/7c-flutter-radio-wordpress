import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/pet_action_record.dart';
import '../../domain/entities/tamtama_economy_entity.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/repositories/tamtama_repository.dart';
import '../../domain/services/pet_map_service.dart';
import '../datasources/tamtama_local_data_source.dart';
import '../models/tamtama_model.dart';
import '../models/tamtama_economy_model.dart';
import '../services/tamtama_tick_service.dart';

/// Implementation of TamTama repository with local persistence
class TamtamaRepositoryImpl implements TamtamaRepository {
  final TamtamaLocalDataSource localDataSource;
  final TamtamaTickService tickService;
  final PetMapService petMapService;

  TamtamaRepositoryImpl({
    required this.localDataSource,
    required this.tickService,
    required this.petMapService,
  });

  // --- Pet State ---

  @override
  Future<Either<Failure, TamtamaEntity>> fetch(String userId) async {
    try {
      var tamtama = await localDataSource.fetch(userId);
      
      // Update petName from displayName if petId exists
      if (tamtama.petId != null && petMapService.isLoaded) {
        final displayName = petMapService.getDisplayName(tamtama.petId!);
        if (displayName != 'Unknown Pet' && tamtama.petName != displayName) {
          tamtama = tamtama.copyWith(petName: displayName);
          await localDataSource.save(tamtama);
        }
      }
      
      return Right(tamtama);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEntity>> save(TamtamaEntity tamtama) async {
    try {
      // Update petName from displayName if petId exists
      TamtamaEntity updatedTamtama = tamtama;
      if (tamtama.petId != null && petMapService.isLoaded) {
        final displayName = petMapService.getDisplayName(tamtama.petId!);
        if (displayName != 'Unknown Pet') {
          updatedTamtama = tamtama.copyWith(petName: displayName);
        }
      }
      
      final model = TamtamaModel.fromEntity(updatedTamtama);
      await localDataSource.save(model);
      return Right(model);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, TamtamaEntity>> watch(String userId) {
    return localDataSource.watch(userId).map<Either<Failure, TamtamaEntity>>(
      (model) => Right(model),
    ).handleError(
      (error) => Left(CacheFailure(error.toString())),
    );
  }

  // --- Care Actions ---

  @override
  Future<Either<Failure, TamtamaEntity>> feedPet(String userId, FoodType food) async {
    try {
      final current = await localDataSource.fetch(userId);
      final economy = await localDataSource.fetchEconomy(userId);
      
      // Food costs and effects
      final (hungerGain, happinessGain, hygieneDecrease, cost) = switch (food) {
        FoodType.snack => (30.0, 3.0, 2.0, 10.0),
        FoodType.meal => (60.0, 5.0, 5.0, 25.0),
        FoodType.treat => (15.0, 10.0, 2.0, 15.0),
      };
      
      // Check if enough coins
      if (economy.coins < cost) {
        return const Left(InsufficientFundsFailure('Not enough coins'));
      }
      
      // Update pet
      final updated = TamtamaModel.fromEntity(current.copyWith(
        hunger: (current.hunger + hungerGain).clamp(0.0, 100.0),
        happiness: (current.happiness + happinessGain).clamp(0.0, 100.0),
        hygiene: (current.hygiene - hygieneDecrease).clamp(0.0, 100.0),
        lastFedAt: DateTime.now(),
        lastUpdateAt: DateTime.now(),
        history: current.history.addAction(
          PetActionRecord(
            type: PetActionType.feed,
            timestamp: DateTime.now(),
            deltas: {
              'hunger': hungerGain,
              'happiness': happinessGain,
              'hygiene': -hygieneDecrease,
            },
          ),
        ),
      ));
      
      await localDataSource.save(updated);
      
      // Deduct coins
      final updatedEconomy = TamtamaEconomyModel.fromEntity(economy.copyWith(
        coins: economy.coins - cost,
        lastUpdatedAt: DateTime.now(),
      ));
      await localDataSource.saveEconomy(updatedEconomy);
      
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEntity>> playWithPet(String userId, ActivityType activity) async {
    try {
      final current = await localDataSource.fetch(userId);
      final economy = await localDataSource.fetchEconomy(userId);
      
      // Activity effects and costs
      final (happinessGain, energyDecrease, affectionGain, hygieneDecrease, cost) = switch (activity) {
        ActivityType.quickPlay => (8.0, 5.0, 2.0, 2.0, 5.0),
        ActivityType.fullGame => (15.0, 10.0, 4.0, 3.0, 15.0),
        ActivityType.adventure => (20.0, 15.0, 6.0, 5.0, 20.0),
      };
      
      // Check if enough energy
      if (current.energy < energyDecrease) {
        return const Left(ValidationFailure('Pet is too tired to play'));
      }
      
      // Check if enough coins
      if (economy.coins < cost) {
        return const Left(InsufficientFundsFailure('Not enough coins'));
      }
      
      // Update pet
      final updated = TamtamaModel.fromEntity(current.copyWith(
        happiness: (current.happiness + happinessGain).clamp(0.0, 100.0),
        energy: (current.energy - energyDecrease).clamp(0.0, 100.0),
        affection: (current.affection + affectionGain).clamp(0.0, 100.0),
        hygiene: (current.hygiene - hygieneDecrease).clamp(0.0, 100.0),
        stress: (current.stress - 5.0).clamp(0.0, 100.0),
        lastPlayedAt: DateTime.now(),
        lastUpdateAt: DateTime.now(),
        history: current.history.addAction(
          PetActionRecord(
            type: PetActionType.play,
            timestamp: DateTime.now(),
            deltas: {
              'happiness': happinessGain,
              'energy': -energyDecrease,
              'affection': affectionGain,
              'hygiene': -hygieneDecrease,
              'stress': -5.0,
            },
          ),
        ),
      ));
      
      await localDataSource.save(updated);
      
      // Deduct coins
      final updatedEconomy = TamtamaEconomyModel.fromEntity(economy.copyWith(
        coins: economy.coins - cost,
        lastUpdatedAt: DateTime.now(),
      ));
      await localDataSource.saveEconomy(updatedEconomy);
      
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEntity>> cleanPet(String userId) async {
    try {
      final current = await localDataSource.fetch(userId);
      final economy = await localDataSource.fetchEconomy(userId);
      
      const cost = 10.0;
      
      if (economy.coins < cost) {
        return const Left(InsufficientFundsFailure('Not enough coins'));
      }
      
      final updated = TamtamaModel.fromEntity(current.copyWith(
        hygiene: (current.hygiene + 40.0).clamp(0.0, 100.0),
        happiness: (current.happiness + 2.0).clamp(0.0, 100.0),
        stress: (current.stress - 5.0).clamp(0.0, 100.0),
        lastCleanedAt: DateTime.now(),
        lastUpdateAt: DateTime.now(),
        history: current.history.addAction(
          PetActionRecord(
            type: PetActionType.clean,
            timestamp: DateTime.now(),
            deltas: const {
              'hygiene': 40.0,
              'happiness': 2.0,
              'stress': -5.0,
            },
          ),
        ),
      ));
      
      await localDataSource.save(updated);
      
      final updatedEconomy = TamtamaEconomyModel.fromEntity(economy.copyWith(
        coins: economy.coins - cost,
        lastUpdatedAt: DateTime.now(),
      ));
      await localDataSource.saveEconomy(updatedEconomy);
      
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEntity>> setSleepMode(String userId, bool sleeping) async {
    try {
      final current = await localDataSource.fetch(userId);
      
      final updated = TamtamaModel.fromEntity(current.copyWith(
        petState: sleeping ? PetState.sleeping : PetState.idle,
        lastSleptAt: sleeping ? DateTime.now() : current.lastSleptAt,
        lastUpdateAt: DateTime.now(),
        history: current.history.addAction(
          PetActionRecord(
            type: sleeping ? PetActionType.sleep : PetActionType.wake,
            timestamp: DateTime.now(),
          ),
        ),
      ));
      
      await localDataSource.save(updated);
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  // --- Economy ---

  @override
  Future<Either<Failure, TamtamaEconomyEntity>> getEconomy(String userId) async {
    try {
      final economy = await localDataSource.fetchEconomy(userId);
      return Right(economy);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, TamtamaEconomyEntity>> watchEconomy(String userId) {
    return localDataSource.watchEconomy(userId).map<Either<Failure, TamtamaEconomyEntity>>(
      (model) => Right(model),
    ).handleError(
      (error) => Left(CacheFailure(error.toString())),
    );
  }

  @override
  Future<Either<Failure, TamtamaEconomyEntity>> addListeningRewards(
    String userId,
    int minutes,
    String stationId,
  ) async {
    try {
      final economyModel = await localDataSource.fetchEconomy(userId);
      final petModel = await localDataSource.fetch(userId);
      
      // Check if new day - reset daily counters
      final now = DateTime.now();
      final lastUpdate = economyModel.lastUpdatedAt;
      final isNewDay = now.day != lastUpdate.day ||
          now.month != lastUpdate.month ||
          now.year != lastUpdate.year;
      
      var updatedTodayMinutes = economyModel.todayListeningMinutes;
      var updatedTodayStations = economyModel.todayStations;
      var updatedStreakDays = economyModel.streakDays;
      
      if (isNewDay) {
        // Check if streak continues or resets
        final lastStreakDate = economyModel.lastStreakDate;
        if (lastStreakDate != null) {
          final daysSinceLastStreak = now.difference(lastStreakDate).inDays;
          if (daysSinceLastStreak > 1) {
            // Streak broken
            updatedStreakDays = 0;
          } else if (daysSinceLastStreak == 1 &&
              economyModel.todayListeningMinutes >= TamtamaEconomyEntity.minDailyMinutesForStreak) {
            // Streak continues
            updatedStreakDays++;
          }
        }
        
        // Reset daily counters
        updatedTodayMinutes = 0;
        updatedTodayStations = {};
      }
      
      // Add station to today's set
      updatedTodayStations = {...updatedTodayStations, stationId};
      updatedTodayMinutes += minutes;
      
      // Calculate rewards
      final (tpGained, coinsGained, xpGained) = economyModel.calculateListeningRewards(minutes);
      
      // Update economy
      final updatedEconomy = TamtamaEconomyModel.fromEntity(economyModel.copyWith(
        tunePoints: economyModel.tunePoints + tpGained,
        coins: economyModel.coins + coinsGained,
        todayListeningMinutes: updatedTodayMinutes,
        streakDays: updatedStreakDays,
        lastStreakDate: updatedTodayMinutes >= TamtamaEconomyEntity.minDailyMinutesForStreak
            ? now
            : economyModel.lastStreakDate,
        todayStations: updatedTodayStations,
        totalListeningMinutes: economyModel.totalListeningMinutes + minutes,
        lastUpdatedAt: now,
      ));
      
      await localDataSource.saveEconomy(updatedEconomy);
      
      // Also update pet XP
      final updatedPet = TamtamaModel.fromEntity(petModel.copyWith(
        xp: petModel.xp + xpGained,
        petState: PetState.listening,
        lastUpdateAt: now,
        history: petModel.history.addAction(
          PetActionRecord(
            type: PetActionType.listening,
            timestamp: now,
            deltas: {
              'xp': xpGained,
            },
          ),
        ),
      ));
      await localDataSource.save(updatedPet);
      
      return Right(updatedEconomy);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEconomyEntity>> spendCoins(String userId, double amount) async {
    try {
      final economy = await localDataSource.fetchEconomy(userId);
      
      if (economy.coins < amount) {
        return const Left(InsufficientFundsFailure('Not enough coins'));
      }
      
      final updated = TamtamaEconomyModel.fromEntity(economy.copyWith(
        coins: economy.coins - amount,
        lastUpdatedAt: DateTime.now(),
      ));
      
      await localDataSource.saveEconomy(updated);
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  // --- Tick System ---

  @override
  Future<Either<Failure, TamtamaEntity>> applyTick(
    String userId, {
    bool isListening = false,
    bool isSleeping = false,
  }) async {
    try {
      final current = await localDataSource.fetch(userId);
      if (current.lifeStage == LifeStage.egg) {
        final updated = TamtamaModel.fromEntity(
          current.copyWith(lastUpdateAt: DateTime.now()),
        );
        await localDataSource.save(updated);
        return Right(updated);
      }
      
      final delta = tickService.computeTickDelta(
        isListening: isListening,
        isSleeping: isSleeping || current.petState == PetState.sleeping,
        current: current,
      );
      
      final updated = tickService
          .applyDelta(current, delta)
          .copyWith(
            history: current.history.addAction(
              PetActionRecord(
                type: PetActionType.tick,
                timestamp: DateTime.now(),
                deltas: {
                  'hunger': delta.hungerDelta,
                  'energy': delta.energyDelta,
                  'happiness': delta.happinessDelta,
                  'hygiene': delta.hygieneDelta,
                  'affection': delta.affectionDelta,
                  'stress': delta.stressDelta,
                  'health': delta.healthDelta,
                  'neglect': delta.neglectScoreDelta,
                  'xp': delta.xpDelta,
                },
              ),
            ),
          );
      await localDataSource.save(updated);
      
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TamtamaEntity>> applyOfflineTicks(String userId) async {
    try {
      final current = await localDataSource.fetch(userId);
      if (current.lifeStage == LifeStage.egg) {
        final updated = TamtamaModel.fromEntity(
          current.copyWith(lastUpdateAt: DateTime.now()),
        );
        await localDataSource.save(updated);
        return Right(updated);
      }
      
      final delta = tickService.computeOfflineTicks(
        lastUpdateAt: current.lastUpdateAt,
        current: current,
      );
      
      if (delta.minutesElapsed <= 0) {
        return Right(current);
      }
      
      final updated = tickService
          .applyDelta(current, delta)
          .copyWith(
            history: current.history.addAction(
              PetActionRecord(
                type: PetActionType.tick,
                timestamp: DateTime.now(),
                deltas: {
                  'hunger': delta.hungerDelta,
                  'energy': delta.energyDelta,
                  'happiness': delta.happinessDelta,
                  'hygiene': delta.hygieneDelta,
                  'affection': delta.affectionDelta,
                  'stress': delta.stressDelta,
                  'health': delta.healthDelta,
                  'neglect': delta.neglectScoreDelta,
                  'xp': delta.xpDelta,
                },
              ),
            ),
          );
      await localDataSource.save(updated);
      
      return Right(updated);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  // --- Management ---

  @override
  Future<bool> exists(String userId) {
    return localDataSource.exists(userId);
  }

  @override
  Future<Either<Failure, void>> delete(String userId) async {
    try {
      await localDataSource.delete(userId);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }
}

/// Custom failure for insufficient funds
class InsufficientFundsFailure extends Failure {
  const InsufficientFundsFailure(super.message);
}

/// Custom failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
