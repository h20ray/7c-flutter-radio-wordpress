import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../services/tamtama_sprite_service.dart';

class TamtamaSpriteWidget extends StatefulWidget {
  final TamtamaEntity tamtama;
  final double size;

  const TamtamaSpriteWidget({
    super.key,
    required this.tamtama,
    this.size = 200.0,
  });

  @override
  State<TamtamaSpriteWidget> createState() => _TamtamaSpriteWidgetState();
}

class _TamtamaSpriteWidgetState extends State<TamtamaSpriteWidget>
    with TickerProviderStateMixin {
  late final TamtamaSpriteService _spriteService;
  late final AnimationController _jumpController;
  late final Animation<Offset> _jumpAnimation;

  Timer? _frameTimer;
  List<String> _currentFrames = [];
  int _currentFrameIndex = 0;
  final ValueNotifier<int> _frameIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _spriteService = getIt<TamtamaSpriteService>();

    // Setup jump animation (on tap/event) - 300ms for snappy tamagotchi feel
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _jumpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15), // Jump up
    ).animate(
      CurvedAnimation(
        parent: _jumpController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _loadAnimation();
  }

  @override
  void didUpdateWidget(TamtamaSpriteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tamtama.petId != widget.tamtama.petId ||
        oldWidget.tamtama.petState != widget.tamtama.petState) {
      _loadAnimation();
    }
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _frameIndexNotifier.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  Future<void> _loadAnimation() async {
    _frameTimer?.cancel();
    
    final petId = widget.tamtama.petId;
    if (petId == null) {
      setState(() {
        _currentFrames = [];
        _currentFrameIndex = 0;
        _frameIndexNotifier.value = 0;
      });
      return;
    }

    final requestedKey = _getAnimationKeyForState();
    String resolvedKey = requestedKey;
    
    try {
      final metaPath = 'assets/sprites/$petId/$petId.meta.json';
      final jsonString = await rootBundle.loadString(metaPath);
      final meta = json.decode(jsonString) as Map<String, dynamic>;
      final animations = meta['animations'] as Map<String, dynamic>?;
      final supportsRequested = animations != null && animations.containsKey(requestedKey);

      if (!supportsRequested && requestedKey != 'idle') {
        resolvedKey = 'idle';
      }

      if (animations == null || !animations.containsKey(resolvedKey)) {
        _loadDefaultFrames(petId, resolvedKey);
        return;
      }

      final animData = animations[resolvedKey] as Map<String, dynamic>;
      final frameCount = animData['frames'] as int? ?? 1;
      final fps = animData['fps'] as int? ?? 8;
      final baseFile = animData['file'] as String? ?? '${petId}_01_00.png';
      
      final frames = <String>[];
      final baseName = baseFile.replaceAll(RegExp(r'_\d{2}\.png$'), '');
      
      for (int i = 0; i < frameCount; i++) {
        final frameIdx = i.toString().padLeft(2, '0');
        frames.add('assets/sprites/$petId/${baseName}_$frameIdx.png');
      }

      setState(() {
        _currentFrames = frames;
        _currentFrameIndex = 0;
        _frameIndexNotifier.value = 0;
      });

      if (frames.length > 1) {
        final frameDuration = Duration(milliseconds: (1000 / fps).round());
        _frameTimer = Timer.periodic(frameDuration, (_) {
          if (mounted) {
            _currentFrameIndex = (_currentFrameIndex + 1) % frames.length;
            _frameIndexNotifier.value = _currentFrameIndex;
          }
        });
      }
    } catch (e) {
      if (resolvedKey != 'idle') {
        _loadDefaultFrames(petId, 'idle');
        return;
      }
      _loadDefaultFrames(petId, resolvedKey);
    }
  }

  void _loadDefaultFrames(int petId, String animationKey) {
    final animId = _getAnimationIdFromKey(animationKey);
    final frameCount = _getDefaultFrameCount(animationKey);
    
    final frames = <String>[];
    for (int i = 0; i < frameCount; i++) {
      final frameIdx = i.toString().padLeft(2, '0');
      frames.add('assets/sprites/$petId/${petId}_${animId}_$frameIdx.png');
    }

    setState(() {
      _currentFrames = frames;
      _currentFrameIndex = 0;
      _frameIndexNotifier.value = 0;
    });

    if (frames.length > 1) {
      final fps = _getDefaultFps(animationKey);
      final frameDuration = Duration(milliseconds: (1000 / fps).round());
      _frameTimer = Timer.periodic(frameDuration, (_) {
        if (mounted) {
          _currentFrameIndex = (_currentFrameIndex + 1) % frames.length;
          _frameIndexNotifier.value = _currentFrameIndex;
        }
      });
    }
  }

  String _getAnimationKeyForState() {
    switch (widget.tamtama.petState) {
      case PetState.sleeping:
        return 'sleeping';
      case PetState.sick:
        return 'sad';
      case PetState.listening:
        return 'radio';
      case PetState.evolving:
        return 'evolution';
      default:
        return 'idle';
    }
  }

  String _getAnimationIdFromKey(String key) {
    switch (key) {
      case 'idle':
        return '01';
      case 'blink':
        return '02';
      case 'smile':
        return '03';
      case 'sad':
        return '04';
      case 'angry':
        return '05';
      case 'hungry':
        return '06';
      case 'eating':
        return '07';
      case 'sleeping':
        return '08';
      case 'walking':
        return '09';
      case 'evolution':
        return '10';
      case 'special':
        return '11';
      case 'radio':
        return '12';
      case 'wiggle':
        return '13';
      default:
        return '01';
    }
  }

  int _getDefaultFrameCount(String key) {
    switch (key) {
      case 'idle':
        return 4;
      case 'blink':
        return 4;
      case 'smile':
        return 6;
      case 'sad':
        return 6;
      case 'hungry':
        return 6;
      case 'eating':
        return 10;
      case 'sleeping':
        return 10;
      case 'walking':
        return 12;
      case 'wiggle':
        return 4;
      case 'evolution':
        return 3;
      case 'special':
        return 12;
      case 'radio':
        return 12;
      default:
        return 1;
    }
  }

  int _getDefaultFps(String key) {
    switch (key) {
      case 'idle':
        return 6;
      case 'blink':
        return 6;
      case 'smile':
        return 10;
      case 'sad':
        return 8;
      case 'hungry':
        return 8;
      case 'eating':
        return 12;
      case 'sleeping':
        return 6;
      case 'walking':
        return 10;
      case 'wiggle':
        return 8;
      case 'evolution':
        return 10;
      case 'special':
        return 10;
      case 'radio':
        return 10;
      default:
        return 8;
    }
  }

  void _onTap() {
    if (!_jumpController.isAnimating) {
      _jumpController.forward().then((_) => _jumpController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackPath = _spriteService.getFallbackSpritePath();

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _jumpController,
          _frameIndexNotifier,
        ]),
        builder: (context, child) {
          final frameIdx = _frameIndexNotifier.value;
          final spritePath = _currentFrames.isNotEmpty && frameIdx < _currentFrames.length
              ? _currentFrames[frameIdx]
              : _spriteService.getSpritePath(widget.tamtama);
          
          return SlideTransition(
            position: _jumpAnimation,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Image.asset(
                spritePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    fallbackPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.pets,
                        size: 80,
                        color: Colors.white,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
