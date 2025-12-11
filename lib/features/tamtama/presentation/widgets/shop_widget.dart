import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../domain/services/item_catalog.dart';
import '../bloc/inventory/inventory_bloc.dart';

/// Shop screen for purchasing items
class ShopWidget extends StatefulWidget {
  final int currentCoins;
  final VoidCallback? onClose;
  
  const ShopWidget({
    super.key,
    required this.currentCoins,
    this.onClose,
  });

  @override
  State<ShopWidget> createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    
    return Container(
      decoration: BoxDecoration(
        color: colors.primaryBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DesignTokens.cornerRadiusPill),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, colors),
          _buildTabBar(colors),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ShopCategoryList(
                  category: ItemCategory.food,
                  currentCoins: widget.currentCoins,
                ),
                _ShopCategoryList(
                  category: ItemCategory.toy,
                  currentCoins: widget.currentCoins,
                ),
                _ShopCategoryList(
                  category: ItemCategory.medicine,
                  currentCoins: widget.currentCoins,
                ),
                _ShopCategoryList(
                  category: ItemCategory.special,
                  currentCoins: widget.currentCoins,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'shop_title'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH1,
              fontWeight: DesignTokens.fontWeightH1,
              color: colors.textPrimary,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.currentCoins}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary),
                onPressed: widget.onClose,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(AppSemanticColors colors) {
    return TabBar(
      controller: _tabController,
      labelColor: colors.colorScheme.primary,
      unselectedLabelColor: colors.textSecondary,
      indicatorColor: colors.colorScheme.primary,
      tabs: [
        Tab(icon: const Icon(Icons.restaurant), text: 'food'.tr()),
        Tab(icon: const Icon(Icons.games), text: 'toys'.tr()),
        Tab(icon: const Icon(Icons.medical_services), text: 'medicine'.tr()),
        Tab(icon: const Icon(Icons.auto_awesome), text: 'special'.tr()),
      ],
    );
  }
}

class _ShopCategoryList extends StatelessWidget {
  final ItemCategory category;
  final int currentCoins;
  
  const _ShopCategoryList({
    required this.category,
    required this.currentCoins,
  });

  @override
  Widget build(BuildContext context) {
    final items = ItemCatalog.instance.getByCategory(category);
    final colors = context.appColors;
    
    if (items.isEmpty) {
      return Center(
        child: Text(
          'no_items_available'.tr(),
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ShopItemCard(
          item: items[index],
          currentCoins: currentCoins,
        );
      },
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final ItemDefinition item;
  final int currentCoins;
  
  const _ShopItemCard({
    required this.item,
    required this.currentCoins,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canAfford = currentCoins >= item.basePrice;
    
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingS),
      color: colors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        child: Row(
          children: [
            // Item icon placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(item.category),
                color: _getRarityColor(item.rarity),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _RarityBadge(rarity: item.rarity),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildEffects(colors),
                ],
              ),
            ),
            // Buy button
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, size: 16, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      '${item.basePrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: canAfford ? colors.textPrimary : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: canAfford
                      ? () => _purchaseItem(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.colorScheme.primary,
                    foregroundColor: colors.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'buy'.tr(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEffects(AppSemanticColors colors) {
    if (item.effects.isEmpty) return const SizedBox.shrink();
    
    final effectsText = item.effects.entries
        .map((e) => '${e.key}: ${e.value > 0 ? '+' : ''}${e.value.toInt()}')
        .join(' • ');
    
    return Text(
      effectsText,
      style: TextStyle(
        fontSize: 10,
        color: colors.colorScheme.tertiary,
      ),
    );
  }
  
  void _purchaseItem(BuildContext context) {
    context.read<InventoryBloc>().add(
      InventoryEvent.purchase(
        itemId: item.id,
        currentCoins: currentCoins,
      ),
    );
  }
  
  IconData _getCategoryIcon(ItemCategory category) {
    switch (category) {
      case ItemCategory.food:
        return Icons.restaurant;
      case ItemCategory.toy:
        return Icons.games;
      case ItemCategory.medicine:
        return Icons.medical_services;
      case ItemCategory.special:
        return Icons.auto_awesome;
    }
  }
  
  Color _getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }
}

class _RarityBadge extends StatelessWidget {
  final ItemRarity rarity;
  
  const _RarityBadge({required this.rarity});

  @override
  Widget build(BuildContext context) {
    if (rarity == ItemRarity.common) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: _getColor(),
        ),
      ),
    );
  }
  
  String _getLabel() {
    switch (rarity) {
      case ItemRarity.common:
        return '';
      case ItemRarity.uncommon:
        return 'UC';
      case ItemRarity.rare:
        return 'R';
      case ItemRarity.epic:
        return 'E';
      case ItemRarity.legendary:
        return 'L';
    }
  }
  
  Color _getColor() {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }
}
