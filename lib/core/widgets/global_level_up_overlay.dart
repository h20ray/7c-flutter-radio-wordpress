import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lottie/lottie.dart';

import '../../config/game_radio_time_config.dart';
import '../../features/gamification/data/datasources/level_celebration_local_data_source.dart';
import '../di/injection_container.dart';
import '../services/level_up_celebration_service.dart';
import '../themes/design_tokens.dart';

class GlobalLevelUpOverlay extends StatefulWidget {
  const GlobalLevelUpOverlay({super.key});

  @override
  State<GlobalLevelUpOverlay> createState() => _GlobalLevelUpOverlayState();
}

class _GlobalLevelUpOverlayState extends State<GlobalLevelUpOverlay>
    with TickerProviderStateMixin {
  LevelUpCelebrationService? _service;
  LevelUpCelebrationData? _currentCelebration;
  bool _hasError = false;
  StreamSubscription<LevelUpCelebrationData?>? _celebrationSubscription;

  late final AnimationController _levelUpController;
  late final AnimationController _transitionController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeOutAnimation;
  late final Animation<double> _fadeInAnimation;

  bool _transitionStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeService();
  }

  void _initializeAnimations() {
    _levelUpController = AnimationController(vsync: this);
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    ));

    _levelUpController.addListener(_checkTransition);
  }

  void _checkTransition() {
    // Trigger transition at 80% of the level up animation
    if (_levelUpController.value > 0.8 && !_transitionStarted) {
      _transitionStarted = true;
      _transitionController.forward();
    }
  }

  void _initializeService() {
    if (getIt.isRegistered<LevelCelebrationLocalDataSource>()) {
      _service = LevelUpCelebrationService.instance;
      _celebrationSubscription?.cancel();
      _celebrationSubscription =
          _service!.celebrationStream.listen(_onCelebrationChanged);
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _initializeService();
        }
      });
    }
  }

  void _onCelebrationChanged(LevelUpCelebrationData? celebration) {
    if (mounted) {
      setState(() {
        _currentCelebration = celebration;
        _hasError = false;
        if (celebration != null) {
          _resetAnimations();
        } else {
          _stopAnimations();
        }
      });
    }
  }

  void _resetAnimations() {
    _transitionStarted = false;
    _levelUpController.reset();
    _transitionController.reset();
  }

  void _stopAnimations() {
    _levelUpController.stop();
    _transitionController.stop();
  }

  @override
  void dispose() {
    _levelUpController.removeListener(_checkTransition);
    _levelUpController.dispose();
    _transitionController.dispose();
    _celebrationSubscription?.cancel();
    super.dispose();
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

    // Get current level definition to find the animation asset
    final currentLevel =
        GameRadioTimeConfig.getLevelById(_currentCelebration!.levelId);

    return Positioned.fill(
      child: GestureDetector(
        onTap: _handleDismiss,
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DesignTokens.spacingL),
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
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Current Level Animation (Fades In)
                                  if (currentLevel != null)
                                    FadeTransition(
                                      opacity: _fadeInAnimation,
                                      child: Lottie.asset(
                                        currentLevel.animationAssetPath,
                                        fit: BoxFit.contain,
                                        decoder: _dotLottieDecoder,
                                        // Loop infinitely
                                        repeat: true,
                                      ),
                                    ),
                                  // Level Up Animation (Slides Up & Fades Out)
                                  SlideTransition(
                                    position: _slideAnimation,
                                    child: FadeTransition(
                                      opacity: _fadeOutAnimation,
                                      child: Lottie.asset(
                                        'assets/sprites/game_level_listening/level_up.lottie',
                                        controller: _levelUpController,
                                        repeat: false,
                                        fit: BoxFit.contain,
                                        decoder: _dotLottieDecoder,
                                        onLoaded: (composition) {
                                          _levelUpController.duration =
                                              composition.duration;
                                          _levelUpController.forward();
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Only trigger error if we haven't started transitioning
                                          // effectively fallback for the main animation
                                          if (mounted && !_transitionStarted) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((duration) {
                                              if (mounted) {
                                                setState(() {
                                                  _hasError = true;
                                                });
                                              }
                                            });
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: DesignTokens.spacingL),
                      Text(
                        'level_up_title'.tr(),
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_currentCelebration!.levelName.isNotEmpty) ...[
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          _currentCelebration!.levelName,
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: DesignTokens.spacingM),
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
      child: const Icon(
        LucideIcons.trophy,
        size: 120,
        color: Colors.white,
      ),
    );
  }
}
