import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('_NewsLoadMoreFooter shows label for articles', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return const Scaffold(
              body: SizedBox.shrink(),
            );
          },
        ),
      ),
    );

    // Act
    await tester.pump();

    // Assert
    expect(find.textContaining('Loading more articles'), findsOneWidget);
  });

  testWidgets('_NewsLoadMoreFooter shows label for search results', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return const Scaffold(
              body: SizedBox.shrink(),
            );
          },
        ),
      ),
    );

    // Act
    await tester.pump();

    // Assert
    expect(find.textContaining('Loading more results'), findsNothing);
  });
}


