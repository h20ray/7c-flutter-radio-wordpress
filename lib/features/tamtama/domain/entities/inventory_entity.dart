import 'package:equatable/equatable.dart';

/// Category of inventory items
enum ItemCategory {
  /// Food items that restore hunger
  food,
  
  /// Toys for playing activities
  toy,
  
  /// Medicine items for health
  medicine,
  
  /// Special/cosmetic items
  special,
}

/// Rarity level affecting drop rates and prices
enum ItemRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

/// A single inventory item definition
class ItemDefinition extends Equatable {
  final String id;
  final String name;
  final String description;
  final ItemCategory category;
  final ItemRarity rarity;
  final int basePrice;
  final String iconAsset;
  final Map<String, double> effects;
  
  const ItemDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.rarity = ItemRarity.common,
    required this.basePrice,
    this.iconAsset = 'assets/icons/item_default.png',
    this.effects = const {},
  });
  
  /// Get effect value for a stat (e.g., 'hunger', 'happiness')
  double getEffect(String statKey) => effects[statKey] ?? 0.0;
  
  @override
  List<Object?> get props => [id, name, category, rarity, basePrice, effects];
}

/// An item instance in the player's inventory with quantity
class InventoryItem extends Equatable {
  final ItemDefinition definition;
  final int quantity;
  
  const InventoryItem({
    required this.definition,
    this.quantity = 1,
  });
  
  String get id => definition.id;
  String get name => definition.name;
  ItemCategory get category => definition.category;
  
  InventoryItem copyWith({int? quantity}) {
    return InventoryItem(
      definition: definition,
      quantity: quantity ?? this.quantity,
    );
  }
  
  InventoryItem add(int amount) => copyWith(quantity: quantity + amount);
  
  InventoryItem remove(int amount) => copyWith(
    quantity: (quantity - amount).clamp(0, quantity),
  );
  
  bool get isEmpty => quantity <= 0;
  
  @override
  List<Object?> get props => [definition, quantity];
}

/// The player's complete inventory
class InventoryEntity extends Equatable {
  final Map<String, InventoryItem> items;
  final DateTime lastUpdated;
  
  const InventoryEntity({
    this.items = const {},
    required this.lastUpdated,
  });
  
  factory InventoryEntity.empty() => InventoryEntity(
    lastUpdated: DateTime.now(),
  );
  
  /// Get all items of a specific category
  List<InventoryItem> getByCategory(ItemCategory category) {
    return items.values
        .where((item) => item.category == category)
        .toList();
  }
  
  /// Get quantity of a specific item
  int getQuantity(String itemId) => items[itemId]?.quantity ?? 0;
  
  /// Check if player has at least one of an item
  bool hasItem(String itemId) => getQuantity(itemId) > 0;
  
  /// Total number of unique items
  int get uniqueItemCount => items.length;
  
  /// Total quantity of all items
  int get totalItemCount => items.values.fold(0, (sum, item) => sum + item.quantity);
  
  /// Get all food items
  List<InventoryItem> get foods => getByCategory(ItemCategory.food);
  
  /// Get all toy items  
  List<InventoryItem> get toys => getByCategory(ItemCategory.toy);
  
  /// Get all medicine items
  List<InventoryItem> get medicines => getByCategory(ItemCategory.medicine);
  
  InventoryEntity copyWith({
    Map<String, InventoryItem>? items,
    DateTime? lastUpdated,
  }) {
    return InventoryEntity(
      items: items ?? this.items,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
  
  /// Add items to inventory
  InventoryEntity addItem(ItemDefinition definition, {int quantity = 1}) {
    final newItems = Map<String, InventoryItem>.from(items);
    final existing = newItems[definition.id];
    
    if (existing != null) {
      newItems[definition.id] = existing.add(quantity);
    } else {
      newItems[definition.id] = InventoryItem(
        definition: definition,
        quantity: quantity,
      );
    }
    
    return copyWith(items: newItems, lastUpdated: DateTime.now());
  }
  
  /// Remove items from inventory
  InventoryEntity removeItem(String itemId, {int quantity = 1}) {
    final newItems = Map<String, InventoryItem>.from(items);
    final existing = newItems[itemId];
    
    if (existing != null) {
      final updated = existing.remove(quantity);
      if (updated.isEmpty) {
        newItems.remove(itemId);
      } else {
        newItems[itemId] = updated;
      }
    }
    
    return copyWith(items: newItems, lastUpdated: DateTime.now());
  }
  
  /// Use an item (remove 1 and return effects)
  ({InventoryEntity inventory, Map<String, double> effects}) useItem(String itemId) {
    final item = items[itemId];
    if (item == null || item.isEmpty) {
      return (inventory: this, effects: {});
    }
    
    return (
      inventory: removeItem(itemId),
      effects: item.definition.effects,
    );
  }
  
  @override
  List<Object?> get props => [items, lastUpdated];
}
