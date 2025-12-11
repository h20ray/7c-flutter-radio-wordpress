part of 'inventory_bloc.dart';

@freezed
class InventoryEvent with _$InventoryEvent {
  /// Load inventory from storage
  const factory InventoryEvent.load() = LoadInventoryEvent;
  
  /// Add item to inventory
  const factory InventoryEvent.addItem({
    required String itemId,
    @Default(1) int quantity,
  }) = AddItemEvent;
  
  /// Remove item from inventory
  const factory InventoryEvent.removeItem({
    required String itemId,
    @Default(1) int quantity,
  }) = RemoveItemEvent;
  
  /// Use an item (applies effects)
  const factory InventoryEvent.useItem(String itemId) = UseItemEvent;
  
  /// Purchase an item from shop
  const factory InventoryEvent.purchase({
    required String itemId,
    required int currentCoins,
    @Default(1) int quantity,
  }) = PurchaseItemEvent;
}
