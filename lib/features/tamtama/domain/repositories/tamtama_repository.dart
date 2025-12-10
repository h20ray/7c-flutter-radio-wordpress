import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tamtama_entity.dart';
import '../entities/tamtama_economy_entity.dart';

/// Repository for TamTama pet management
abstract class TamtamaRepository {
  // --- Pet State ---
  
  /// Fetch pet state for a user
  Future<Either<Failure, TamtamaEntity>> fetch(String userId);
  
  /// Save pet state
  Future<Either<Failure, TamtamaEntity>> save(TamtamaEntity tamtama);
  
  /// Watch pet state changes
  Stream<Either<Failure, TamtamaEntity>> watch(String userId);
  
  // --- Care Actions ---
  
  /// Feed the pet with specified food type
  Future<Either<Failure, TamtamaEntity>> feedPet(String userId, FoodType food);
  
  /// Play with the pet using specified activity
  Future<Either<Failure, TamtamaEntity>> playWithPet(String userId, ActivityType activity);
  
  /// Clean the pet (bath/hygiene)
  Future<Either<Failure, TamtamaEntity>> cleanPet(String userId);
  
  /// Toggle sleep mode
  Future<Either<Failure, TamtamaEntity>> setSleepMode(String userId, bool sleeping);
  
  // --- Economy ---
  
  /// Get economy state for a user
  Future<Either<Failure, TamtamaEconomyEntity>> getEconomy(String userId);
  
  /// Watch economy state changes
  Stream<Either<Failure, TamtamaEconomyEntity>> watchEconomy(String userId);
  
  /// Add listening rewards (called when radio plays)
  Future<Either<Failure, TamtamaEconomyEntity>> addListeningRewards(
    String userId, 
    int minutes, 
    String stationId,
  );
  
  /// Spend coins (for purchases)
  Future<Either<Failure, TamtamaEconomyEntity>> spendCoins(String userId, double amount);
  
  // --- Tick System ---
  
  /// Apply a tick update to pet stats
  Future<Either<Failure, TamtamaEntity>> applyTick(
    String userId, {
    bool isListening = false,
    bool isSleeping = false,
  });
  
  /// Apply offline catch-up ticks
  Future<Either<Failure, TamtamaEntity>> applyOfflineTicks(String userId);
  
  // --- Management ---
  
  /// Check if pet exists for user
  Future<bool> exists(String userId);
  
  /// Delete pet data (for reset)
  Future<Either<Failure, void>> delete(String userId);
}
