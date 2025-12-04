import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../radio/presentation/bloc/radio_player_bloc.dart';
import '../bloc/wordpress_bloc.dart';
import 'news_page_view.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wordPressBloc = getIt<WordPressBloc>();
    final radioPlayerBloc = getIt<RadioPlayerBloc>();
    final authBloc = getIt<AuthBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<WordPressBloc>.value(value: wordPressBloc),
        BlocProvider<RadioPlayerBloc>.value(value: radioPlayerBloc),
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: const NewsPageView(),
    );
  }
}

