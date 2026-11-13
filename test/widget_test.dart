import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/widgets/section_title.dart';

// Kept in the project so `flutter create .` doesn't generate the default
// counter-app test (which would fail against this app).
void main() {
  testWidgets('SectionTitle shows its title and trailing text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionTitle(title: 'Menu', trailing: '10 items')),
      ),
    );
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('10 items'), findsOneWidget);
  });
}
