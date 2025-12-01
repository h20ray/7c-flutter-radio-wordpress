import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/song_history_bloc.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';
import 'song_history_item.dart';

class RadioSongHistorySection extends StatefulWidget {
  const RadioSongHistorySection({super.key});

  @override
  State<RadioSongHistorySection> createState() => _RadioSongHistorySectionState();
}

class _RadioSongHistorySectionState extends State<RadioSongHistorySection> {
  late final SongHistoryBloc _bloc;
  String? _lastArtist;
  String? _lastTitle;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<SongHistoryBloc>();
    if (_bloc.state == const SongHistoryState.initial()) {
      _bloc.add(const SongHistoryEvent.load(limit: 15));
    }
  }

  void _refreshHistory() {
    _bloc.add(const SongHistoryEvent.load(limit: 15));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<RadioPlayerBloc, RadioPlayerState>(
        listenWhen: (previous, current) {
          String? currentArtist;
          String? currentTitle;
          current.maybeWhen(
            ready: (playing, url, artist, title, albumArt, ducking, autoResume) {
              currentArtist = artist;
              currentTitle = title;
            },
            orElse: () {},
          );
          final changed = currentArtist != _lastArtist || currentTitle != _lastTitle;
          if (changed) {
            _lastArtist = currentArtist;
            _lastTitle = currentTitle;
          }
          return changed;
        },
        listener: (context, state) {
          _refreshHistory();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: DesignTokens.spacingM),
              child: Text(
                'song_history_title'.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
            BlocBuilder<SongHistoryBloc, SongHistoryState>(
              buildWhen: (previous, current) {
                // Don't rebuild when switching to loading state if we already have data
                // This prevents the list from disappearing and causing scroll jumps
                if (current.maybeWhen(loading: () => true, orElse: () => false)) {
                  return previous.maybeWhen(
                    loaded: (_) => false,
                    orElse: () => true,
                  );
                }

                return previous.maybeWhen(
                  loaded: (prevSongs) {
                    return current.maybeWhen(
                      loaded: (currSongs) {
                        if (prevSongs.length == currSongs.length) {
                          final prevFirst = prevSongs.isNotEmpty ? prevSongs.first.id : null;
                          final currFirst = currSongs.isNotEmpty ? currSongs.first.id : null;
                          return prevFirst != currFirst;
                        }
                        return true;
                      },
                      orElse: () => true,
                    );
                  },
                  orElse: () => previous != current,
                );
              },
              builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                loaded: (songs) {
                  if (songs.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(DesignTokens.spacingL),
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                        border: Border.all(
                          color: colors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: colors.textSecondary.withValues(alpha: 0.3),
                            ),
                            SizedBox(height: DesignTokens.spacingM),
                            Text(
                              'song_history_empty'.tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final limitedSongs = songs.take(15).toList();

                  return Column(
                    children: limitedSongs.map((song) {
                      return SongHistoryItem(
                        key: ValueKey(song.id),
                        song: song, 
                        showBorder: false,
                      );
                    }).toList(),
                  );
                },
                error: (_) => const SizedBox.shrink(),
              );
            },
            ),
          ],
        ),
      ),
    );
  }
}

