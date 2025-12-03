import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum HapticFeedbackType {
  lightImpact,
  selectionClick,
  mediumImpact,
  heavyImpact,
}

class HapticFeedbackHelper {
  HapticFeedbackHelper._();

  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void trigger(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.lightImpact:
        lightImpact();
        break;
      case HapticFeedbackType.selectionClick:
        selectionClick();
        break;
      case HapticFeedbackType.mediumImpact:
        mediumImpact();
        break;
      case HapticFeedbackType.heavyImpact:
        heavyImpact();
        break;
    }
  }
}

extension HapticFeedbackExtension on BuildContext {
  HapticFeedbackHelperInstance get hapticFeedback => const HapticFeedbackHelperInstance();
}

class HapticFeedbackHelperInstance {
  const HapticFeedbackHelperInstance();
  
  void lightImpact() => HapticFeedbackHelper.lightImpact();
  
  void selectionClick() => HapticFeedbackHelper.selectionClick();
  
  void mediumImpact() => HapticFeedbackHelper.mediumImpact();
  
  void heavyImpact() => HapticFeedbackHelper.heavyImpact();
  
  void trigger(HapticFeedbackType type) => HapticFeedbackHelper.trigger(type);
}
