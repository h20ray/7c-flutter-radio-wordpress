import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/error/failures.dart';
import '../bloc/radio_bloc.dart';

/// Error state widget for radio configuration errors
class RadioErrorState extends StatelessWidget {
  final Failure failure;

  const RadioErrorState({
    super.key,
    required this.failure,
  });

  String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'radio_network_error'.tr();
    } else if (failure is ServerFailure) {
      return 'radio_server_error'.tr();
    } else if (failure is TimeoutFailure) {
      return 'radio_timeout_error'.tr();
    } else {
      return 'radio_unknown_error'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'radio_error_title'.tr(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(failure),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<RadioBloc>().add(RadioEvent.getRadioConfig());
              },
              icon: const Icon(Icons.refresh),
              label: Text('radio_retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

