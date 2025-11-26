import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lottie/lottie.dart';

import '../../features/gamification/data/datasources/level_celebration_local_data_source.dart';
import '../di/injection_container.dart';
import '../services/level_up_celebration_service.dart';
import '../themes/design_tokens.dart';

class GlobalLevelUpOverlay extends StatefulWidget {
  const GlobalLevelUpOverlay({super.key});

  @override
  State<GlobalLevelUpOverlay> createState() => _GlobalLevelUpOverlayState();
}

class _GlobalLevelUpOverlayState extends State<GlobalLevelUpOverlay> {
  LevelUpCelebrationService? _service;
  LevelUpCelebrationData? _currentCelebration;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() {
    if (getIt.isRegistered<LevelCelebrationLocalDataSource>()) {
      _service = LevelUpCelebrationService.instance;
      _service!.celebrationStream.listen((celebration) {
        if (mounted) {
          setState(() {
            _currentCelebration = celebration;
            _hasError = false;
          });
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _initializeService();
        }
      });
    }
  }

  Future<LottieComposition?> _dotLottieDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        for (final file in files) {
          if (file.name.startsWith('animations/') &&
              file.name.endsWith('.json')) {
            return file;
          }
        }
        return files.isNotEmpty ? files.first : null;
      },
    );
  }

  void _handleDismiss() {
    if (_currentCelebration != null && _service != null) {
      _service!.dismissCelebration(_currentCelebration!.levelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentCelebration == null) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final levelUpAnimationSize = (screenSize.width * 0.5).clamp(200.0, 280.0);

    return Positioned.fill(
      child: GestureDetector(
        onTap: _handleDismiss,
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(DesignTokens.spacingL),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: levelUpAnimationSize,
                    maxHeight: screenSize.height * 0.9,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: levelUpAnimationSize,
                        height: levelUpAnimationSize,
                        child: _hasError
                            ? _buildFallback()
                            : Lottie.asset(
                                'assets/sprites/game_level_listening/level_up.lottie',
                                repeat: false,
                                fit: BoxFit.contain,
                                decoder: _dotLottieDecoder,
                                errorBuilder: (context, error, stackTrace) {
                                  if (mounted) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          _hasError = true;
                                        });
                                      }
                                    });
                                  }
                                  return _buildFallback();
                                },
                              ),
                      ),
                      SizedBox(height: DesignTokens.spacingL),
                      Text(
                        'level_up_title'.tr(),
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_currentCelebration!.levelName.isNotEmpty) ...[
                        SizedBox(height: DesignTokens.spacingS),
                        Text(
                          _currentCelebration!.levelName,
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: DesignTokens.spacingM),
                      Text(
                        'level_up_tap_to_continue'.tr(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade400,
            Colors.orange.shade600,
          ],
        ),
      ),
      child: Icon(
        LucideIcons.trophy,
        size: 120,
        color: Colors.white,
      ),
    );
  }
}

