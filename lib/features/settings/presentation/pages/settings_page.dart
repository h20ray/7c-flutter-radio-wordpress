import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../radio/presentation/bloc/radio_player_bloc.dart';
import '../bloc/settings_bloc.dart';
import 'settings_page_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final radioPlayerBloc = getIt<RadioPlayerBloc>();
    final settingsBloc = getIt<SettingsBloc>();
    final authBloc = getIt<AuthBloc>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RadioPlayerBloc>.value(value: radioPlayerBloc),
          BlocProvider<SettingsBloc>.value(value: settingsBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: const SettingsPageView(),
      ),
    );
  }
}

