import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/inventory_entity.dart';
import '../bloc/inventory/inventory_bloc.dart';

/// Widget displaying the player's inventory
class InventoryWidget extends StatelessWidget {
  final VoidCallback? onItemTapped;
  
  const InventoryWidget({
    super.key,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (inventory) => _buildInventory(context, inventory),
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildInventory(BuildContext context, InventoryEntity inventory) {
    final colors = context.appColors;
    
    if (inventory.items.isEmpty) {
      return Center(
        child: Text(
          'inventory_empty'.tr(),
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'inventory'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH2,
                  fontWeight: DesignTokens.fontWeightH2,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${inventory.uniqueItemCount} ${'items'.tr()}',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingS),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
            itemCount: inventory.items.length,
            itemBuilder: (context, index) {
              final item = inventory.items.values.toList()[index];
              return _InventoryItemTile(
                item: item,
                onTap: () {
                  context.read<InventoryBloc>().add(
                    InventoryEvent.useItem(item.id),
                  );
                  onItemTapped?.call();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InventoryItemTile extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback? onTap;
  
  const _InventoryItemTile({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: DesignTokens.spacingS),
        padding: const EdgeInsets.all(DesignTokens.spacingS),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  _getCategoryIcon(),
                  color: colors.colorScheme.primary,
                  size: 28,
                ),
                if (item.quantity > 1)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: colors.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colors.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 10,
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getCategoryIcon() {
    switch (item.category) {
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
}
