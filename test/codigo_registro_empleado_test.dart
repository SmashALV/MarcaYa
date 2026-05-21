import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcapp/pages/codigo_registro_empleado/codigo_registro_empleado.dart';
import 'package:marcapp/pages/confirmacion_registrar_empleado/confirmacion_registrar_empleado.dart';

void main() {
  testWidgets('employee registration code screen renders the verification UI', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CodigoRegistroEmpleadoPage()),
    );

    expect(find.textContaining('código de verificación'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
    expect(find.text('Confirmar registro'), findsOneWidget);
  });

  testWidgets('valid employee registration code opens employee confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CodigoRegistroEmpleadoPage()),
    );

    for (var index = 0; index < 6; index++) {
      await tester.enterText(find.byType(TextField).at(index), '${index + 1}');
    }

    await tester.tap(find.text('Confirmar registro'));
    await tester.pumpAndSettle();

    expect(find.byType(ConfirmacionRegistrarEmpleadoPage), findsOneWidget);
  });
}
