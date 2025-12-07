import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../../../../core/widgets/glass_app_bar_background.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_dialog.dart';
import '../bloc/shoutbox_bloc.dart';
import '../widgets/shoutbox_composer.dart';
import '../widgets/shoutbox_message_list.dart';

class ShoutboxPageView extends StatefulWidget {
  const ShoutboxPageView({super.key});

  @override
  State<ShoutboxPageView> createState() => _ShoutboxPageViewState();
}

class _ShoutboxPageViewState extends State<ShoutboxPageView> {
  final _scrollController = ScrollController();
  NavItem _selectedNavItem = NavItem.shoutbox;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ShoutboxBloc>().add(const ShoutboxEvent.getMessages());
      _startAutoRefresh();
    });
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      // Use refreshMessages for silent incremental updates
      // The bloc handles debouncing and skips if already fetching
      context.read<ShoutboxBloc>().add(const ShoutboxEvent.refreshMessages());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final mediaQuery = MediaQuery.of(context);
    final safeAreaBottom = mediaQuery.padding.bottom;
    final viewInsets = mediaQuery.viewInsets.bottom;
    final navBarHeight = FloatingBottomNavBar.totalHeight;
    final composerSpacing = DesignTokens.spacingM;
    final composerEstimatedHeight = 200.0;
    final keyboardHeight = viewInsets > 0 ? viewInsets.toDouble() : 0.0;
    final totalBottomSpacing = navBarHeight +
        composerEstimatedHeight +
        composerSpacing +
        safeAreaBottom +
        keyboardHeight;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        unawaited(Navigator.pushReplacementNamed(context, AppRoutes.home));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colors.primaryBackground,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<ShoutboxBloc>().add(
                  const ShoutboxEvent.getMessages(),
                );
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                    leading: IconButton(
                      icon: const Icon(LucideIcons.arrow_left),
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                      ),
                    ),
                    title: Text('shoutbox_title'.tr()),
                    actions: [
                      IconButton(
                        icon: const Icon(LucideIcons.arrow_up_from_line),
                        onPressed: _scrollToTop,
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.refresh_ccw),
                        onPressed: () {
                          context.read<ShoutboxBloc>().add(
                            const ShoutboxEvent.getMessages(),
                          );
                        },
                      ),
                    ],
                    flexibleSpace: GlassAppBarBackground(child: Container()),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingL,
                        vertical: DesignTokens.spacingM,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BlocBuilder<ShoutboxBloc, ShoutboxState>(
                            builder: (context, state) {
                              return state.when(
                                initial: () => _ShoutboxLoadingSkeleton(
                                  itemCount: 6,
                                  spacing: DesignTokens.spacingS,
                                ),
                                loading: () => _ShoutboxLoadingSkeleton(
                                  itemCount: 6,
                                  spacing: DesignTokens.spacingS,
                                ),
                                refreshing: (messages, _) {
                                  // Show existing messages while refreshing
                                  if (messages.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: DesignTokens.spacingL,
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            LucideIcons.message_circle,
                                            size: 56,
                                            color: colors.textSecondary,
                                          ),
                                          SizedBox(
                                            height: DesignTokens.spacingM,
                                          ),
                                          Text(
                                            'shoutbox_empty_title'.tr(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return ShoutboxMessageList(
                                    messages: messages,
                                  );
                                },
                                sending: (messages, _) {
                                  // Show existing messages while sending
                                  if (messages.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return ShoutboxMessageList(
                                    messages: messages,
                                  );
                                },
                                loaded: (messages, _) {
                                  if (messages.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: DesignTokens.spacingL,
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            LucideIcons.message_circle,
                                            size: 56,
                                            color: colors.textSecondary,
                                          ),
                                          SizedBox(
                                            height: DesignTokens.spacingM,
                                          ),
                                          Text(
                                            'shoutbox_empty_title'.tr(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                          SizedBox(
                                            height: DesignTokens.spacingS,
                                          ),
                                          Text(
                                            'shoutbox_empty_message'.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: colors.textSecondary,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return ShoutboxMessageList(
                                    messages: messages,
                                  );
                                },
                                error: (failure) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: DesignTokens.spacingL,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 56,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                      SizedBox(height: DesignTokens.spacingM),
                                      Text(
                                        'shoutbox_error_title'.tr(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      SizedBox(height: DesignTokens.spacingS),
                                      Text(
                                        failure.message,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: colors.textSecondary,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: DesignTokens.spacingM),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          context.read<ShoutboxBloc>().add(
                                            const ShoutboxEvent.getMessages(),
                                          );
                                        },
                                        icon: const Icon(
                                          LucideIcons.refresh_ccw,
                                        ),
                                        label: Text('retry'.tr()),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: totalBottomSpacing),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: navBarHeight + safeAreaBottom + DesignTokens.spacingS,
              child: Builder(
                builder: (context) {
                  final currentViewInsets =
                      MediaQuery.of(context).viewInsets.bottom;
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                      bottom: currentViewInsets,
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingL,
                        ),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            return authState.maybeWhen(
                              authenticated: (_) => ShoutboxComposer(
                                onSend: _onSend,
                              ),
                              orElse: () => const _ShoutboxLoginCard(),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: DesignTokens.spacingL,
                    right: DesignTokens.spacingL,
                    bottom: DesignTokens.spacingS,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FloatingBottomNavBar(
                          selectedItem: _selectedNavItem,
                          onItemSelected: (item) {
                            setState(() {
                              _selectedNavItem = item;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: DesignTokens.spacingM),
                      const FloatingPlayFab(size: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSend(String message) {
    final authState = context.read<AuthBloc>().state;

    authState.maybeWhen(
      authenticated: (user) {
        final displayName = user.name.trim().isEmpty
            ? 'shoutbox_guest'.tr()
            : user.name.trim();
        final trimmedMessage = message.trim();
        if (trimmedMessage.isEmpty) return;

        context.read<ShoutboxBloc>().add(
          ShoutboxEvent.sendMessage(
            username: displayName,
            message: trimmedMessage,
          ),
        );

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('shoutbox_send_success'.tr()),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      orElse: () {
        LoginDialog.show(context);
      },
    );
  }
}

class _ShoutboxLoginCard extends StatelessWidget {
  const _ShoutboxLoginCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingL),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.lock,
            size: 32,
            color: colors.textSecondary,
          ),
          SizedBox(height: DesignTokens.spacingS),
          Text(
            'shoutbox_login_to_chat'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesignTokens.spacingM),
          ElevatedButton.icon(
            onPressed: () {
              LoginDialog.show(context);
            },
            icon: const Icon(LucideIcons.log_in),
            label: Text('auth_login_button'.tr()),
          ),
        ],
      ),
    );
  }
}

class _ShoutboxLoadingSkeleton extends StatelessWidget {
  final int itemCount;
  final double spacing;

  const _ShoutboxLoadingSkeleton({
    required this.itemCount,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = colors.surfaces.surfaceContainerHighest;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: spacing),
      itemBuilder: (_, _) {
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
              ShimmerContainer(
                width: 40,
                height: 40,
                borderRadius: 20,
                baseColor: skeletonColor.withValues(alpha: 0.35),
                highlightColor: skeletonColor.withValues(alpha: 0.55),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: 140,
                      height: 16,
                      borderRadius: 6,
                      baseColor: skeletonColor.withValues(alpha: 0.35),
                      highlightColor: skeletonColor.withValues(alpha: 0.55),
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    ShimmerContainer(
                      width: 90,
                      height: 12,
                      borderRadius: 6,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    ShimmerContainer(
                      width: double.infinity,
                      height: 14,
                      borderRadius: 6,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    ShimmerContainer(
                      width: double.infinity,
                      height: 14,
                      borderRadius: 6,
                      baseColor: skeletonColor.withValues(alpha: 0.25),
                      highlightColor: skeletonColor.withValues(alpha: 0.45),
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
