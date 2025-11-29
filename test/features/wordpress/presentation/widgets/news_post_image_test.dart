import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tujuhcahaya_wprs/features/wordpress/presentation/widgets/news_post_image.dart';

void main() {
  setUp(() {
    CachedNetworkImage.logLevel = CacheManagerLogLevel.none;
  });

  testWidgets('shows skeleton placeholder while loading', (tester) async {
    // Arrange
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NewsPostImage(
            imageUrl: 'https://example.com/image.jpg',
            semanticLabel: 'Example image',
          ),
        ),
      ),
    );

    // Act
    await tester.pump();

    // Assert
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('includes semantic label for accessibility', (tester) async {
    // Arrange
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NewsPostImage(
            imageUrl: 'https://example.com/image.jpg',
            semanticLabel: 'News image label',
          ),
        ),
      ),
    );

    // Act
    final semantics = tester.getSemantics(find.byType(Semantics));

    // Assert
    expect(semantics.label, 'News image label');
  });
}


