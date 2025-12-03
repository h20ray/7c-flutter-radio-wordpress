import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';

class RadioGameTabs extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const RadioGameTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<RadioGameTabs> createState() => _RadioGameTabsState();
}

class _RadioGameTabsState extends State<RadioGameTabs>
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
  void didUpdateWidget(RadioGameTabs oldWidget) {
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
      'home_radio_game_tab_radio_streaming'.tr(),
      'home_radio_game_tab_status'.tr(),
    ];

    final tokens = RadioGameTabsTokens.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Container(
        height: 28,
        decoration: BoxDecoration(
          color: tokens.container,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: tokens.shadow,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final isSelected = widget.selectedIndex == index;
            return Expanded(
              child: HapticGestureDetector(
                hapticType: HapticFeedbackType.selectionClick,
                onTap: () => widget.onChanged(index),
                child: AnimatedContainer(
                  duration: DesignTokens.animationDurationMedium,
                  curve: DesignTokens.animationCurveSpring,
                  height: 22,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tokens.selectedBackground
                        : tokens.unselectedBackground,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
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
      ),
    );
  }
}
