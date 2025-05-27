import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gismo/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
   group('end-to-end test', () {
    testWidgets(
        'Créez une entrée', (tester,) async {
          // Load app widget.
          await tester.pumpWidget(GismoApp(gismoBloc, initialRoute: '/splash'));
          final splash = find.byKey(ValueKey('splashScreen'));
          print(splash);
          await tester.pumpAndSettle();
          final entree = find.text("Entrée");
          print(entree);
          await tester.tap(entree);
          await tester.pumpAndSettle();
          DateTime now = DateTime.now();
          expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
          final dropDown = find.byKey(Key("Motif_Key"));
          print (dropDown);
          await tester.tap(dropDown);
          await tester.pump();
          final btCreation = find.text("Creation");
          await tester.tap(btCreation);
        });
   });
}