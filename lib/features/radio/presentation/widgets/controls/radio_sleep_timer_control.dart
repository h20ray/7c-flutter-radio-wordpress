import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/services/sleep_timer_service.dart';

/// M3 Expressive sleep timer control widget.
/// Displays a timer toggle, duration slider, and countdown following Material Design 3 guidelines.
class RadioSleepTimerControl extends StatefulWidget {
  const RadioSleepTimerControl({super.key});

  @override
  State<RadioSleepTimerControl> createState() => _RadioSleepTimerControlState();
}

class _RadioSleepTimerControlState extends State<RadioSleepTimerControl> {
  late final SleepTimerService _service;
  StreamSubscription<SleepTimerState>? _stateSub;
  SleepTimerState _state = const SleepTimerState();

  @override
  void initState() {
    super.initState();
    _service = getIt<SleepTimerService>();
    _state = _service.state;
    _stateSub = _service.stateStream.listen((state) {
      if (mounted) setState(() => _state = state);
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    super.dispose();
  }

  void _toggleEnabled(bool enabled) {
    HapticFeedback.mediumImpact();
    _service.setEnabled(enabled);
  }

  void _updateDuration(double normalized) {
    HapticFeedback.selectionClick();
    final minutes = SleepTimerService.minDuration.inMinutes +
        normalized * (SleepTimerService.maxDuration.inMinutes - SleepTimerService.minDuration.inMinutes);
    _service.setDuration(Duration(minutes: minutes.round()));
  }

  void _toggleTimer() {
    HapticFeedback.mediumImpact();
    if (_state.isRunning) {
      _service.stop();
    } else {
      _service.start();
    }
  }

  double _getNormalizedDuration() {
    final mins = _state.scheduledDuration.inMinutes;
    final minMins = SleepTimerService.minDuration.inMinutes;
    final maxMins = SleepTimerService.maxDuration.inMinutes;
    return (mins - minMins) / (maxMins - minMins);
  }

  String _formatDuration(Duration d) {
    final hrs = d.inHours;
    final mins = d.inMinutes % 60;
    if (hrs > 0 && mins > 0) return '${hrs}h ${mins}m';
    if (hrs > 0) return '${hrs}h';
    return '${mins}m';
  }

  String _formatRemaining(Duration? d) {
    if (d == null) return '0s';
    final hrs = d.inHours;
    final mins = d.inMinutes % 60;
    final secs = d.inSeconds % 60;
    if (hrs > 0) return '${hrs}h ${mins}m ${secs}s';
    if (mins > 0) return '${mins}m ${secs}s';
    return '${secs}s';
  }

  String get _statusText {
    if (_state.isRunning) return 'sleep_timer_stops_in'.tr(namedArgs: {'duration': _formatDuration(_state.scheduledDuration)});
    if (_state.isEnabled) return 'sleep_timer_set_to'.tr(namedArgs: {'duration': _formatDuration(_state.scheduledDuration)});
    return 'sleep_timer_off'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                color: _state.isEnabled
                    ? cs.tertiaryContainer
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                LucideIcons.timer,
                size: 22,
                color: _state.isEnabled
                    ? cs.onTertiaryContainer
                    : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sleep Timer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _statusText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _state.isRunning ? cs.tertiary : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _state.isEnabled,
              onChanged: _toggleEnabled,
              activeThumbColor: cs.primary,
              activeTrackColor: cs.primaryContainer,
              inactiveThumbColor: cs.outline,
              inactiveTrackColor: cs.surfaceContainerHighest,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Timer content based on state
        if (_state.isRunning) ...[
          _buildCountdownDisplay(context, cs, theme),
          const SizedBox(height: 16),
          _buildStopButton(cs),
        ] else if (_state.isEnabled) ...[
          _buildDurationSlider(cs),
          const SizedBox(height: 8),
          _buildSliderLabels(theme, cs),
          const SizedBox(height: 16),
          _buildStartButton(cs),
        ],
      ],
    );
  }

  Widget _buildCountdownDisplay(
    BuildContext context,
    ColorScheme cs,
    ThemeData theme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.timer, size: 32, color: cs.tertiary),
          const SizedBox(height: 12),
          Text(
            _formatRemaining(_state.remainingTime),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.tertiary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'remaining',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSlider(ColorScheme cs) {
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
        activeTrackColor: cs.tertiary,
        inactiveTrackColor: cs.surfaceContainerHighest,
        thumbColor: cs.tertiary,
        overlayColor: cs.tertiary.withValues(alpha: 0.12),
        valueIndicatorColor: cs.inverseSurface,
        valueIndicatorTextStyle: TextStyle(
          color: cs.onInverseSurface,
          fontWeight: FontWeight.w500,
        ),
        showValueIndicator: ShowValueIndicator.onDrag,
      ),
      child: Slider(
        value: _getNormalizedDuration().clamp(0.0, 1.0),
        onChanged: _updateDuration,
        divisions: 23, // 15-minute increments
        label: _formatDuration(_state.scheduledDuration),
      ),
    );
  }

  Widget _buildSliderLabels(ThemeData theme, ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '15m',
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          '6h',
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: _toggleTimer,
        icon: const Icon(LucideIcons.play, size: 18),
        label: const Text('Start Timer'),
        style: FilledButton.styleFrom(
          backgroundColor: cs.tertiaryContainer,
          foregroundColor: cs.onTertiaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildStopButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: _toggleTimer,
        icon: const Icon(LucideIcons.square, size: 18),
        label: const Text('Stop Timer'),
        style: FilledButton.styleFrom(
          backgroundColor: cs.errorContainer,
          foregroundColor: cs.onErrorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
