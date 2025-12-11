import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/inventory_entity.dart';
import '../../../domain/services/item_catalog.dart';

part 'inventory_bloc.freezed.dart';
part 'inventory_event.dart';
part 'inventory_state.dart';

/// BLoC for managing player inventory
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final ItemCatalog itemCatalog;
  final void Function(int coins)? onCoinsSpent;
  final void Function(Map<String, double> effects)? onItemUsed;
  
  InventoryBloc({
    required this.itemCatalog,
    this.onCoinsSpent,
    this.onItemUsed,
  }) : super(const InventoryState.initial()) {
    on<LoadInventoryEvent>(_onLoad);
    on<AddItemEvent>(_onAddItem);
    on<RemoveItemEvent>(_onRemoveItem);
    on<UseItemEvent>(_onUseItem);
    on<PurchaseItemEvent>(_onPurchaseItem);
  }
  
  InventoryEntity _inventory = InventoryEntity.empty();
  
  Future<void> _onLoad(LoadInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(const InventoryState.loading());
    
    // Initialize item catalog if not already done
    itemCatalog.initialize();
    
    // In a real app, load from storage here
    // For now, start with empty inventory or give starter items
    _inventory = InventoryEntity.empty();
    
    // Give starter items
    final snack = itemCatalog.getItem('food_snack');
    final ball = itemCatalog.getItem('toy_ball');
    if (snack != null) {
      _inventory = _inventory.addItem(snack, quantity: 3);
    }
    if (ball != null) {
      _inventory = _inventory.addItem(ball, quantity: 1);
    }
    
    emit(InventoryState.loaded(inventory: _inventory));
  }
  
  Future<void> _onAddItem(AddItemEvent event, Emitter<InventoryState> emit) async {
    final definition = itemCatalog.getItem(event.itemId);
    if (definition == null) {
      emit(InventoryState.error('Item not found: ${event.itemId}'));
      emit(InventoryState.loaded(inventory: _inventory));
      return;
    }
    
    _inventory = _inventory.addItem(definition, quantity: event.quantity);
    emit(InventoryState.loaded(inventory: _inventory));
  }
  
  Future<void> _onRemoveItem(RemoveItemEvent event, Emitter<InventoryState> emit) async {
    _inventory = _inventory.removeItem(event.itemId, quantity: event.quantity);
    emit(InventoryState.loaded(inventory: _inventory));
  }
  
  Future<void> _onUseItem(UseItemEvent event, Emitter<InventoryState> emit) async {
    if (!_inventory.hasItem(event.itemId)) {
      emit(const InventoryState.error('Item not in inventory'));
      emit(InventoryState.loaded(inventory: _inventory));
      return;
    }
    
    final result = _inventory.useItem(event.itemId);
    _inventory = result.inventory;
    
    // Notify about item effects
    if (result.effects.isNotEmpty) {
      onItemUsed?.call(result.effects);
    }
    
    emit(InventoryState.itemUsed(
      itemId: event.itemId,
      effects: result.effects,
    ));
    emit(InventoryState.loaded(inventory: _inventory));
  }
  
  Future<void> _onPurchaseItem(PurchaseItemEvent event, Emitter<InventoryState> emit) async {
    final definition = itemCatalog.getItem(event.itemId);
    if (definition == null) {
      emit(InventoryState.error('Item not found: ${event.itemId}'));
      emit(InventoryState.loaded(inventory: _inventory));
      return;
    }
    
    final totalCost = definition.basePrice * event.quantity;
    
    if (event.currentCoins < totalCost) {
      emit(const InventoryState.purchaseFailed('Not enough coins'));
      emit(InventoryState.loaded(inventory: _inventory));
      return;
    }
    
    // Add item to inventory
    _inventory = _inventory.addItem(definition, quantity: event.quantity);
    
    // Notify about coins spent
    onCoinsSpent?.call(totalCost);
    
    emit(InventoryState.purchaseSuccess(
      itemId: event.itemId,
      quantity: event.quantity,
      cost: totalCost,
    ));
    emit(InventoryState.loaded(inventory: _inventory));
  }
  
  /// Get available items for purchase
  List<ItemDefinition> getShopItems() => itemCatalog.allItems;
  
  /// Get items by category for shop display
  List<ItemDefinition> getShopItemsByCategory(ItemCategory category) {
    return itemCatalog.getByCategory(category);
  }
}
