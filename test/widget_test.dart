import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:escala_mais/main.dart';

void main() {
  testWidgets('App launches and shows route list screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: EscalaMaisApp()));

    // Verify that the app bar with "Climbing Routes" is displayed.
    expect(find.text('Climbing Routes'), findsOneWidget);
  });
}
