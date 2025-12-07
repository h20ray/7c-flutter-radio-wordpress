import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../config/game_radio_time_config.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../bloc/gamification_bloc.dart';
import '../viewmodels/gamification_status_view_data.dart';
import '../widgets/level_details/current_level_section.dart';
import '../widgets/level_details/level_details_error_state.dart';
import '../widgets/level_details/level_details_loading_state.dart';
import '../widgets/level_details/level_list_section.dart';

class LevelDetailsPageView extends StatelessWidget {
  const LevelDetailsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: colors.primaryBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrow_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'level_details_title'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<GamificationBloc, GamificationState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const LevelDetailsLoadingState(),
                  error: (failure) => LevelDetailsErrorState(
                    failure: failure,
                    onRetry: () {
                      context.read<GamificationBloc>().add(
                            const GamificationEvent.started(),
                          );
                    },
                  ),
                  loaded: (data) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CurrentLevelSection(data: data),
                      const SizedBox(height: DesignTokens.spacingXl),
                      LevelListSection(
                        currentHours: data.totalListeningHours,
                        currentLevelId: _getCurrentLevelId(data),
                      ),
                      const SizedBox(height: DesignTokens.spacingXl),
                    ],
                  ),
                  orElse: () => const LevelDetailsLoadingState(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentLevelId(GamificationStatusViewData data) {
    final currentLevel = GameRadioTimeConfig.resolveByHours(
      data.totalListeningHours,
    );
    return currentLevel.id;
  }
}

