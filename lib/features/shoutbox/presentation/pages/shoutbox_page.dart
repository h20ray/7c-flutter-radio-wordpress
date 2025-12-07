import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../radio/presentation/bloc/radio_player_bloc.dart';
import '../bloc/shoutbox_bloc.dart';
import 'shoutbox_page_view.dart';

class ShoutboxPage extends StatelessWidget {
  const ShoutboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShoutboxBloc>.value(value: getIt<ShoutboxBloc>()),
        BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
        BlocProvider<RadioPlayerBloc>.value(value: getIt<RadioPlayerBloc>()),
      ],
      child: const ShoutboxPageView(),
    );
  }
}
