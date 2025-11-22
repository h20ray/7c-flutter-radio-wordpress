import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_player_bloc.dart';
import 'radio_page_view.dart';

/// Main entry point for the Radio Page
/// Provides BLoC instances and delegates to RadioPageView
class RadioPage extends StatelessWidget {
  const RadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final radioBloc = getIt<RadioBloc>();
    final radioPlayerBloc = getIt<RadioPlayerBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<RadioBloc>.value(value: radioBloc),
        BlocProvider<RadioPlayerBloc>.value(value: radioPlayerBloc),
      ],
      child: const RadioPageView(),
    );
  }
}
