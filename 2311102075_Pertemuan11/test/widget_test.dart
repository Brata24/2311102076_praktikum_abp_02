import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_cart_app/main.dart';

void main() {
  testWidgets('adds product to cart and updates count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Keranjang: 0'), findsOneWidget);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
    await tester.pump();

    expect(find.text('Keranjang: 1'), findsOneWidget);
    expect(find.textContaining('Laptop'), findsWidgets);
  });
}
