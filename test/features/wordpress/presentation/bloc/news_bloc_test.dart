import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tujuhcahaya_wprs/core/error/failures.dart';
import 'package:tujuhcahaya_wprs/features/wordpress/domain/entities/post_entity.dart';
import 'package:tujuhcahaya_wprs/features/wordpress/domain/repositories/wordpress_repository.dart';
import 'package:tujuhcahaya_wprs/features/wordpress/domain/usecases/get_posts.dart';
import 'package:tujuhcahaya_wprs/features/wordpress/presentation/bloc/news_bloc.dart';

class MockWordPressRepository implements WordPressRepository {
  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    bool forceRefresh = false,
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
    return const Right([]);
  }

  @override
  Future<List<PostEntity>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    return [];
  }

  @override
  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    return DateTime.now();
  }
}

class MockGetPosts extends GetPosts {
  MockGetPosts(super.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call({
    bool forceRefresh = false,
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
    return const Right([]);
  }
}

void main() {
  late NewsBloc newsBloc;
  late MockGetPosts mockGetPosts;
  late MockWordPressRepository mockWordPressRepository;

  setUp(() {
    mockWordPressRepository = MockWordPressRepository();
    mockGetPosts = MockGetPosts(mockWordPressRepository);
    newsBloc = NewsBloc(getPosts: mockGetPosts);
  });

  tearDown(() {
    newsBloc.close();
  });

  test('initial state should be NewsState.initial()', () {
    expect(newsBloc.state, const NewsState.initial());
  });

  test('emits state change when GetPostsEvent is added', () async {
    // Act
    newsBloc.add(const NewsEvent.getPosts(useNewsPageLimit: true));

    // Assert
    await expectLater(
      newsBloc.stream,
      emitsThrough(isA<NewsState>()),
    );
  });
}
