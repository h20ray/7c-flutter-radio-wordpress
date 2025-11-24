import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_promo_card.dart';

class LocalPromosSection extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const LocalPromosSection({
    super.key,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<LocalPromosSection> createState() => _LocalPromosSectionState();
}

class _LocalPromosSectionState extends State<LocalPromosSection> {
  final List<String> _categories = [
    'home_promos_near_you',
    'home_promos_top_news',
    'home_promos_music',
    'home_promos_talk_shows',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final promoTokens = PromoChipTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home_promos_title'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'home_promos_see_all'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    color: colors.gradientStart,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = widget.selectedCategory == category;
              return Padding(
                padding: EdgeInsets.only(right: DesignTokens.spacingS),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(category.tr()),
                  onSelected: (selected) {
                    widget.onCategoryChanged(category);
                  },
                  selectedColor: promoTokens.selectedBackground,
                  checkmarkColor: promoTokens.checkmark,
                  labelStyle: TextStyle(
                    fontSize: DesignTokens.fontSizeBody,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? promoTokens.selectedLabel
                        : promoTokens.unselectedLabel,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? promoTokens.selectedBackground
                        : promoTokens.outline,
                  ),
                  backgroundColor: promoTokens.unselectedBackground,
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            children: [
              Text(
                'home_promos_location_in'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBody,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(width: 4),
              Icon(LucideIcons.map_pin, size: 16, color: colors.textSecondary),
              SizedBox(width: 4),
              Text(
                'Semarang',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'home_promos_location_change'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    color: colors.gradientStart,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        ...MockPromoCard.defaultPromos.map(
          (promo) => _buildPromoCard(context, promo, promoTokens),
        ),
      ],
    );
  }

  Widget _buildPromoCard(
    BuildContext context,
    MockPromoCard promo,
    PromoChipTokens promoTokens,
  ) {
    final colors = context.appColors;

    return Container(
      margin: EdgeInsets.fromLTRB(
        DesignTokens.spacingL,
        DesignTokens.spacingM,
        DesignTokens.spacingL,
        0,
      ),
      height: 88,
      padding: EdgeInsets.all(DesignTokens.spacingS),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: promoTokens.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.borderSubtle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: promo.thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      promo.thumbnailUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.image, color: colors.textSecondary),
          ),
          SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: SizedBox(
              height: 72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    promo.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${promo.category} • ${promo.time ?? ""}',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (promo.tags.isNotEmpty)
                        Container(
                          height: 18,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: colors.secondaryAccent.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Text(
                              promo.tags.first,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: colors.secondaryAccent,
                                height: 1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      if (promo.tags.isNotEmpty && promo.distance != null)
                        SizedBox(width: 4),
                      if (promo.distance != null)
                        Flexible(
                          child: Text(
                            promo.distance!,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Icon(
            LucideIcons.chevron_right,
            size: 20,
            color: colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
