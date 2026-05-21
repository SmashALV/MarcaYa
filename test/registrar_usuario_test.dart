import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcapp/pages/registrar_usuario/registrar_usuario.dart';

void main() {
  testWidgets('employee option opens employee registration screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegistrarUsuarioPage()));

    await tester.tap(find.text('Empleado'));
    await tester.pumpAndSettle();

    expect(find.text('Registrar empleado'), findsOneWidget);
    expect(find.text('Nombre de usuario'), findsOneWidget);
  });
}
