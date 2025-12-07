import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/error/failures.dart';
import '../../../wordpress/domain/entities/post_entity.dart';
import '../../../wordpress/domain/repositories/wordpress_repository.dart';
import '../../../../core/di/injection_container.dart';

class OfflineNewsListDialog extends StatelessWidget {
  const OfflineNewsListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final repository = getIt<WordPressRepository>();
    final mediaQuery = MediaQuery.of(context);
    final safeAreaInsets = mediaQuery.padding;
    final availableHeight = mediaQuery.size.height - 
        safeAreaInsets.top - 
        safeAreaInsets.bottom - 
        (DesignTokens.spacingXxl * 2);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: safeAreaInsets.top + DesignTokens.spacingL,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: availableHeight.clamp(200.0, double.infinity),
          maxWidth: mediaQuery.size.width - (DesignTokens.spacingL * 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'settings_offline_posts_list'.tr(),
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeH2,
                        fontWeight: DesignTokens.fontWeightH2,
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: colors.textSecondary,
                      size: DimensionTokens.iconSizeMedium,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(
              height: DimensionTokens.dividerThickness,
              thickness: DimensionTokens.dividerThickness,
            ),
            Expanded(
              child: FutureBuilder<Either<Failure, List<PostEntity>>>(
                future: repository.getOfflinePosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(DesignTokens.spacingL),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colors.colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(DesignTokens.spacingL),
                        child: Center(
                          child: Text(
                            'settings_offline_error_loading'.tr(),
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: DesignTokens.fontSizeBodyMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }

                  final result = snapshot.data;
                  if (result == null) {
                    return const SizedBox.shrink();
                  }

                  return result.fold(
                    (failure) => SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(DesignTokens.spacingL),
                        child: Center(
                          child: Text(
                            'settings_offline_error_loading'.tr(),
                            style: TextStyle(
                              color: colors.colorScheme.error,
                              fontSize: DesignTokens.fontSizeBodyMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    (posts) {
                      if (posts.isEmpty) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(DesignTokens.spacingL),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.offline_pin_outlined,
                                    size: DimensionTokens.avatarSizeMedium,
                                    color: colors.textSecondary,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingM),
                                  Text(
                                    'settings_offline_no_posts'.tr(),
                                    style: TextStyle(
                                      color: colors.textSecondary,
                                      fontSize: DesignTokens.fontSizeBodyMedium,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingL,
                              vertical: DesignTokens.spacingS,
                            ),
                            title: Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeBodyMedium,
                                fontWeight: DesignTokens.fontWeightBody,
                                color: colors.textPrimary,
                              ),
                            ),
                            subtitle: post.date != null
                                ? Text(
                                    _formatDate(post.date!),
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontSizeCaption,
                                      fontWeight: DesignTokens.fontWeightCaption,
                                      color: colors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: Icon(
                              Icons.chevron_right,
                              color: colors.textSecondary,
                              size: DimensionTokens.iconSizeMedium,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(
                                context,
                                AppRoutes.postDetail,
                                arguments: post,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'time_today'.tr();
    } else if (difference.inDays == 1) {
      return 'time_yesterday'.tr();
    } else if (difference.inDays < 7) {
      return 'time_days_ago'.tr(namedArgs: {'days': '${difference.inDays}'});
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

