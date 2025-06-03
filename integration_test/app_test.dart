import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/repository/LocalRepository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gismo/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
   group('end-to-end test', () {
     setUpAll(()  async {
      LocalRepository repo = LocalRepository();
      await repo.resetDatabase();
      FlutterSecureStorage storage = new FlutterSecureStorage();
      await storage.deleteAll();
     });

     /*
    testWidgets('Start appli', (tester,) async {
    });*/
    testWidgets(
        'Créez une entrée', (tester,) async {
          await startAppli(tester);
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
          await tester.pump();
          await createBete(tester, "123", "456789", "brebis1", "obs1");
          await createBete(tester, "456", "456789", "brebis2", "obs2");
          await createBete(tester, "789", "456789", "brebis3", "obs3");
          final btSave = find.text("Enregistrer");
          await tester.tap(btSave);
        });
    testWidgets(
        'Créez une echographie', (tester,) async {
      await startAppli(tester);
      final echo = find.text("Echographie");
      print(echo);
      await tester.tap(echo);
      await tester.pumpAndSettle();
      await selectBete(tester, "123");
      DateTime now = DateTime.now();
      expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
      final resultat = find.text("Simple");
      await tester.tap(resultat);
      await tester.tap(find.byKey(Key("dateEcho")));
      String dateEcho =  (now.day > 7) ? (now.day - 7).toString(): (now.day + 1).toString();
      await tester.tap(find.text(dateEcho));
      await tester.tap(find.text("OK"));
      await tester.tap(find.byKey(Key("dateSaillie")));
      await tester.tap(find.text("OK"));
    });
   });
}

Future<void> createBete(WidgetTester tester, String numboucle, String numMarquage, String nom, String obs ) async {
  final btPlus = find.byIcon(Icons.add);
  await tester.tap(btPlus);
  await tester.pumpAndSettle();
  var numboucleTxt = find.ancestor(of: find.text('Numero boucle'),matching: find.byType(TextFormField),);
  print (numboucleTxt);
  await tester.enterText(numboucleTxt, numboucle);
  var numMarquageTxt = find.ancestor(of: find.text('Numero marquage'),matching: find.byType(TextFormField),);
  await tester.enterText(numMarquageTxt, numMarquage);
  var nomTxt = find.ancestor(of: find.text('Petit nom'),matching: find.byType(TextFormField),);
  await tester.enterText(nomTxt, nom);
  var sexeRd = find.text("Femelle");
  await tester.tap(sexeRd);
  var obsTxt = find.ancestor(of: find.text('Observations'),matching: find.byType(TextFormField),);
  await tester.enterText(obsTxt, obs);
  var addBt = find.text("Ajouter");
  await tester.tap(addBt);
  await tester.pumpAndSettle();
}

Future<void> selectBete(WidgetTester tester, String numboucle) async {
  final btSearch = find.byIcon(Icons.search);
  await tester.tap(btSearch);
  final rowBete = find.text(numboucle);
  await tester.tap(rowBete);
}

Future<void> startAppli(WidgetTester tester) async {
  // Load app widget.
  await tester.pumpWidget(GismoApp(gismoBloc, RunningMode.test, initialRoute: '/splash'));
  final splash = find.byKey(ValueKey('splashScreen'));
  print(splash);
  await tester.pumpAndSettle();

}