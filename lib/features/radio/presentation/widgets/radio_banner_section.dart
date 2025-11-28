import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/radio_bloc.dart';
import 'radio_banner_widget.dart';

/// Banner section displaying radio banners in 5:4 aspect ratio
class RadioBannerSection extends StatelessWidget {
  const RadioBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioBloc, RadioState>(
      buildWhen: (previous, current) {
        return previous.maybeWhen(
          loaded: (prevConfig) => current.maybeWhen(
            loaded: (currConfig) => prevConfig.banners != currConfig.banners,
            orElse: () => true,
          ),
          orElse: () => true,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (radioEntity) {
            return RadioBannerWidget(banners: radioEntity.banners);
          },
          orElse: () => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

