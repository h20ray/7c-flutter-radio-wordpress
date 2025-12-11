import 'package:flutter/material.dart';

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
  late final AnimationController _breathingController;
  late final Animation<double> _scaleAnimation;

  late final AnimationController _jumpController;
  late final Animation<Offset> _jumpAnimation;

  @override
  void initState() {
    super.initState();
    _spriteService = getIt<TamtamaSpriteService>();

    // Setup breathing animation (continuous)
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Setup jump animation (on tap/event)
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _jumpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.2), // Jump up
    ).animate(
      CurvedAnimation(
        parent: _jumpController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!_jumpController.isAnimating) {
      _jumpController.forward().then((_) => _jumpController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine target path
    final spritePath = _spriteService.getSpritePath(widget.tamtama);
    final fallbackPath = _spriteService.getFallbackSpritePath();

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathingController, _jumpController]),
        builder: (context, child) {
          return SlideTransition(
            position: _jumpAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
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
            ),
          );
        },
      ),
    );
  }
}
