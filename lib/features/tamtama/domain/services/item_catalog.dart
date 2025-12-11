import '../entities/inventory_entity.dart';

/// Catalog of all available items in the game
class ItemCatalog {
  ItemCatalog._();
  
  static final ItemCatalog instance = ItemCatalog._();
  
  /// All item definitions
  final Map<String, ItemDefinition> _items = {};
  
  /// Initialize the catalog with default items
  void initialize() {
    _registerFoods();
    _registerToys();
    _registerMedicines();
    _registerSpecials();
  }
  
  void _registerFoods() {
    _register(const ItemDefinition(
      id: 'food_snack',
      name: 'Snack',
      description: 'A quick snack to satisfy hunger',
      category: ItemCategory.food,
      rarity: ItemRarity.common,
      basePrice: 10,
      iconAsset: 'assets/icons/items/snack.png',
      effects: {'hunger': 15.0, 'happiness': 2.0},
    ));
    
    _register(const ItemDefinition(
      id: 'food_meal',
      name: 'Hearty Meal',
      description: 'A filling meal for your pet',
      category: ItemCategory.food,
      rarity: ItemRarity.common,
      basePrice: 25,
      iconAsset: 'assets/icons/items/meal.png',
      effects: {'hunger': 35.0, 'happiness': 5.0, 'energy': 5.0},
    ));
    
    _register(const ItemDefinition(
      id: 'food_gourmet',
      name: 'Gourmet Feast',
      description: 'A luxurious feast fit for royalty',
      category: ItemCategory.food,
      rarity: ItemRarity.uncommon,
      basePrice: 50,
      iconAsset: 'assets/icons/items/gourmet.png',
      effects: {'hunger': 50.0, 'happiness': 15.0, 'energy': 10.0, 'affection': 5.0},
    ));
    
    _register(const ItemDefinition(
      id: 'food_radio_bites',
      name: 'Radio Bites',
      description: 'Special treats infused with radio waves',
      category: ItemCategory.food,
      rarity: ItemRarity.rare,
      basePrice: 100,
      iconAsset: 'assets/icons/items/radio_bites.png',
      effects: {'hunger': 40.0, 'happiness': 25.0, 'affection': 10.0},
    ));
  }
  
  void _registerToys() {
    _register(const ItemDefinition(
      id: 'toy_ball',
      name: 'Bouncy Ball',
      description: 'A simple ball for playtime',
      category: ItemCategory.toy,
      rarity: ItemRarity.common,
      basePrice: 15,
      iconAsset: 'assets/icons/items/ball.png',
      effects: {'happiness': 10.0, 'energy': -5.0, 'affection': 3.0},
    ));
    
    _register(const ItemDefinition(
      id: 'toy_puzzle',
      name: 'Puzzle Box',
      description: 'A brain-teasing puzzle toy',
      category: ItemCategory.toy,
      rarity: ItemRarity.uncommon,
      basePrice: 40,
      iconAsset: 'assets/icons/items/puzzle.png',
      effects: {'happiness': 20.0, 'energy': -10.0, 'affection': 8.0},
    ));
    
    _register(const ItemDefinition(
      id: 'toy_radio',
      name: 'Mini Radio',
      description: 'A tiny radio that plays music',
      category: ItemCategory.toy,
      rarity: ItemRarity.rare,
      basePrice: 80,
      iconAsset: 'assets/icons/items/mini_radio.png',
      effects: {'happiness': 30.0, 'stress': -15.0, 'affection': 10.0},
    ));
  }
  
  void _registerMedicines() {
    _register(const ItemDefinition(
      id: 'med_bandage',
      name: 'Bandage',
      description: 'Heals minor injuries',
      category: ItemCategory.medicine,
      rarity: ItemRarity.common,
      basePrice: 20,
      iconAsset: 'assets/icons/items/bandage.png',
      effects: {'health': 15.0},
    ));
    
    _register(const ItemDefinition(
      id: 'med_vitamin',
      name: 'Vitamin Pack',
      description: 'Boosts overall health',
      category: ItemCategory.medicine,
      rarity: ItemRarity.uncommon,
      basePrice: 35,
      iconAsset: 'assets/icons/items/vitamin.png',
      effects: {'health': 25.0, 'energy': 10.0},
    ));
    
    _register(const ItemDefinition(
      id: 'med_elixir',
      name: 'Health Elixir',
      description: 'Powerful healing potion',
      category: ItemCategory.medicine,
      rarity: ItemRarity.rare,
      basePrice: 75,
      iconAsset: 'assets/icons/items/elixir.png',
      effects: {'health': 50.0, 'energy': 20.0, 'stress': -10.0},
    ));
  }
  
  void _registerSpecials() {
    _register(const ItemDefinition(
      id: 'special_star',
      name: 'Lucky Star',
      description: 'A magical star that brings happiness',
      category: ItemCategory.special,
      rarity: ItemRarity.epic,
      basePrice: 200,
      iconAsset: 'assets/icons/items/star.png',
      effects: {'happiness': 50.0, 'affection': 25.0},
    ));
    
    _register(const ItemDefinition(
      id: 'special_rainbow',
      name: 'Rainbow Crystal',
      description: 'Legendary crystal with amazing powers',
      category: ItemCategory.special,
      rarity: ItemRarity.legendary,
      basePrice: 500,
      iconAsset: 'assets/icons/items/rainbow.png',
      effects: {
        'happiness': 30.0, 
        'energy': 30.0, 
        'health': 30.0, 
        'affection': 20.0, 
        'stress': -20.0,
      },
    ));
  }
  
  void _register(ItemDefinition item) {
    _items[item.id] = item;
  }
  
  /// Get item definition by ID
  ItemDefinition? getItem(String id) => _items[id];
  
  /// Get all items
  List<ItemDefinition> get allItems => _items.values.toList();
  
  /// Get items by category
  List<ItemDefinition> getByCategory(ItemCategory category) {
    return _items.values.where((item) => item.category == category).toList();
  }
  
  /// Get items by rarity
  List<ItemDefinition> getByRarity(ItemRarity rarity) {
    return _items.values.where((item) => item.rarity == rarity).toList();
  }
  
  /// Get all food items
  List<ItemDefinition> get foods => getByCategory(ItemCategory.food);
  
  /// Get all toy items
  List<ItemDefinition> get toys => getByCategory(ItemCategory.toy);
  
  /// Get all medicine items
  List<ItemDefinition> get medicines => getByCategory(ItemCategory.medicine);
  
  /// Get all special items
  List<ItemDefinition> get specials => getByCategory(ItemCategory.special);
}
