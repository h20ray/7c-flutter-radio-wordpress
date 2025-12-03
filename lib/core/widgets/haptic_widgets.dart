import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/haptic_feedback_helper.dart';

class HapticInkWell extends InkWell {
  HapticInkWell({
    super.key,
    VoidCallback? onTap,
    super.onTapDown,
    super.onTapCancel,
    super.onDoubleTap,
    super.onLongPress,
    super.onTapUp,
    super.onHighlightChanged,
    super.onHover,
    super.onFocusChange,
    super.autofocus = false,
    super.focusNode,
    super.canRequestFocus = true,
    super.statesController,
    super.borderRadius,
    super.customBorder,
    super.radius,
    super.overlayColor,
    super.splashColor,
    super.highlightColor,
    super.hoverColor,
    super.focusColor,
    super.splashFactory,
    super.excludeFromSemantics = false,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    required super.child,
  }) : super(
          onTap: onTap != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onTap();
                }
              : null,
        );
}

class HapticIconButton extends IconButton {
  HapticIconButton({
    super.key,
    required super.icon,
    super.iconSize,
    super.visualDensity,
    super.padding,
    super.alignment,
    super.splashRadius,
    super.color,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.splashColor,
    super.disabledColor,
    VoidCallback? onPressed,
    super.mouseCursor,
    super.focusNode,
    super.autofocus = false,
    super.tooltip,
    super.enableFeedback = true,
    super.constraints,
    super.style,
    super.isSelected,
    super.selectedIcon,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
  }) : super(
          onPressed: onPressed != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onPressed();
                }
              : null,
        );
}

class HapticGestureDetector extends GestureDetector {
  HapticGestureDetector({
    super.key,
    super.child,
    GestureTapCallback? onTap,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    super.onSecondaryTap,
    super.onSecondaryTapDown,
    super.onSecondaryTapUp,
    super.onSecondaryTapCancel,
    super.onTertiaryTapDown,
    super.onTertiaryTapUp,
    super.onTertiaryTapCancel,
    super.onDoubleTapDown,
    super.onDoubleTap,
    super.onDoubleTapCancel,
    super.onLongPress,
    super.onLongPressStart,
    super.onLongPressMoveUpdate,
    super.onLongPressUp,
    super.onLongPressEnd,
    super.onVerticalDragDown,
    super.onVerticalDragStart,
    super.onVerticalDragUpdate,
    super.onVerticalDragEnd,
    super.onVerticalDragCancel,
    super.onHorizontalDragDown,
    super.onHorizontalDragStart,
    super.onHorizontalDragUpdate,
    super.onHorizontalDragEnd,
    super.onHorizontalDragCancel,
    super.onForcePressStart,
    super.onForcePressPeak,
    super.onForcePressUpdate,
    super.onForcePressEnd,
    super.onPanDown,
    super.onPanStart,
    super.onPanUpdate,
    super.onPanEnd,
    super.onPanCancel,
    super.onScaleStart,
    super.onScaleUpdate,
    super.onScaleEnd,
    super.behavior,
    super.excludeFromSemantics = false,
    super.dragStartBehavior = DragStartBehavior.start,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
  }) : super(
          onTap: onTap != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onTap();
                }
              : null,
        );
}

class HapticTextButton extends TextButton {
  HapticTextButton({
    super.key,
    VoidCallback? onPressed,
    super.onLongPress,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    required super.child,
  }) : super(
          onPressed: onPressed != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onPressed();
                }
              : null,
        );
}

class HapticElevatedButton extends ElevatedButton {
  HapticElevatedButton({
    super.key,
    VoidCallback? onPressed,
    super.onLongPress,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    required super.child,
  }) : super(
          onPressed: onPressed != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onPressed();
                }
              : null,
        );
}

class HapticOutlinedButton extends OutlinedButton {
  HapticOutlinedButton({
    super.key,
    VoidCallback? onPressed,
    super.onLongPress,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    required super.child,
  }) : super(
          onPressed: onPressed != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onPressed();
                }
              : null,
        );
}

class HapticFilledButton extends FilledButton {
  HapticFilledButton({
    super.key,
    VoidCallback? onPressed,
    super.onLongPress,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    HapticFeedbackType hapticType = HapticFeedbackType.lightImpact,
    required super.child,
  }) : super(
          onPressed: onPressed != null
              ? () {
                  HapticFeedbackHelper.trigger(hapticType);
                  onPressed();
                }
              : null,
        );
}
