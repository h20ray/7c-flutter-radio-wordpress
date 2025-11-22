import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/services/system_volume_service.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';
import '../bloc/radio_player_event.dart';
import 'm3_volume_bar.dart';

/// Bottom controls bar with play/pause button and volume slider
/// Material 3 design with proper spacing and touch targets
class RadioPlayerControls extends StatefulWidget {
  const RadioPlayerControls({super.key});

  @override
  State<RadioPlayerControls> createState() => _RadioPlayerControlsState();
}

class _RadioPlayerControlsState extends State<RadioPlayerControls> {
  final SystemVolumeService _volumeService = SystemVolumeService();
  double _currentVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _volumeService.ensureInitialized();
    _loadVolume();
    _volumeService.volumeStream.listen((volume) {
      if (mounted) {
        setState(() {
          _currentVolume = volume;
        });
      }
    });
  }

  Future<void> _loadVolume() async {
    final volume = await _volumeService.getVolume();
    if (mounted) {
      setState(() {
        _currentVolume = volume;
      });
    }
  }

  void _handlePlayPause() {
    context.read<RadioPlayerBloc>().add(const RadioPlayerEvent.togglePlayPause());
  }

  void _handleVolumeChange(double volume) {
    _volumeService.setVolume(volume);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              M3VolumeBar(
                value: _currentVolume,
                onChanged: _handleVolumeChange,
                height: 4,
                steps: 21,
                enableHaptics: true,
              ),
              const SizedBox(height: 16),
              BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
                buildWhen: (previous, current) {
                  return previous.maybeWhen(
                    ready: (prevPlaying, _, __, ___, ____, _____, ______) => current.maybeWhen(
                      ready: (currPlaying, _, __, ___, ____, _____, ______) =>
                          prevPlaying != currPlaying,
                      orElse: () => true,
                    ),
                    orElse: () => true,
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    ready: (isPlaying, _, __, ___, ____, _____, ______) => _buildPlayPauseButton(
                      context,
                      isPlaying,
                    ),
                    retrying: (attempt, reason) => _buildLoadingButton(context),
                    connecting: () => _buildLoadingButton(context),
                    buffering: () => _buildLoadingButton(context),
                    initializing: () => _buildLoadingButton(context),
                    orElse: () => _buildPlayPauseButton(context, false),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton(BuildContext context, bool isPlaying) {
    return FilledButton.icon(
      onPressed: _handlePlayPause,
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      label: Text(isPlaying ? 'radio_pause'.tr() : 'radio_play'.tr()),
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }

  Widget _buildLoadingButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: null,
      icon: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
      label: Text('radio_please_wait'.tr()),
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}

