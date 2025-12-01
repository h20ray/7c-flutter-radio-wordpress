import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/request_bloc.dart';
import '../bloc/radio_bloc.dart';
import '../../domain/repositories/request_repository.dart';
import '../../data/services/azuracast_detection_service.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _streamUrl;
  String _requestMode = 'auto';
  bool _isAzuracastAvailable = false;
  RequestBloc? _currentBloc;
  Timer? _searchDebounce;
  bool _isInitialLoad = true;
  String? _lastQuery;

  @override
  void initState() {
    super.initState();
    _detectMode();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (!mounted) return;
    
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || _currentBloc == null) return;
      
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        // Only load if query is different from last query
        if (query != _lastQuery) {
          _loadTracks(_currentBloc!, query: query, force: true);
        }
      } else {
        // Clear query and load random only if we had a query before
        if (_lastQuery != null) {
          _lastQuery = null;
          _loadTracks(_currentBloc!, random: true, force: true);
        }
      }
    });
  }

  void _detectMode() {
    final mode = RadioConfig.requestMode;
    _requestMode = mode;

    if (mode == 'webview') {
      return;
    }

    try {
      final radioBloc = getIt<RadioBloc>();
      final radioState = radioBloc.state;
      
      radioState.maybeWhen(
        loaded: (radioEntity) {
          _streamUrl = radioEntity.streamUrl;
        },
        orElse: () {},
      );

      if (_streamUrl != null && _streamUrl!.isNotEmpty) {
        final detectionService = AzuraCastDetectionService.instance;
        _isAzuracastAvailable = detectionService.isLikelyAzuraCastUrl(_streamUrl!);
      }
    } catch (e) {
      _isAzuracastAvailable = false;
    }

    if (mode == 'auto' && !_isAzuracastAvailable) {
      _requestMode = 'webview';
    }
  }

  void _loadTracks(RequestBloc bloc, {bool random = false, String? query, bool force = false}) {
    if (!mounted || _streamUrl == null || _streamUrl!.isEmpty) return;

    final finalQuery = query ?? (random ? null : _searchController.text.trim().isEmpty
        ? null
        : _searchController.text.trim());

    // Don't reload if query hasn't changed (unless it's random or forced)
    if (!force && !random && finalQuery == _lastQuery) {
      return;
    }

    // Update last query before making the call
    _lastQuery = finalQuery;

    bloc.add(RequestEvent.loadTracks(
      streamUrl: _streamUrl!,
      query: finalQuery,
      page: 1,
      limit: RadioConfig.requestListItemsPerPage,
      random: random,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_requestMode == 'webview' || !_isAzuracastAvailable) {
      return _WebViewRequestPage();
    }

    final bloc = getIt<RequestBloc>();
    _currentBloc = bloc;
    
    if (_isInitialLoad && bloc.state == const RequestState.initial()) {
      _isInitialLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _lastQuery = null; // Initialize last query for initial random load
          _loadTracks(bloc, random: true, force: true);
        }
      });
    }

    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: _buildAppBar(context, bloc),
        body: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const _RequestLoadingState(),
                    loaded: (tracks, page, hasMore) {
                      if (tracks.isEmpty) {
                        return _EmptyState(
                          onShuffle: () {
                            _lastQuery = null;
                            _loadTracks(bloc, random: true, force: true);
                          },
                        );
                      }
                      return _TrackList(
                        tracks: tracks,
                        scrollController: _scrollController,
                        onRequest: (track) => _submitRequest(bloc, track),
                      );
                    },
                    success: () => _SuccessState(
                      onReset: () {
                        bloc.add(const RequestEvent.reset());
                        _lastQuery = null;
                        _loadTracks(bloc, random: true, force: true);
                      },
                    ),
                    error: (failure) => _ErrorState(
                      failure: failure,
                      onRetry: () {
                        _lastQuery = null;
                        _loadTracks(bloc, random: true, force: true);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, RequestBloc bloc) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return AppBar(
      leading: IconButton(
        icon: const Icon(LucideIcons.arrow_left),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (context, value, child) {
          return Container(
            height: 40,
            decoration: BoxDecoration(
              color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
            ),
            child: TextField(
              controller: _searchController,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search songs or artists...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: colors.textSecondary,
                  size: 20,
                ),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          LucideIcons.x,
                          color: colors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          if (mounted) {
                            // Only reload if we had a query before
                            if (_lastQuery != null) {
                              _lastQuery = null;
                              _loadTracks(bloc, random: true, force: true);
                            }
                          }
                        },
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
              onSubmitted: (_) {
                if (!mounted) return;
                
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  // Only load if query is different from last query
                  if (query != _lastQuery) {
                    _loadTracks(bloc, query: query, force: true);
                  }
                } else {
                  // Clear query and load random only if we had a query before
                  if (_lastQuery != null) {
                    _lastQuery = null;
                    _loadTracks(bloc, random: true, force: true);
                  }
                }
              },
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.shuffle),
          tooltip: 'Random picks',
          onPressed: () {
            _lastQuery = null;
            _loadTracks(bloc, random: true, force: true);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _submitRequest(RequestBloc bloc, RequestableTrackEntity track) {
    if (_streamUrl == null || _streamUrl!.isEmpty) return;

    bloc.add(
      RequestEvent.submit(
        streamUrl: _streamUrl!,
        requestId: track.requestId,
        title: track.title,
        artist: track.artist,
      ),
    );
  }
}


class _TrackList extends StatelessWidget {
  final List<RequestableTrackEntity> tracks;
  final ScrollController scrollController;
  final Function(RequestableTrackEntity) onRequest;

  const _TrackList({
    required this.tracks,
    required this.scrollController,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(DesignTokens.spacingL),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = tracks[index];
                return _TrackItem(
                  track: track,
                  onRequest: () => onRequest(track),
                );
              },
              childCount: tracks.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackItem extends StatelessWidget {
  final RequestableTrackEntity track;
  final VoidCallback onRequest;

  const _TrackItem({
    required this.track,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        border: Border.all(
          color: colors.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (track.albumArtUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              child: AppNetworkImage(
                imageUrl: track.albumArtUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: colors.surfaces.surfaceContainerHighest,
                  child: Icon(
                    LucideIcons.music,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.surfaces.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              ),
              child: Icon(
                LucideIcons.music,
                color: colors.textSecondary,
              ),
            ),
          SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: DesignTokens.spacingXs),
                Text(
                  track.artist,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: DesignTokens.spacingM),
          FilledButton.icon(
            onPressed: onRequest,
            icon: Icon(LucideIcons.send, size: 16),
            label: Text('Request'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primaryAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingM,
                vertical: DesignTokens.spacingS,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestLoadingState extends StatelessWidget {
  const _RequestLoadingState();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = colors.surfaces.surfaceContainerHighest;

    return ListView.builder(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      itemCount: RadioConfig.requestListItemsPerPage,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
          padding: EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
            border: Border.all(
              color: colors.borderSubtle,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              ShimmerContainer(
                width: 60,
                height: 60,
                borderRadius: DesignTokens.cornerRadiusCard,
                baseColor: skeletonColor.withValues(alpha: 0.3),
                highlightColor: skeletonColor.withValues(alpha: 0.5),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: DesignTokens.spacingXs),
                    ShimmerContainer(
                      width: 150,
                      height: 14,
                      borderRadius: 4,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(width: DesignTokens.spacingM),
              ShimmerContainer(
                width: 80,
                height: 36,
                borderRadius: DesignTokens.cornerRadiusButton,
                baseColor: skeletonColor.withValues(alpha: 0.3),
                highlightColor: skeletonColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onShuffle;

  const _EmptyState({required this.onShuffle});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off,
              size: 64,
              color: colors.textSecondary,
            ),
            SizedBox(height: DesignTokens.spacingL),
            Text(
              'No tracks found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: DesignTokens.spacingS),
            Text(
              'Try searching with different keywords or get random picks',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingXl),
            FilledButton.icon(
              onPressed: onShuffle,
              icon: Icon(LucideIcons.shuffle),
              label: Text('Get Random Picks'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: DesignTokens.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;

  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green,
              ),
            ),
            SizedBox(height: DesignTokens.spacingL),
            Text(
              'Request submitted successfully!',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingXl),
            FilledButton.icon(
              onPressed: onReset,
              icon: Icon(LucideIcons.refresh_cw),
              label: Text('Request Another'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: DesignTokens.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final dynamic failure;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: DesignTokens.spacingL),
            Text(
              'Failed to load tracks',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingS),
            Text(
              failure.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingXl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(LucideIcons.refresh_cw),
              label: Text('Retry'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: DesignTokens.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebViewRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final webViewUrl = RadioConfig.requestWebViewUrl;
    
    if (webViewUrl == null || webViewUrl.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('request_title'.tr()),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(DesignTokens.spacingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: DesignTokens.spacingL),
                Text(
                  'WebView URL not configured',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spacingS),
                Text(
                  'Please configure requestWebViewUrl in RadioConfig',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('request_title'.tr()),
      ),
      body: FutureBuilder<bool>(
        future: canLaunchUrl(Uri.parse(webViewUrl)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == true) {
            launchUrl(
              Uri.parse(webViewUrl),
              mode: LaunchMode.inAppWebView,
            );
            return Center(
              child: Text('Opening request page...'),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: DesignTokens.spacingL),
                Text(
                  'Cannot open request page',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
