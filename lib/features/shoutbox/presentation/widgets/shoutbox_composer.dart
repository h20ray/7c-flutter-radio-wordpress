import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../bloc/shoutbox_bloc.dart';

class ShoutboxComposer extends StatefulWidget {
  final void Function(String message) onSend;
  final int maxLength;

  const ShoutboxComposer({
    super.key,
    required this.onSend,
    this.maxLength = 500,
  });

  @override
  State<ShoutboxComposer> createState() => _ShoutboxComposerState();
}

class _ShoutboxComposerState extends State<ShoutboxComposer> {
  late final TextEditingController _messageController;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageController.addListener(_updateCharacterCount);
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _messageController.text.length;
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_updateCharacterCount);
    _messageController.dispose();
    super.dispose();
  }

  bool get _canSend {
    final trimmed = _messageController.text.trim();
    return trimmed.isNotEmpty && trimmed.length <= widget.maxLength;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final isOverLimit = _characterCount > widget.maxLength;

    return BlocListener<ShoutboxBloc, ShoutboxState>(
      listener: (context, state) {
        // Clear message field after successful send
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
        padding: EdgeInsets.all(DesignTokens.spacingM),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'shoutbox_composer_title'.tr(),
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: DesignTokens.spacingXs),
            Text(
              'shoutbox_composer_subtitle'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: DesignTokens.spacingM),
            TextField(
              controller: _messageController,
              maxLines: 3,
              minLines: 2,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: 'shoutbox_message_label'.tr(),
                prefixIcon: const Icon(LucideIcons.message_circle),
                helperText: 'shoutbox_character_count'.tr(
                  namedArgs: {
                    'current': _characterCount.toString(),
                    'max': widget.maxLength.toString(),
                  },
                ),
                helperStyle: TextStyle(
                  color: isOverLimit 
                    ? theme.colorScheme.error 
                    : colors.textSecondary,
                ),
                errorText: isOverLimit 
                  ? 'shoutbox_message_too_long'.tr() 
                  : null,
              ),
            ),
            SizedBox(height: DesignTokens.spacingM),
            Align(
              alignment: Alignment.centerRight,
              child: BlocBuilder<ShoutboxBloc, ShoutboxState>(
                builder: (context, state) {
                  final isSending = state.maybeWhen(
                    sending: (messages, _) => true,
                    orElse: () => false,
                  );

                  return ElevatedButton.icon(
                    onPressed: _canSend && !isSending ? _handleSend : null,
                    icon: isSending
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                colors.textPrimary,
                              ),
                            ),
                          )
                        : const Icon(LucideIcons.send),
                    label: Text(
                      isSending 
                        ? 'shoutbox_sending'.tr() 
                        : 'shoutbox_send'.tr(),
                    ),
                  );
                },
              ),
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
    widget.onSend(trimmedMessage);
    FocusScope.of(context).unfocus();
  }
}
