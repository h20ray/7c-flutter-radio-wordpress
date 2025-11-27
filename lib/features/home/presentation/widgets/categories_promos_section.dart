import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/debug_logger.dart';
import '../bloc/home_bloc.dart';
import 'category_selection_dialog.dart';
import '../../../promos/domain/entities/promo_entity.dart';
import '../../../promos/domain/usecases/get_promos_by_category.dart';

class CategoriesPromosSection extends StatefulWidget {
  const CategoriesPromosSection({super.key});

  @override
  State<CategoriesPromosSection> createState() => _CategoriesPromosSectionState();
}

class _CategoriesPromosSectionState extends State<CategoriesPromosSection> {
  late final GetPromosByCategory getPromosByCategory;
  List<PromoEntity> _promos = [];
  bool _isLoadingPromos = false;

  @override
  void initState() {
    super.initState();
    getPromosByCategory = GetIt.instance<GetPromosByCategory>();
    _loadPromos(null);
  }

  void _loadPromos(int? categoryId) {
    setState(() {
      _isLoadingPromos = true;
    });

    getPromosByCategory(categoryId).then((result) {
      result.fold(
        (failure) {
          setState(() {
            _isLoadingPromos = false;
            _promos = [];
          });
        },
        (promos) {
          setState(() {
            _isLoadingPromos = false;
            _promos = promos;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final promoTokens = PromoChipTokens.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) {
        return previous != current;
      },
      builder: (context, state) {
            DebugLogger.log('CategoriesPromosSection: Building with state: ${state.runtimeType}', tag: 'CategoriesPromosSection');
            return state.maybeWhen(
          loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError,
              availableCategories, filterChipCategories, selectedCategoryId) {
            DebugLogger.log('CategoriesPromosSection: loaded state - filterChipCategories: ${filterChipCategories.length}, availableCategories: ${availableCategories.length}', tag: 'CategoriesPromosSection');
            
            if (selectedCategoryId != null && _promos.isEmpty && !_isLoadingPromos) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadPromos(selectedCategoryId);
              });
            }

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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CategorySelectionDialog(
                              categories: availableCategories,
                              selectedCategoryId: selectedCategoryId,
                              onCategorySelected: (categoryId) {
                                context.read<HomeBloc>().add(
                                      HomeEvent.categorySelected(categoryId),
                                    );
                                _loadPromos(categoryId);
                              },
                            ),
                          );
                        },
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
                if (filterChipCategories.isNotEmpty)
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                      itemCount: filterChipCategories.length,
            itemBuilder: (context, index) {
                        final category = filterChipCategories[index];
                        final isSelected = selectedCategoryId == category.id;
              return Padding(
                padding: EdgeInsets.only(right: DesignTokens.spacingS),
                child: FilterChip(
                  selected: isSelected,
                            label: Text(category.name),
                  onSelected: (selected) {
                              final newCategoryId = isSelected ? null : category.id;
                              context.read<HomeBloc>().add(
                                    HomeEvent.categorySelected(newCategoryId),
                                  );
                              _loadPromos(newCategoryId);
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
                if (filterChipCategories.isNotEmpty)
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
                if (_isLoadingPromos)
                  Padding(
                    padding: EdgeInsets.all(DesignTokens.spacingXl),
                    child: Center(
                      child: CircularProgressIndicator(color: colors.gradientStart),
                    ),
                  )
                else if (_promos.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(DesignTokens.spacingXl),
                    child: Center(
                      child: Text(
                        'No promos available',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: DesignTokens.fontSizeBody,
                        ),
                      ),
                    ),
                  )
                else
                  ..._promos.map(
          (promo) => _buildPromoCard(context, promo, promoTokens),
        ),
      ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildPromoCard(
    BuildContext context,
    PromoEntity promo,
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
                    child: CachedNetworkImage(
                      imageUrl: promo.thumbnailUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: colors.borderSubtle,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.gradientStart,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported,
                        color: colors.textSecondary,
                      ),
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
                    '${promo.categoryName ?? ""} • ${promo.time ?? ""}',
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
