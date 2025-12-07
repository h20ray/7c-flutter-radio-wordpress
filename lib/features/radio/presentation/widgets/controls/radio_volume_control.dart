import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/services/system_volume_service.dart';

/// M3 Expressive volume control widget.
/// Displays a volume slider with mute/unmute toggle following Material Design 3 guidelines.
class RadioVolumeControl extends StatefulWidget {
  const RadioVolumeControl({super.key});

  @override
  State<RadioVolumeControl> createState() => _RadioVolumeControlState();
}

class _RadioVolumeControlState extends State<RadioVolumeControl> {
  double _volume = 1.0;
  StreamSubscription<double>? _volumeSub;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _initVolume();
  }

  void _initVolume() {
    final svc = getIt<SystemVolumeService>()..ensureInitialized();
    svc.getVolume().then((v) {
      if (mounted) setState(() => _volume = v);
    });
    _volumeSub = svc.volumeStream.listen((v) {
      if (mounted && !_isDragging && (v - _volume).abs() > 0.01) {
        setState(() => _volume = v);
      }
    });
  }

  @override
  void dispose() {
    _volumeSub?.cancel();
    super.dispose();
  }

  void _setVolume(double v) {
    getIt<SystemVolumeService>().setVolume(v);
  }

  void _toggleMute() {
    HapticFeedback.lightImpact();
    final newVolume = _volume == 0 ? 0.5 : 0.0;
    setState(() => _volume = newVolume);
    _setVolume(newVolume);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isMuted = _volume == 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: _toggleMute,
                icon: Icon(
                  isMuted ? LucideIcons.volume_x : LucideIcons.volume_2,
                  size: 22,
                  color: cs.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volume',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isMuted ? 'Muted' : '${(_volume * 100).round()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Volume slider
        _VolumeSlider(
          value: _volume,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            setState(() => _volume = v);
          },
          onChangeStart: () => _isDragging = true,
          onChangeEnd: (v) {
            _isDragging = false;
            _setVolume(v);
          },
        ),
      ],
    );
  }
}

/// Extracted slider widget with M3 styling.
class _VolumeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback onChangeStart;
  final ValueChanged<double> onChangeEnd;

  const _VolumeSlider({
    required this.value,
    required this.onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
          elevation: 2,
          pressedElevation: 4,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        trackShape: const RoundedRectSliderTrackShape(),
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.surfaceContainerHighest,
        thumbColor: cs.primary,
        overlayColor: cs.primary.withValues(alpha: 0.12),
        valueIndicatorColor: cs.inverseSurface,
        valueIndicatorTextStyle: TextStyle(
          color: cs.onInverseSurface,
          fontWeight: FontWeight.w500,
        ),
        showValueIndicator: ShowValueIndicator.onDrag,
      ),
      child: Slider(
        value: value.clamp(0.0, 1.0),
        onChanged: onChanged,
        onChangeStart: (_) => onChangeStart(),
        onChangeEnd: onChangeEnd,
        divisions: 20,
        label: '${(value * 100).round()}%',
      ),
    );
  }
}
