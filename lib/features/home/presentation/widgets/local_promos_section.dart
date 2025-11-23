import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
                  color: DesignTokens.colorTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'home_promos_see_all'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    color: DesignTokens.colorHeaderGradientStart,
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
                  selectedColor: DesignTokens.colorHeaderGradientStart,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: DesignTokens.fontSizeBody,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : DesignTokens.colorTextPrimary,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? DesignTokens.colorHeaderGradientStart
                        : DesignTokens.colorBorderSubtle,
                  ),
                  backgroundColor: DesignTokens.colorCard,
                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
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
                  color: DesignTokens.colorTextPrimary,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                LucideIcons.map_pin,
                size: 16,
                color: DesignTokens.colorTextSecondary,
              ),
              SizedBox(width: 4),
              Text(
                'Semarang',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: DesignTokens.colorTextPrimary,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'home_promos_location_change'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    color: DesignTokens.colorHeaderGradientStart,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        ...MockPromoCard.defaultPromos.map((promo) => _buildPromoCard(context, promo)),
      ],
    );
  }

  Widget _buildPromoCard(BuildContext context, MockPromoCard promo) {
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
        color: DesignTokens.colorCard,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              color: DesignTokens.colorBorderSubtle,
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
                : Icon(
                    Icons.image,
                    color: DesignTokens.colorTextSecondary,
                  ),
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
                      color: DesignTokens.colorTextPrimary,
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
                      color: DesignTokens.colorTextSecondary,
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
                            color: DesignTokens.colorSecondaryAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Text(
                              promo.tags.first,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: DesignTokens.colorSecondaryAccent,
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
                              color: DesignTokens.colorTextSecondary,
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
            color: DesignTokens.colorTextSecondary,
          ),
        ],
      ),
    );
  }
}

