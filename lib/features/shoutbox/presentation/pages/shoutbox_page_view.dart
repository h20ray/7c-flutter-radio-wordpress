import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_chat_fab.dart';
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
  final _composerTextFieldKey = GlobalKey();
  NavItem _selectedNavItem = NavItem.shoutbox;
  Timer? _refreshTimer;
  bool _isAtBottom = true;
  int _newMessagesCount = 0;
  int _lastMessageCount = 0;
  bool _isComposerVisible = false;
  bool _pendingSend = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<ShoutboxBloc>();
      final currentState = bloc.state;
      final hasMessages = currentState.maybeWhen(
        loaded: (messages, _) => messages.isNotEmpty,
        refreshing: (messages, _) => messages.isNotEmpty,
        sending: (messages, _) => messages.isNotEmpty,
        orElse: () => false,
      );
      if (!hasMessages) {
        bloc.add(const ShoutboxEvent.getMessages());
      }
      _startAutoRefresh();
    });
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      context.read<ShoutboxBloc>().add(const ShoutboxEvent.refreshMessages());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    const threshold = 100.0;

    final wasAtBottom = _isAtBottom;
    _isAtBottom = (maxScroll - currentScroll) <= threshold;

    if (_isAtBottom && !wasAtBottom) {
      setState(() {
        _newMessagesCount = 0;
      });
    }
  }

  Future<void> _scrollToBottom({bool smooth = true}) async {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (smooth) {
      await _scrollController.animateTo(
        maxScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(maxScroll);
    }
    setState(() {
      _isAtBottom = true;
      _newMessagesCount = 0;
    });
  }

  void _showComposer() {
    setState(() {
      _isComposerVisible = true;
    });
  }

  void _hideComposer() {
    setState(() {
      _isComposerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final safeAreaBottom = mediaQuery.padding.bottom;
    final navBarHeight = FloatingBottomNavBar.totalHeight;
    final totalBottomSpacing =
        navBarHeight + safeAreaBottom + DesignTokens.spacingM;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        // If composer is visible, hide it instead of navigating away
        if (_isComposerVisible) {
          FocusScope.of(context).unfocus();
          _hideComposer();
          return;
        }
        unawaited(Navigator.pushReplacementNamed(context, AppRoutes.home));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colors.primaryBackground,
        body: BlocListener<ShoutboxBloc, ShoutboxState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (messages, _) {
                // On successful send, just hide composer and scroll
                if (_pendingSend) {
                  _pendingSend = false;
                  _hideComposer();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              error: (failure) {
                // Show error snackbar
                _pendingSend = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.message),
                    backgroundColor: colorScheme.error,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: Stack(
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
                      surfaceTintColor:
                          Theme.of(context).colorScheme.surfaceTint,
                      leading: IconButton(
                        icon: const Icon(LucideIcons.arrow_left),
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.home,
                        ),
                      ),
                      title: Text('shoutbox_title'.tr()),
                      actions: [
                        if (_newMessagesCount > 0 && !_isAtBottom)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              label: Text('$_newMessagesCount new'),
                              avatar: const Icon(LucideIcons.arrow_down,
                                  size: 16),
                              backgroundColor:
                                  colorScheme.primaryContainer,
                              onPressed: _scrollToBottom,
                            ),
                          ),
                        IconButton(
                          icon: const Icon(LucideIcons.arrow_down_to_line),
                          tooltip: _isAtBottom
                              ? 'Scroll to bottom'
                              : 'Scroll to bottom ($_newMessagesCount new)',
                          onPressed: _scrollToBottom,
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
                      child: GestureDetector(
                        onTap: () {
                          if (_isComposerVisible) {
                            FocusScope.of(context).unfocus();
                            _hideComposer();
                          }
                        },
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
                                    initial: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _scrollToBottom(smooth: false);
                                      });
                                      return _ShoutboxLoadingSkeleton(
                                        itemCount: 6,
                                        spacing: DesignTokens.spacingS,
                                      );
                                    },
                                    loading: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _scrollToBottom(smooth: false);
                                      });
                                      return _ShoutboxLoadingSkeleton(
                                        itemCount: 6,
                                        spacing: DesignTokens.spacingS,
                                      );
                                    },
                                    refreshing: (messages, _) {
                                      if (messages.isEmpty) {
                                        return _buildEmptyState(colors);
                                      }
                                      _handleNewMessages(messages.length);
                                      return ShoutboxMessageList(
                                        messages: messages,
                                      );
                                    },
                                    sending: (messages, _) {
                                      if (messages.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      return ShoutboxMessageList(
                                        messages: messages,
                                      );
                                    },
                                    loaded: (messages, _) {
                                      if (messages.isEmpty) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _scrollToBottom(smooth: false);
                                          setState(() {
                                            _lastMessageCount = 0;
                                            _newMessagesCount = 0;
                                          });
                                        });
                                        return _buildEmptyState(colors);
                                      }
                                      _handleNewMessages(messages.length);
                                      return ShoutboxMessageList(
                                        messages: messages,
                                      );
                                    },
                                    error: (failure) => _buildErrorState(
                                      colors,
                                      failure.message,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: totalBottomSpacing),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Composer overlay - positioned at screen bottom, above keyboard
              if (_isComposerVisible)
                Positioned(
                  left: DesignTokens.spacingL,
                  right: DesignTokens.spacingL,
                  bottom: mediaQuery.viewInsets.bottom + DesignTokens.spacingS,
                  child: Material(
                    color: Colors.transparent,
                    child: AnimatedContainer(
                      duration: DesignTokens.animationDurationMedium,
                      curve: DesignTokens.animationCurveSpring,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          return authState.maybeWhen(
                            authenticated: (_) => ShoutboxComposer(
                              key: const ValueKey('composer'),
                              textFieldKey: _composerTextFieldKey,
                              onSend: _onSend,
                              onFocusChanged: (isFocused) {
                                if (!isFocused) {
                                  _hideComposer();
                                }
                              },
                            ),
                            orElse: () => const _ShoutboxLoginCard(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              // Bottom bar with NavBar and Play FAB
              if (!_isComposerVisible) ...[
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
                // Chat FAB - positioned above Play FAB with proper spacing
                Positioned(
                  right: DesignTokens.spacingL,
                  bottom: safeAreaBottom +
                      DesignTokens.spacingS +
                      60 + // PlayFab height
                      DesignTokens.spacingXl, // 24px spacing between FABs
                  child: FloatingChatFab(
                    onTap: _showComposer,
                    size: 52,
                    badgeCount: _isAtBottom ? 0 : _newMessagesCount,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleNewMessages(int messageCount) {
    final newCount = messageCount - _lastMessageCount;
    if (_lastMessageCount == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
        setState(() {
          _lastMessageCount = messageCount;
          _newMessagesCount = 0;
        });
      });
    } else if (newCount > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isAtBottom) {
          _scrollToBottom();
          setState(() {
            _lastMessageCount = messageCount;
            _newMessagesCount = 0;
          });
        } else {
          setState(() {
            _newMessagesCount += newCount;
            _lastMessageCount = messageCount;
          });
        }
      });
    }
  }

  Widget _buildEmptyState(AppSemanticColors colors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
      child: Column(
        children: [
          Icon(
            LucideIcons.message_circle,
            size: 56,
            color: colors.textSecondary,
          ),
          SizedBox(height: DesignTokens.spacingM),
          Text(
            'shoutbox_empty_title'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: DesignTokens.spacingS),
          Text(
            'shoutbox_empty_message'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppSemanticColors colors, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: DesignTokens.spacingM),
          Text(
            'shoutbox_error_title'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: DesignTokens.spacingS),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            icon: const Icon(LucideIcons.refresh_ccw),
            label: Text('retry'.tr()),
          ),
        ],
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

        // Set pending flag to track send completion
        _pendingSend = true;

        context.read<ShoutboxBloc>().add(
              ShoutboxEvent.sendMessage(
                username: displayName,
                message: trimmedMessage,
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
