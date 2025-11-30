import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/system_volume_service.dart';
import 'm3_volume_bar.dart';

class VolumeDialog extends StatefulWidget {
  const VolumeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const VolumeDialog(),
    );
  }

  @override
  State<VolumeDialog> createState() => _VolumeDialogState();
}

class _VolumeDialogState extends State<VolumeDialog> {
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Volume',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    _isMuted || _volume == 0
                        ? LucideIcons.volume_x
                        : _volume < 0.5
                            ? LucideIcons.volume_1
                            : LucideIcons.volume_2,
                    color: theme.colorScheme.onSurface,
                  ),
                  tooltip: _isMuted ? 'Unmute' : 'Mute',
                  style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 16),
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
                    height: 6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${(_volume * 100).round()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

