import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcapp/pages/codigo_contrasena/codigo_contrasena.dart';

void main() {
  testWidgets('verification code screen renders the six digit inputs', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CodigoContrasenaPage()));

    expect(find.textContaining('código de verificación'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
    expect(find.text('Confirmar registro'), findsOneWidget);
  });

  testWidgets('valid verification code opens the new password screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CodigoContrasenaPage()));

    for (var index = 0; index < 6; index++) {
      await tester.enterText(find.byType(TextField).at(index), '${index + 1}');
    }

    await tester.tap(find.text('Confirmar registro'));
    await tester.pumpAndSettle();

    expect(find.text('Cambiar'), findsOneWidget);
  });
}
