import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcapp/pages/registrar_empleado/registrar_empleado.dart';

void main() {
  testWidgets('employee registration screen renders the expected form', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegistrarEmpleadoPage()));

    expect(find.text('Registrar empleado'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(5));
    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('DNI'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Confirmar contraseña'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
  });

  testWidgets('valid employee data opens the verification code screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegistrarEmpleadoPage()));

    await tester.enterText(find.byType(TextField).at(0), 'Sebastian');
    await tester.enterText(find.byType(TextField).at(1), '12345678');
    await tester.enterText(find.byType(TextField).at(2), 'sebastian@mail.com');
    await tester.enterText(find.byType(TextField).at(3), '123456');
    await tester.enterText(find.byType(TextField).at(4), '123456');

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('código de verificación'), findsOneWidget);
    expect(find.text('Confirmar registro'), findsOneWidget);
  });
}
