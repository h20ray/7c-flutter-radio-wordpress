import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/song_history_bloc.dart';
import '../widgets/song_history_item.dart';

class SongHistoryPage extends StatelessWidget {
  const SongHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<SongHistoryBloc>();
    if (bloc.state == const SongHistoryState.initial()) {
      bloc.add(const SongHistoryEvent.load());
    }

    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('song_history_title'.tr()),
        ),
        body: BlocBuilder<SongHistoryBloc, SongHistoryState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const _SongHistoryLoadingState(),
              loaded: (songs) {
                if (songs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        SizedBox(height: DesignTokens.spacingL),
                        Text(
                          'song_history_empty'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(DesignTokens.spacingL),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return SongHistoryItem(song: songs[index]);
                  },
                );
              },
              error: (failure) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(height: DesignTokens.spacingL),
                    Text(
                      failure.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: DesignTokens.spacingM),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SongHistoryBloc>().add(const SongHistoryEvent.load());
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SongHistoryLoadingState extends StatelessWidget {
  const _SongHistoryLoadingState();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = colors.surfaces.surfaceContainerHighest;
    final shadow = AppShadowTokens.elevation2(context);

    return ListView.builder(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
          padding: EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
            boxShadow: shadow,
          ),
          child: Row(
            children: [
              ShimmerContainer(
                width: 60,
                height: 60,
                borderRadius: DesignTokens.cornerRadiusCard,
                baseColor: skeletonColor.withValues(alpha: 0.3),
                highlightColor: skeletonColor.withValues(alpha: 0.5),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    ShimmerContainer(
                      width: 150,
                      height: 14,
                      borderRadius: 4,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    ShimmerContainer(
                      width: 80,
                      height: 12,
                      borderRadius: 4,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

