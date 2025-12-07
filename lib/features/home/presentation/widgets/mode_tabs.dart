import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';

class ModeTabs extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const ModeTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  State<ModeTabs> createState() => _ModeTabsState();
}

class _ModeTabsState extends State<ModeTabs>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: DesignTokens.animationDurationMedium,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(ModeTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'home_tab_radio'.tr(),
      'home_tab_news'.tr(),
      'home_tab_podcasts'.tr(),
    ];

    final tokens = ModeTabsTokens.of(context);

    return Container(
      margin: const EdgeInsets.only(
        top: 0,
        left: DesignTokens.spacingL,
        right: DesignTokens.spacingL,
      ),
      height: 44,
      decoration: BoxDecoration(
        color: tokens.container,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: tokens.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (index) {
          final isSelected = widget.selectedIndex == index;
          return Expanded(
            child: HapticGestureDetector(
              hapticType: HapticFeedbackType.selectionClick,
              onTap: () => widget.onTabChanged(index),
              child: AnimatedContainer(
                duration: DesignTokens.animationDurationMedium,
                curve: DesignTokens.animationCurveSpring,
                height: 36,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? tokens.selectedBackground
                      : tokens.unselectedBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeBody,
                      fontWeight: isSelected
                          ? DesignTokens.fontWeightH2
                          : FontWeight.w500,
                      color: isSelected
                          ? tokens.selectedText
                          : tokens.unselectedText,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
