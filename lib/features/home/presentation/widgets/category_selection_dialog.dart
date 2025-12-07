import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../categories/domain/entities/category_entity.dart';

class CategorySelectionDialog extends StatefulWidget {
  final List<CategoryEntity> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const CategorySelectionDialog({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelectionDialog> createState() => _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  late List<CategoryEntity> _filteredCategories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCategories = widget.categories;
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCategories);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = widget.categories;
      } else {
        _filteredCategories = widget.categories
            .where((category) =>
                category.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(DesignTokens.spacingL),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                  filled: true,
                  fillColor: colors.borderSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingM,
                    vertical: DesignTokens.spacingS,
                  ),
                ),
              ),
            ),
            SizedBox(height: DesignTokens.spacingM),
            Flexible(
              child: _filteredCategories.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(DesignTokens.spacingXl),
                        child: Text(
                          'No categories found',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: DesignTokens.fontSizeBody,
                          ),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(DesignTokens.spacingL),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: DesignTokens.spacingM,
                        mainAxisSpacing: DesignTokens.spacingM,
                      ),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = _filteredCategories[index];
                        final isSelected = widget.selectedCategoryId == category.id;

                        return _buildCategoryCard(
                          context,
                          category,
                          isSelected,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryEntity category,
    bool isSelected,
  ) {
    final colors = context.appColors;
    return InkWell(
      onTap: () {
        widget.onCategorySelected(isSelected ? null : category.id);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.gradientStart.withValues(alpha: 0.2)
              : colors.borderSubtle,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          border: Border.all(
            color: isSelected ? colors.gradientStart : colors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category.thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: category.thumbnailUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: colors.borderSubtle,
                    child: Icon(Icons.image, color: colors.textSecondary),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: colors.borderSubtle,
                    child: Icon(Icons.image_not_supported, color: colors.textSecondary),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colors.gradientStart.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category,
                  color: colors.gradientStart,
                  size: 30,
                ),
              ),
            SizedBox(height: DesignTokens.spacingS),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBody,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? colors.gradientStart : colors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(top: DesignTokens.spacingXs),
                child: Icon(
                  Icons.check_circle,
                  color: colors.gradientStart,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

