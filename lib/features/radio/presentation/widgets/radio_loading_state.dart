import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Loading state widget for radio page
class RadioLoadingState extends StatelessWidget {
  const RadioLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'radio_initializing'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

