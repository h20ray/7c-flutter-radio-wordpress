import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../themes/app_color_system.dart';
import '../themes/design_tokens.dart';

class CollapsibleSettingsSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const CollapsibleSettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<CollapsibleSettingsSection> createState() =>
      _CollapsibleSettingsSectionState();
}

class _CollapsibleSettingsSectionState
    extends State<CollapsibleSettingsSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: DesignTokens.animationDurationMedium,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: DesignTokens.animationCurveDefault,
      ),
    );
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: DesignTokens.elevationCard * 2,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DesignTokens.cornerRadiusCard),
                topRight: Radius.circular(DesignTokens.cornerRadiusCard),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: DesignTokens.spacingXl,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: colors.colorScheme.primary,
                      size: DimensionTokens.iconSizeLarge,
                    ),
                    const SizedBox(width: DesignTokens.spacingL),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeTitleLarge,
                          fontWeight: DesignTokens.fontWeightTitleLarge,
                          letterSpacing: DesignTokens.letterSpacingTitleLarge,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Icon(
                        LucideIcons.chevron_down,
                        color: colors.textSecondary,
                        size: DimensionTokens.iconSizeMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: DesignTokens.animationDurationMedium,
            curve: DesignTokens.animationCurveDefault,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(
                        height: DimensionTokens.dividerThickness,
                        thickness: DimensionTokens.dividerThickness,
                      ),
                      widget.child,
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

