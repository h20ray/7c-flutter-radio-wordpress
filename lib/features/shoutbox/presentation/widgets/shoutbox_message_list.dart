import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/shoutbox_message_entity.dart';

class ShoutboxMessageList extends StatelessWidget {
  final List<ShoutboxMessageEntity> messages;

  const ShoutboxMessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      separatorBuilder: (_, index) => SizedBox(height: DesignTokens.spacingS),
      itemBuilder: (context, index) {
        final message = messages[index];
        return Container(
          padding: EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.surfaces.surfaceContainerHighest,
                child: Text(
                  message.username.isNotEmpty
                      ? message.username.characters.first.toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            message.username,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: DesignTokens.spacingS),
                        Row(
                          children: [
                            const Icon(LucideIcons.clock, size: 14),
                            SizedBox(width: DesignTokens.spacingXs),
                            Text(
                              DateFormat(
                                'MMM d, HH:mm',
                              ).format(message.createdAt.toLocal()),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    Text(
                      message.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
