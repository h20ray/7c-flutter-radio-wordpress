import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/themes/app_color_system.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/haptic_widgets.dart';

class NewsSearchBox extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final bool isLoading;
  final ValueChanged<bool>? onFocusChanged;

  const NewsSearchBox({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    required this.isLoading,
    this.onFocusChanged,
  });

  @override
  State<NewsSearchBox> createState() => NewsSearchBoxState();
}

class NewsSearchBoxState extends State<NewsSearchBox> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _widthAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      unawaited(_animationController.forward());
    } else {
      unawaited(_animationController.reverse());
    }
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  void unfocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return AnimatedBuilder(
          animation: _widthAnimation,
          builder: (context, child) {
            return Row(
              children: [
                Expanded(
                  flex: (_widthAnimation.value * 100).round(),
                  child: Container(
                    height: kToolbarHeight * 0.7,
                    decoration: BoxDecoration(
                      color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: !widget.isLoading,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'news_search_hint'.tr(),
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: colors.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: value.text.isNotEmpty && !widget.isLoading
                            ? HapticIconButton(
                                onPressed: widget.onClear,
                                icon: Icon(
                                  LucideIcons.x,
                                  color: colors.textSecondary,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingM,
                          vertical: DesignTokens.spacingS,
                        ),
                        isDense: true,
                      ),
                      onSubmitted: widget.isLoading ? null : (value) => widget.onSearch(),
                    ),
                  ),
                ),
                SizedBox(width: DesignTokens.spacingS),
              ],
            );
          },
        );
      },
    );
  }
}

