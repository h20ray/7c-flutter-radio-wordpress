import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../radio/presentation/bloc/radio_player_bloc.dart';
import '../bloc/wordpress_bloc.dart';
import 'news_page_view.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wordPressBloc = getIt<WordPressBloc>();
    final radioPlayerBloc = getIt<RadioPlayerBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<WordPressBloc>.value(value: wordPressBloc),
        BlocProvider<RadioPlayerBloc>.value(value: radioPlayerBloc),
      ],
      child: const NewsPageView(),
    );
  }
}

