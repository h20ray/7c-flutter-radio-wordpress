import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../themes/component_tokens.dart';
import '../themes/design_tokens.dart';
import 'haptic_widgets.dart';

class FloatingChatFab extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  final int badgeCount;

  const FloatingChatFab({
    super.key,
    required this.onTap,
    this.size = 56,
    this.badgeCount = 0,
  });

  @override
  State<FloatingChatFab> createState() => _FloatingChatFabState();
}

class _FloatingChatFabState extends State<FloatingChatFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _previousBadgeCount = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FloatingChatFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger pulse animation when new messages arrive
    if (widget.badgeCount > _previousBadgeCount && widget.badgeCount > 0) {
      _pulseController.forward().then((_) => _pulseController.reverse());
    }
    _previousBadgeCount = widget.badgeCount;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ShoutboxTokens.of(context);
    final shadows = AppShadowTokens.of(context);
    final borderRadius = BorderRadius.circular(DesignTokens.cornerRadiusPill);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.badgeCount > 0 ? _pulseAnimation.value : 1.0,
          child: SizedBox(
            height: widget.size,
            width: widget.size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main FAB
                AnimatedContainer(
                  duration: DesignTokens.animationDurationMedium,
                  curve: DesignTokens.animationCurveSpring,
                  decoration: BoxDecoration(
                    color: tokens.fabBackground,
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: shadows.level2,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: borderRadius,
                    child: HapticInkWell(
                      borderRadius: borderRadius,
                      onTap: widget.onTap,
                      child: Center(
                        child: Icon(
                          LucideIcons.message_circle,
                          size: 26,
                          color: tokens.fabIcon,
                        ),
                      ),
                    ),
                  ),
                ),
                // Badge for new messages
                if (widget.badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: DesignTokens.animationDurationShort,
                      curve: DesignTokens.animationCurveBounce,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: tokens.badgeBackground,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: shadows.level1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.badgeCount > 99
                                ? '99+'
                                : widget.badgeCount.toString(),
                            style: TextStyle(
                              color: tokens.badgeText,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
