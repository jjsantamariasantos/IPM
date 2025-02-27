import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pillbellv2/fake_data.dart';
import 'package:pillbellv2/objects.dart';
import 'package:provider/provider.dart';

import 'package:pillbellv2/main.dart';
import 'package:pillbellv2/model.dart';
import 'package:pillbellv2/external_sevice.dart';

Widget createApp() {
  return ChangeNotifierProvider(
    create: (context) => Proveedor(externalService: MedicationApiMock()),
    child: const MainApp(),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de integración end-to-end', () {

    testWidgets('Flujo completo: Login, Home, Calendario, Detalles de medicamento', (tester) async {

      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      expect(find.text('Tu salud, nuestro mejor galardón.'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), '911-02-0747');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('Paciente:\nEmiliano Rodriguez'), findsOneWidget);
      expect(find.text('Medicamentos Actuales:'), findsOneWidget);

      Finder listFinder = find.byType(Scrollable);
      expect(listFinder, findsOne);
      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable).first;
      final gesture = await tester.startGesture(tester.getCenter(scrollable));
      
      for (int i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(0, -100));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await gesture.up();
      await tester.pumpAndSettle();

      final gesture2 = await tester.startGesture(tester.getCenter(scrollable));
      for (int i = 0; i < 5; i++) {
        await gesture2.moveBy(const Offset(0, 100));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await gesture2.up();
      await tester.pumpAndSettle();

      Finder backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Historial de medicamentos'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tomas'));
      await tester.pumpAndSettle();

      expect(find.text('Recordatorios:'), findsOneWidget);

      final proveedor = tester.element(find.byType(CalendarioScreen)).read<Proveedor>();
      expect(find.text(proveedor.obtenerFechaFormateada()), findsOneWidget);

      final listFinderCalendario = find.byType(Scrollable);
      expect(listFinderCalendario, findsOne);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text(proveedor.obtenerFechaFormateada()), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      expect(find.text(proveedor.obtenerFechaFormateada()), findsOneWidget);

      await tester.tap(find.text('Alarmas'));
      await tester.pumpAndSettle();
    });

    testWidgets('Verificar info', (tester) async {

      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '911-02-0747');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      final proveedor = Provider.of<Proveedor>(tester.element(find.byType(MainApp)), listen: false);

      expect(proveedor.pacienteActual?.code, equals('911-02-0747'));
      expect(proveedor.pacienteActual?.surname, equals('Rodriguez'));
      expect(proveedor.pacienteActual?.name, equals('Emiliano'));
      expect(proveedor.pacienteActual?.id, equals(1));
      
      List<IntakesDetailed> listAuxIntakes = listintakesDetail.map((item) => IntakesDetailed.fromJson(item)).toList();
      bool cumpleCon = proveedor.listaMedicinasActuales.every((medicina) => listAuxIntakes.any((aux) => aux == medicina));

      expect(cumpleCon, isTrue);
      
      await tester.tap(find.text('Historial de medicamentos'));
      await tester.pumpAndSettle();

      expect(proveedor.actuallistaDetailed, equals(listAuxIntakes));

      IntakesDetailed medicacionSeleccionada = proveedor.listaMedicinasActuales.first;

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      cumpleCon = listAuxIntakes.any((med) => med  == medicacionSeleccionada);

      expect(cumpleCon, isTrue);

      Finder backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      backButton = find.byTooltip('Back');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

    });

    testWidgets('Evaluar el post', (tester) async{

      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '911-02-0747');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      final proveedor = Provider.of<Proveedor>(tester.element(find.byType(MainApp)), listen: false);

      await tester.tap(find.text('Tomas'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      expect(find.text('Confirmar toma'), findsOneWidget);
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(proveedor.posologiasActuales.first.mark, isTrue);

    });

  });
  
}