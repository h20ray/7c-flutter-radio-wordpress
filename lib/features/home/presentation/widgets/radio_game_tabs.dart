import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/design_tokens.dart';

class RadioGameTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const RadioGameTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ButtonSegment<int>(
        value: 0,
        label: Text(
          'home_radio_game_tab_radio_streaming'.tr(),
        ),
      ),
      ButtonSegment<int>(
        value: 1,
        label: Text(
          'home_radio_game_tab_status'.tr(),
        ),
      ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: SegmentedButton<int>(
        segments: tabs,
        selected: {selectedIndex},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onChanged(selection.first);
          }
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingXs,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        showSelectedIcon: false,
      ),
    );
  }
}

