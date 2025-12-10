import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/themes/design_tokens.dart';
import '../cubit/notification_center_cubit.dart';
import '../cubit/notification_center_state.dart';

class NotificationCenterPage extends StatelessWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<NotificationCenterCubit>();
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('notification_center_title'.tr()),
          actions: [
            IconButton(
              onPressed: () {
                cubit.markAllRead();
              },
              icon: const Icon(Icons.done_all),
              tooltip: 'notification_center_mark_all'.tr(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
            builder: (context, state) {
              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    'notification_center_empty'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: DesignTokens.spacingM),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.cornerRadiusCard,
                      ),
                    ),
                    tileColor: item.isRead
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.surfaceContainer,
                    title: Text(item.title),
                    subtitle: Text(item.body),
                    trailing: item.isRead ? null : const Icon(Icons.fiber_new),
                    onTap: () => cubit.markRead(item.id),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
