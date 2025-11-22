import 'dart:async';
import 'package:volume_regulator/volume_regulator.dart';
import '../utils/debug_logger.dart';

/// SystemVolumeService provides a simple, debounced, bi-directional interface
/// to the platform media volume using the volume_regulator plugin.
class SystemVolumeService {
  SystemVolumeService();

  final StreamController<double> _volumeController =
      StreamController<double>.broadcast();

  // Guard to avoid echoing our own updates back into the UI
  bool _suppressNextFromStream = false;

  Timer? _pollTimer;

  /// Begin listening to platform volume stream and forward values to clients.
  void ensureInitialized() {
    if (_pollTimer != null) return;
    double? last;
    _pollTimer = Timer.periodic(const Duration(milliseconds: 250), (_) async {
      try {
        final int raw = await VolumeRegulator.getVolume();
        final double normalized = (raw / 100).clamp(0.0, 1.0);
        if (_suppressNextFromStream) {
          _suppressNextFromStream = false;
          last = normalized;
          return;
        }
        if (last == null || (normalized - last!).abs() > 0.005) {
          last = normalized;
          _volumeController.add(normalized);
        }
      } catch (e) {
        DebugLogger.logError('Error polling volume', error: e, tag: 'SystemVolumeService');
      }
    });
  }

  /// Current system media volume as 0.0–1.0
  Future<double> getVolume() async {
    try {
      final int v = await VolumeRegulator.getVolume();
      return (v / 100).clamp(0.0, 1.0);
    } catch (e) {
      DebugLogger.logError('Error getting volume', error: e, tag: 'SystemVolumeService');
      return 1.0;
    }
  }

  /// Set system media volume to 0.0–1.0 and suppress immediate echo.
  Future<void> setVolume(double volume) async {
    final double clamped = volume.clamp(0.0, 1.0);
    try {
      _suppressNextFromStream = true;
      await VolumeRegulator.setVolume((clamped * 100).round());
      // Proactively emit for responsive UI in case platform stream lags
      _volumeController.add(clamped);
    } catch (e) {
      DebugLogger.logError('Error setting volume', error: e, tag: 'SystemVolumeService');
      // Ignore: on some platforms, setting may be restricted
    }
  }

  /// Stream of system media volume changes (0.0–1.0)
  Stream<double> get volumeStream {
    ensureInitialized();
    return _volumeController.stream;
  }

  void dispose() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _volumeController.close();
  }
}

