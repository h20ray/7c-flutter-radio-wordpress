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
            if (radioEntity.banners.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No banners configured',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              );
            }
            return RadioBannerWidget(banners: radioEntity.banners);
          },
          orElse: () => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

