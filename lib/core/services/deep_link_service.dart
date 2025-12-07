import '../../config/app_config.dart';
import '../../features/wordpress/domain/entities/post_entity.dart';
import '../../features/wordpress/domain/repositories/wordpress_repository.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/debug_logger.dart';

class DeepLinkService {
  static final WordPressRepository _repository = getIt<WordPressRepository>();

  static bool _isExcludedPath(String path) {
    final excludedPaths = [
      '/wp-admin',
      '/wp-content/uploads',
      '/wp-json',
      '/wp-includes',
    ];
    return excludedPaths.any((excluded) => path.startsWith(excluded));
  }

  static String _normalizeUrl(String url) {
    try {
      Uri uri = Uri.parse(url);

      if (!uri.hasScheme) {
        uri = Uri.parse('https://$url');
      }

      if (uri.scheme == 'http') {
        uri = uri.replace(scheme: 'https');
      }

      final normalizedPath = uri.path
          .replaceAll(RegExp(r'/+'), '/')
          .replaceAll(RegExp(r'/$'), '');

      final queryParams = Map<String, String>.from(uri.queryParameters);
      queryParams.removeWhere(
        (key, value) =>
            key.startsWith('utm_') ||
            key == 'amp' ||
            key == 'm' ||
            key == 'fbclid' ||
            key == 'gclid',
      );

      return uri
          .replace(
            path: normalizedPath,
            queryParameters: queryParams.isEmpty ? null : queryParams,
          )
          .toString();
    } catch (e) {
      return url;
    }
  }

  static bool isInternalLink(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return true;
      }

      final host = uri.host.toLowerCase();

      for (final allowedDomain in AppConfig.allowedDomains) {
        final domain = allowedDomain.toLowerCase();
        if (host == domain || host.endsWith('.$domain')) {
          if (host.contains('cdn.') || host.contains('static.')) {
            return false;
          }
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  static int? _extractPostIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      final queryParams = uri.queryParameters;
      if (queryParams.containsKey('p')) {
        final postId = int.tryParse(queryParams['p'] ?? '');
        if (postId != null && postId > 0) {
          return postId;
        }
      }

      final path = uri.path;

      final numericArchiveMatch = RegExp(r'/archives?/(\d+)').firstMatch(path);
      if (numericArchiveMatch != null) {
        final postId = int.tryParse(numericArchiveMatch.group(1) ?? '');
        if (postId != null && postId > 0) {
          return postId;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static String? _extractSlugFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;

      if (_isExcludedPath(path)) {
        return null;
      }

      final pathSegments = path.split('/').where((s) => s.isNotEmpty).toList();

      if (pathSegments.isEmpty) {
        return null;
      }

      final lastSegment = pathSegments.last;

      if (RegExp(r'^\d{4}$').hasMatch(lastSegment)) {
        return null;
      }

      if (RegExp(r'^\d{2}$').hasMatch(lastSegment)) {
        return null;
      }

      if (RegExp(r'^\d{1,2}$').hasMatch(lastSegment)) {
        return null;
      }

      if (lastSegment.contains('.')) {
        return null;
      }

      return lastSegment;
    } catch (e) {
      return null;
    }
  }

  static Future<PostEntity?> resolvePostFromUrl(String url) async {
    try {
      final normalizedUrl = _normalizeUrl(url);

      if (!isInternalLink(normalizedUrl)) {
        return null;
      }

      final uri = Uri.parse(normalizedUrl);
      final path = uri.path;

      if (_isExcludedPath(path)) {
        return null;
      }

      final postId = _extractPostIdFromUrl(normalizedUrl);
      if (postId != null) {
        final result = await _repository.getPostById(postId);
        return result.fold(
          (failure) => null,
          (post) => post,
        );
      }

      final slug = _extractSlugFromUrl(normalizedUrl);
      if (slug != null && slug.isNotEmpty) {
        final result = await _repository.getPostBySlug(slug);
        return result.fold(
          (failure) => null,
          (post) => post,
        );
      }

      return null;
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Error resolving post from URL',
        error: e,
        stackTrace: stackTrace,
        tag: 'DeepLink',
      );
      return null;
    }
  }
}
