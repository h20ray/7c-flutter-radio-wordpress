import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../app/loading_state_provider.dart';
import '../services/palette_service.dart';
import '../utils/debug_logger.dart';
import '../../config/app_config.dart';

class LoadingDependencies extends StatefulWidget {
  const LoadingDependencies({
    super.key,
    required this.loadingState,
  });

  final LoadingState loadingState;

  @override
  State<LoadingDependencies> createState() => _LoadingDependenciesState();
}

class _LoadingDependenciesState extends State<LoadingDependencies> {
  Color? _textColor;
  Color? _progressBarColor;
  final PaletteService _paletteService = PaletteService();

  @override
  void initState() {
    super.initState();
    _analyzeImageColors();
  }

  double _calculateLuminance(Color color) {
    return color.computeLuminance();
  }

  bool _isLightColor(Color color) {
    return _calculateLuminance(color) > 0.5;
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    final blackContrast = _calculateContrastRatio(Colors.black, backgroundColor);
    final whiteContrast = _calculateContrastRatio(Colors.white, backgroundColor);
    
    if (whiteContrast > blackContrast) {
      return Colors.white.withValues(alpha: 0.95);
    } else {
      return Colors.black.withValues(alpha: 0.95);
    }
  }

  double _calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = _calculateLuminance(foreground);
    final bgLuminance = _calculateLuminance(background);
    
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  Color _getProgressBarColor(Color backgroundColor) {
    final isLight = _isLightColor(backgroundColor);
    if (isLight) {
      final hsl = HSLColor.fromColor(AppConfig.primaryColor);
      return hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
    }
    return AppConfig.primaryColor;
  }

  Future<void> _analyzeImageColors() async {
    try {
      final palette = await _paletteService.fetchForImage(
        const AssetImage('assets/others/loading.png'),
        cacheKey: 'loading_image',
      );

      final dominantColor = palette.dominant;
      
      if (mounted) {
        setState(() {
          _textColor = _getContrastingTextColor(dominantColor);
          _progressBarColor = _getProgressBarColor(dominantColor);
        });
      }
      
      await _analyzeBottomAreaColor();
    } catch (e) {
      if (mounted) {
        setState(() {
          _textColor = Colors.white.withValues(alpha: 0.95);
          _progressBarColor = AppConfig.primaryColor;
        });
      }
    }
  }

  Future<void> _analyzeBottomAreaColor() async {
    try {
      const imageProvider = AssetImage('assets/others/loading.png');
      final imageStream = imageProvider.resolve(const ImageConfiguration());
      final completer = Completer<ui.Image>();
      
      late ImageStreamListener listener;
      listener = ImageStreamListener((ImageInfo info, bool sync) {
        imageStream.removeListener(listener);
        completer.complete(info.image);
      }, onError: (exception, stackTrace) {
        imageStream.removeListener(listener);
        completer.completeError(exception);
      });
      
      imageStream.addListener(listener);
      final image = await completer.future;
      
      final bottomRegionHeight = image.height * 0.3;
      final bottomRegion = Rect.fromLTWH(
        0.0,
        image.height - bottomRegionHeight,
        image.width.toDouble(),
        bottomRegionHeight,
      );
      
      final bottomColor = await _extractAverageColorFromRegion(image, bottomRegion);
      
      if (mounted) {
        setState(() {
          _textColor = _getContrastingTextColor(bottomColor);
          _progressBarColor = _getProgressBarColor(bottomColor);
        });
      }
    } catch (e) {
      DebugLogger.logError('Failed to analyze bottom area color', error: e, tag: 'LoadingDependencies');
    }
  }

  Future<Color> _extractAverageColorFromRegion(ui.Image image, Rect region) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      return const Color(0xFF000000);
    }

    final pixels = byteData.buffer.asUint8List();
    final width = image.width;
    final height = image.height;
    
    int totalR = 0;
    int totalG = 0;
    int totalB = 0;
    int pixelCount = 0;
    
    final startX = region.left.toInt();
    final startY = region.top.toInt();
    final endX = (region.right).toInt().clamp(0, width);
    final endY = (region.bottom).toInt().clamp(0, height);
    
    for (int y = startY; y < endY; y++) {
      for (int x = startX; x < endX; x++) {
        final index = (y * width + x) * 4;
        if (index + 2 < pixels.length) {
          totalR += pixels[index];
          totalG += pixels[index + 1];
          totalB += pixels[index + 2];
          pixelCount++;
        }
      }
    }
    
    if (pixelCount == 0) {
      return const Color(0xFF000000);
    }
    
    return Color.fromRGBO(
      (totalR / pixelCount).round(),
      (totalG / pixelCount).round(),
      (totalB / pixelCount).round(),
      1.0,
    );
  }

  String _getStatusTranslationKey(LoadingStatus status) {
    switch (status) {
      case LoadingStatus.checkingConnection:
        return 'loading_checking_connection';
      case LoadingStatus.loadingConfig:
        return 'loading_config';
      case LoadingStatus.initializingDependencies:
        return 'loading_dependencies';
      case LoadingStatus.initializingStorage:
        return 'loading_storage';
      case LoadingStatus.initializingConnectivity:
        return 'loading_connectivity';
      case LoadingStatus.initializingNotifications:
        return 'loading_notifications';
      case LoadingStatus.initializingAuth:
        return 'loading_auth';
      case LoadingStatus.initializingRadio:
        return 'loading_radio';
      case LoadingStatus.preparingApp:
        return 'loading_preparing';
      case LoadingStatus.complete:
        return 'loading_complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusKey = _getStatusTranslationKey(widget.loadingState.status);
    
    final textColor = _textColor ?? Colors.white.withValues(alpha: 0.9);
    final progressColor = _progressBarColor ?? AppConfig.primaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/others/loading.png',
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    AppConfig.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusKey.tr(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: widget.loadingState.progress,
                        minHeight: 2.0,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

