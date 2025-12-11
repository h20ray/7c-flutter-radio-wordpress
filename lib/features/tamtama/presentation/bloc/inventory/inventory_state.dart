part of 'inventory_bloc.dart';

@freezed
class InventoryState with _$InventoryState {
  /// Initial state
  const factory InventoryState.initial() = InventoryInitial;
  
  /// Loading inventory
  const factory InventoryState.loading() = InventoryLoading;
  
  /// Inventory loaded successfully
  const factory InventoryState.loaded({
    required InventoryEntity inventory,
  }) = InventoryLoaded;
  
  /// Item was used successfully
  const factory InventoryState.itemUsed({
    required String itemId,
    required Map<String, double> effects,
  }) = InventoryItemUsed;
  
  /// Purchase succeeded
  const factory InventoryState.purchaseSuccess({
    required String itemId,
    required int quantity,
    required int cost,
  }) = InventoryPurchaseSuccess;
  
  /// Purchase failed
  const factory InventoryState.purchaseFailed(String reason) = InventoryPurchaseFailed;
  
  /// Error state
  const factory InventoryState.error(String message) = InventoryError;
}
