import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../radio/presentation/bloc/radio_player_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'profile_page_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final radioPlayerBloc = getIt<RadioPlayerBloc>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        unawaited(Navigator.pushReplacementNamed(context, AppRoutes.home));
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RadioPlayerBloc>.value(value: radioPlayerBloc),
          BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
        ],
        child: const ProfilePageView(),
      ),
    );
  }
}

