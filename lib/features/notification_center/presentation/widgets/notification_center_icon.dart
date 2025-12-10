import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/design_tokens.dart';
import '../cubit/notification_center_cubit.dart';
import '../cubit/notification_center_state.dart';

class NotificationCenterIcon extends StatelessWidget {
  const NotificationCenterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<NotificationCenterCubit>();

    return BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
      bloc: cubit,
      builder: (context, state) {
        final unreadCount = state.items.where((item) => !item.isRead).length;

        return InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusButton),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.notificationCenter);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingXs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.cornerRadiusAlbumArt,
                      ),
                    ),
                    constraints: const BoxConstraints(minWidth: 20),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
