import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcapp/pages/administrar_paradas/administrar_paradas.dart';
import 'package:marcapp/pages/resumen_empresa/resumen_empresa.dart';

void main() {
  testWidgets('company dashboard renders default zero metrics', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResumenEmpresaPage()));

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Constructora XYZ'), findsOneWidget);
    expect(find.text('Asistencias'), findsOneWidget);
    expect(find.text('Paradas'), findsOneWidget);
    expect(find.text('+0%'), findsOneWidget);
    expect(find.text('0 / 0'), findsOneWidget);
    expect(find.text('Acciones rápidas'), findsOneWidget);
  });

  testWidgets('quick action opens site management screen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResumenEmpresaPage()));

    await tester.ensureVisible(find.text('Administrar sitios'));
    await tester.tap(find.text('Administrar sitios'));
    await tester.pumpAndSettle();

    expect(find.byType(AdministrarParadasPage), findsOneWidget);
  });
}
