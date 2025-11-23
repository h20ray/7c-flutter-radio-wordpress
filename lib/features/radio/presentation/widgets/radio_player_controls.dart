import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/system_volume_service.dart';
import '../../../../config/radio_config.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';
import '../bloc/radio_player_event.dart';
import 'm3_volume_bar.dart';

class RadioPlayerControls extends StatefulWidget {
  const RadioPlayerControls({super.key});

  @override
  State<RadioPlayerControls> createState() => _RadioPlayerControlsState();
}

class _RadioPlayerControlsState extends State<RadioPlayerControls> {
  double _volume = 1.0;
  StreamSubscription<double>? _sysSub;
  Timer? _debounce;
  bool _isMuted = false;
  double _volumeBeforeMute = 1.0;
  bool _isSettingVolume = false;

  @override
  void initState() {
    super.initState();
    final sys = getIt<SystemVolumeService>();
    sys.ensureInitialized();
    sys.getVolume().then((v) => mounted ? setState(() => _volume = v) : null);
    _sysSub = sys.volumeStream.listen((v) {
      if (!mounted || _isSettingVolume) return;

      if ((v - _volume).abs() > 0.01) {
        setState(() {
          _volume = v;
          if (v == 0 && !_isMuted) {
            _isMuted = true;
            _volumeBeforeMute = 0.5;
          } else if (v > 0 && _isMuted) {
            _isMuted = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _sysSub?.cancel();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _volume = _volumeBeforeMute;
        _isMuted = false;
        _isSettingVolume = true;
        getIt<SystemVolumeService>().setVolume(_volume);
      } else {
        _volumeBeforeMute = _volume;
        _volume = 0.0;
        _isMuted = true;
        _isSettingVolume = true;
        getIt<SystemVolumeService>().setVolume(0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 120),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _toggleMute,
                      icon: Icon(
                        _isMuted || _volume == 0
                            ? Icons.volume_off
                            : _volume < 0.5
                                ? Icons.volume_down
                                : Icons.volume_up,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                      tooltip: _isMuted ? 'Unmute' : 'Mute',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    Expanded(
                      child: M3VolumeBar(
                        value: _volume,
                        onChanged: (v) {
                          setState(() => _volume = v);
                          _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 80), () {
                            _isSettingVolume = true;
                            getIt<SystemVolumeService>().setVolume(v);
                            Timer(const Duration(milliseconds: 100), () {
                              if (mounted) _isSettingVolume = false;
                            });
                          });
                        },
                        steps: 21,
                        enableHaptics: true,
                        wavyActive: true,
                        waveStrength: 0.35,
                        height: 3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _RequestWebViewPage(),
                        ),
                      );
                    },
                    iconSize: 28,
                    icon: const Icon(Icons.featured_play_list_outlined),
                    tooltip: RadioConfig.requestWebViewTitle,
                  ),
                  BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
                    builder: (context, state) {
                      bool isPlaying = false;
                      bool isLoading = false;
                      state.maybeWhen(
                        initializing: () => isLoading = true,
                        connecting: () => isLoading = true,
                        buffering: () => isLoading = true,
                        retrying: (p1, p2) => isLoading = true,
                        ready: (playing, p2, p3, p4, p5, p6, p7) =>
                            isPlaying = playing,
                        orElse: () {},
                      );
                      return Semantics(
                        label: isPlaying ? 'radio_pause'.tr() : 'radio_play'.tr(),
                        button: true,
                        child: ElevatedButton(
                          onPressed: () => context
                              .read<RadioPlayerBloc>()
                              .add(const RadioPlayerEvent.togglePlayPause()),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(120, 48),
                            padding: EdgeInsets.zero,
                            shape: const StadiumBorder(),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            child: isLoading
                                ? const SizedBox(
                                    key: ValueKey('center-buf'),
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    key: const ValueKey('center-pp'),
                                    size: 32,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.shoutbox);
                    },
                    iconSize: 28,
                    icon: const Icon(Icons.chat_bubble_outline),
                    tooltip: 'Shoutbox',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RadioConfig.requestWebViewTitle),
      ),
      body: Center(
        child: Text('WebView implementation needed for: ${RadioConfig.requestWebViewUrl}'),
      ),
    );
  }
}
