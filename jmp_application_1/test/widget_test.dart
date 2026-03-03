import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jmp_application_1/main.dart';

void main() {
  testWidgets('Smoke test: muestra pantalla de splash con logo JMP', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(MyApp());

    // Esperamos a que termine cualquier animación inicial.
    await tester.pumpAndSettle();

    // Verificamos que el logo JMP esté presente.
    expect(find.text('JMP'), findsOneWidget);
  });
}