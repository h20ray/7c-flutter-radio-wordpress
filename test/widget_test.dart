import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tujuhcahaya_wprs/main.dart';

void main() {
  testWidgets('App widget smoke test', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        path: 'assets/translations',
        startLocale: const Locale('id', 'ID'),
        fallbackLocale: const Locale('id', 'ID'),
        child: const TujuhCahayaApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
