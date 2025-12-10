import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/shoutbox_message_entity.dart';

/// M3 Expressive styled message list for the Shoutbox feature.
/// 
/// Uses pill-shaped containers (20dp radius per M3X chat guidelines),
/// proper surface colors, and consistent design tokens.
class ShoutboxMessageList extends StatelessWidget {
  final List<ShoutboxMessageEntity> messages;

  const ShoutboxMessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final tokens = ShoutboxTokens.of(context);
    final shadows = AppShadowTokens.of(context);
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: DesignTokens.spacingS),
      itemBuilder: (context, index) {
        final message = messages[index];
        return _MessageBubble(
          message: message,
          tokens: tokens,
          shadows: shadows,
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ShoutboxMessageEntity message;
  final ShoutboxTokens tokens;
  final AppShadowTokens shadows;

  const _MessageBubble({
    required this.message,
    required this.tokens,
    required this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: tokens.messageBubbleBackground,
        // M3X chat bubbles use 20dp radius for a softer, more expressive look
        borderRadius: BorderRadius.circular(tokens.messageBubbleRadius),
        boxShadow: [
          BoxShadow(
            color: shadows.level1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with M3X styling
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tokens.messageAvatarBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                message.username.isNotEmpty
                    ? message.username.characters.first.toUpperCase()
                    : '?',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: tokens.messageAvatarText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingM),
          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Username
                    Expanded(
                      child: Text(
                        message.username,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: tokens.messageBubbleText,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingS),
                    // Timestamp with icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 12,
                          color: tokens.messageTimestampColor,
                        ),
                        const SizedBox(width: DesignTokens.spacingXs),
                        Text(
                          DateFormat('MMM d, HH:mm').format(
                            message.createdAt.toLocal(),
                          ),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: tokens.messageTimestampColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                // Message text
                Text(
                  message.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.messageBubbleText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
