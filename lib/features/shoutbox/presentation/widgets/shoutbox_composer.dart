import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../bloc/shoutbox_bloc.dart';

class ShoutboxComposer extends StatefulWidget {
  final bool autofocus;
  final void Function(String message) onSend;
  final int maxLength;
  final ValueChanged<bool>? onFocusChanged;
  final GlobalKey? textFieldKey;

  const ShoutboxComposer({
    super.key,
    required this.onSend,
    this.autofocus = false,
    this.maxLength = 500,
    this.onFocusChanged,
    this.textFieldKey,
  });

  @override
  State<ShoutboxComposer> createState() => _ShoutboxComposerState();
}

class _ShoutboxComposerState extends State<ShoutboxComposer> {
  late final TextEditingController _messageController;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  // Only show counter when near limit
  static const int _showCounterThreshold = 50;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageController.addListener(_onTextChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.autofocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ShoutboxComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autofocus && !_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onFocusChange() {
    final wasFocused = _isFocused;
    final isNowFocused = _focusNode.hasFocus;
    if (wasFocused != isNowFocused) {
      setState(() {
        _isFocused = isNowFocused;
      });
      widget.onFocusChanged?.call(isNowFocused);
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  bool get _canSend {
    final trimmed = _messageController.text.trim();
    return trimmed.isNotEmpty && trimmed.length <= widget.maxLength;
  }

  int get _remainingCharacters =>
      widget.maxLength - _messageController.text.length;

  bool get _shouldShowCounter => _remainingCharacters <= _showCounterThreshold;

  Color _getCharacterCountColor(ShoutboxTokens tokens) {
    final remaining = _remainingCharacters;
    if (remaining < 0) {
      return tokens.characterCountError;
    } else if (remaining < 20) {
      return tokens.characterCountWarning;
    }
    return tokens.characterCountNormal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = ShoutboxTokens.of(context);
    final shadows = AppShadowTokens.of(context);

    return BlocListener<ShoutboxBloc, ShoutboxState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (messages, lastId) {
            if (_messageController.text.isNotEmpty) {
              _messageController.clear();
            }
          },
          orElse: () {},
        );
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(
          color: tokens.composerBackground,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isFocused
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : tokens.composerBorder,
            width: _isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: shadows.level2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text field - centered vertically
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                ),
                child: TextField(
                  key: widget.textFieldKey ??
                      const ValueKey('shoutbox_textfield'),
                  controller: _messageController,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  maxLines: 1,
                  textInputAction: TextInputAction.send,
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: (_) {
                    if (_canSend) {
                      _handleSend();
                    }
                  },
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'shoutbox_message_label'.tr(),
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    isDense: false,
                    // Character counter - only show when near limit, centered vertically
                    suffix: _shouldShowCounter
                        ? Text(
                            '$_remainingCharacters',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getCharacterCountColor(tokens),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            // Send button
            BlocBuilder<ShoutboxBloc, ShoutboxState>(
              builder: (context, state) {
                final isSending = state.maybeWhen(
                  sending: (messages, _) => true,
                  orElse: () => false,
                );

                return Padding(
                  padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _canSend && !isSending ? _handleSend : null,
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: DesignTokens.animationDurationShort,
                        curve: DesignTokens.animationCurveSpring,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _canSend && !isSending
                              ? tokens.sendButtonActive
                              : tokens.sendButtonDisabled,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: isSending
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      tokens.sendButtonIconActive,
                                    ),
                                  ),
                                )
                              : Icon(
                                  LucideIcons.send,
                                  size: 18,
                                  color: _canSend
                                      ? tokens.sendButtonIconActive
                                      : tokens.sendButtonIconDisabled,
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    final trimmedMessage = _messageController.text.trim();
    if (trimmedMessage.isEmpty || trimmedMessage.length > widget.maxLength) {
      return;
    }
    // Haptic feedback on send
    HapticFeedback.lightImpact();
    widget.onSend(trimmedMessage);
  }
}
