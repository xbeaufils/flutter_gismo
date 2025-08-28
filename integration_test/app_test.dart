import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  int count = 0;
  setUpAll(()  async {
    print("---------");
    print ("| count $count |");
    if (count == 0 ) {
      LocalRepository repo = LocalRepository();
      await repo.resetDatabase();
      FlutterSecureStorage storage = new FlutterSecureStorage();
      print("-------------------");
      print("| Delete database |");
      print("-------------------");
      await storage.deleteAll();
    }
    count ++;
  });
  group('end-to-end test', () {
    testWidgets(
        'Saisir une entrée', (tester,) async {
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
    testAgnelage();
    testLot();
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
  await tester.pumpWidget(GismoApp(RunningMode.test, initialRoute: '/splash'));
  final splash = find.byKey(ValueKey('splashScreen'));
  print(splash);
  await tester.pumpAndSettle();
}

Future<void> testEcho() async {
  testWidgets(
      'Saisir une echographie', (tester,) async {
    await startAppli(tester);
    final echo = find.text("Echographie");
    print(echo);
    await tester.tap(echo);
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    // Passage à l'ecran Echo Graphie
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    final resultat = find.text("Simple");
    await tester.tap(resultat);
    await tester.tap(find.byKey(Key("dateEcho")));
    await tester.pumpAndSettle();
    String dateEcho =  (now.day > 7) ? (now.day - 7).toString(): (now.day + 1).toString();
    await tester.tap(find.text(dateEcho));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("dateSaillie")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();
  });

}

Future<void> testTraitement() async {
  testWidgets(
      'Saisir un traitement', (tester,) async {
    await startAppli(tester);
    final trt = find.text("Traitement");
    print(trt);
    await tester.tap(trt);
    await tester.pumpAndSettle();
    final btSearch = find.byIcon(Icons.settings_remote);
    await tester.tap(btSearch);
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    await tester.pumpAndSettle();
    await tester.tap(btSearch);
    await tester.pumpAndSettle();
    await selectBete(tester, "456");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Continuer"));
    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(find.byKey(Key("dateDebut")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("5"));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("dateFin")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("15"));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    var ordonnanceTxt = find.ancestor(of: find.text('Ordonnance'),matching: find.byType(TextFormField),);
    await tester.enterText(ordonnanceTxt, "ord 1");
    var MedicamentTxt = find.ancestor(of: find.text('Medicament'),matching: find.byType(TextFormField),);
    await tester.enterText(MedicamentTxt, "Medoc");
    var voieTxt = find.ancestor(of: find.text('Voie'),matching: find.byType(TextFormField),);
    await tester.enterText(voieTxt, "Oral");
    var doseTxt = find.ancestor(of: find.text('Dose'),matching: find.byType(TextFormField),);
    await tester.enterText(doseTxt, "1 ml");
    var rythmeTxt = find.ancestor(of: find.text('Rythme'),matching: find.byType(TextFormField),);
    await tester.enterText(rythmeTxt, "2 / j");
    var interTxt = find.ancestor(of: find.text('Intervenant'),matching: find.byType(TextFormField),);
    await tester.enterText(interTxt, "Berger");
    var motifTxt = find.ancestor(of: find.text('Motif'),matching: find.byType(TextFormField),);
    await tester.enterText(motifTxt, "Malalde");
    var obsTxt = find.ancestor(of: find.text('Observations'),matching: find.byType(TextFormField),);
    await tester.enterText(obsTxt, "Observation");
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.close);
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();
  });

}

Future<void> testAgnelage() async {
  testWidgets("Saisir un agnelage", (tester,) async {
    await startAppli(tester);
    await tester.tap(find.text("Agnelage"));
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    // Passage à l'ecran Agnelage
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    await tester.tap(find.byKey(Key("btQualite")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("3"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("btAdoption")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("2"));
    await tester.pumpAndSettle();
  });


}

Future<void> testLot() async {
  testWidgets("Saisir un lot", (tester,) async {
    await startAppli(tester);
    await tester.tap(find.text("Lot"));
    await tester.pumpAndSettle();
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    // Saisie du lot
    var nomLotTxt = find.ancestor(of: find.text('Nom lot'),matching: find.byType(TextFormField),);
    await tester.enterText(nomLotTxt, "Lot test");
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("dateDebut")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("5"));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("dateFin")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("25"));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('ewe')));
    await tester.pumpAndSettle();
    final btSearch = find.byIcon(Icons.settings_remote);
    // 1 ere affectation
    await tester.tap(btSearch);
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    await tester.pumpAndSettle();
    // 2 eme affectation
    await tester.tap(btSearch);
    await tester.pumpAndSettle();
    await selectBete(tester, "456");
    await tester.pumpAndSettle();

  });
}
