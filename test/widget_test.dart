import 'package:flutter_test/flutter_test.dart';
import 'package:luxury_neo_bank/main.dart';

void main() {
  testWidgets('Obsidian Wealth App smoke test', (WidgetTester tester) async {
    // Build our app and trigger splash frame
    await tester.pumpWidget(const ObsidianWealthApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify initial splash branding
    expect(find.text('PRIVATE WEALTH • SOVEREIGN ASSETS'), findsWidgets);

    // Fast-forward past splash auto-navigation (3.5s)
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pump(const Duration(milliseconds: 700));

    // Verify key luxury dashboard elements are rendered
    expect(find.text('TOTAL BALANCE'), findsOneWidget);
    expect(find.text('Alexander Wright'), findsWidgets);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Request'), findsOneWidget);
  });
}
