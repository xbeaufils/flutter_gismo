import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  int count = 0;
  String dataTest = await rootBundle.loadString('resource_test/data.json');
  final Map<String, dynamic>  jsonData = jsonDecode(dataTest);
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
          final Finder btEntree = findWelcomeButton("Entrée");
          print(btEntree);
          await tester.tap(btEntree);
          await tester.pumpAndSettle();
          DateTime now = DateTime.now();
          expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
          DateFormat isoFormat = DateFormat("yyyy-MM-dd");
          Map<String, dynamic> entree = jsonData["entree"];
          await tester.enterText(find.text(DateFormat.yMd().format(now)), entree["date"]);
          final dropDown = find.byKey(Key("Motif_Key"));
          print (dropDown);
          await tester.tap(dropDown);
          await tester.pump();
          final btCreation = find.text("Creation");
          await tester.tap(btCreation);
          await tester.pump();
          for (Map<String, dynamic> bete in entree["betes"])
            await createBete(
                tester, bete["numBoucle"], bete["numMarquage"], bete["nom"],
                bete["observation"]);
          final btSave = find.text("Enregistrer");
          await tester.tap(btSave);
        });
 //   testAgnelage();
 //   testLot();
 //   testEcho();
      testTraitement(jsonData["traitements"]);
 //    testPesee();
   });
}

Finder findWelcomeButton(String text) {
  final Finder entreeGrid = find.ancestor(
      of: find.text(text), matching: find.byType(GridTile));
  final Finder entree = find.descendant(
      of: entreeGrid, matching: find.byType(FilledButton));
  return entree;
}

Future<void> createBete(WidgetTester tester, String numboucle, String numMarquage, String nom, String ? obs ) async {
  final btPlus = find.byIcon(Icons.add);
  await tester.tap(btPlus);
  await tester.pumpAndSettle();
  var numboucleTxt = find.ancestor(of: find.text('Numero boucle'),matching: find.byType(TextField),);
  print (numboucleTxt);
  await tester.enterText(numboucleTxt, numboucle);
  var numMarquageTxt = find.ancestor(of: find.text('Numero marquage'),matching: find.byType(TextField),);
  await tester.enterText(numMarquageTxt, numMarquage);
  var nomTxt = find.ancestor(of: find.text('Petit nom'),matching: find.byType(TextFormField),);
  await tester.enterText(nomTxt, nom);
  var sexeRd = find.text("Femelle");
  await tester.tap(sexeRd);
  var obsTxt = find.ancestor(of: find.text('Observations'),matching: find.byType(TextFormField),);
  await tester.enterText(obsTxt, obs!);
  var addBt = find.text("Ajouter");
  await tester.tap(addBt);
  await tester.pumpAndSettle();
}

Future<void> selectBete(WidgetTester tester, String numboucle) async {
  final btSearch = find.byKey(ValueKey("searchBar"));
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
    final echo = findWelcomeButton("Echographie");
    print(echo);
    await tester.tap(echo);
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    // Passage à l'ecran Echo Graphie
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    Finder resultat = find.text("Simple");
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

Future<void> testPesee() async {
  testWidgets(
      'Saisir une pesée', (tester,) async {
    await startAppli(tester);
    final echo = findWelcomeButton("Pesée");
    print(echo);
    await tester.tap(echo);
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    // Passage à l'ecran Echo Graphie
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    Finder datePeseeFinder = find.byWidgetPredicate(
            (Widget widget) => widget is TextFormField && widget.controller!.text == DateFormat.yMd().format(now));
    expect(datePeseeFinder,findsOneWidget);
    await tester.tap(datePeseeFinder);
    await tester.pumpAndSettle();
    String datePesee =  (now.day > 7) ? (now.day - 7).toString(): (now.day + 1).toString();
    await tester.tap(find.text(datePesee));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    Finder poidsTxt = find.ancestor(of: find.text('Poids'),matching: find.byType(TextFormField),);
    await tester.enterText(poidsTxt, "25.2");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();
  });

}

Future<void> testTraitement(Map<String, dynamic> traitement ) async {
  testWidgets(
      'Saisir un traitement', (tester,) async {
    await startAppli(tester);
    final trt = findWelcomeButton("Traitement");
    print(trt);
    await tester.tap(trt);
    await tester.pumpAndSettle();
    final btSearch = find.byIcon(Icons.settings_remote);
    for (Map<String, dynamic> bete in traitement["betes"]) {
      await tester.tap(btSearch);
      await tester.pumpAndSettle();
      await selectBete(tester, bete["numero"]);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text("Continuer"));
    await tester.pumpAndSettle(Duration(seconds: 2));
    //await tester.tap(find.byKey(Key("dateDebut")));
    await tester.enterText(find.byKey(Key("dateDebut")), traitement["debut"]);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("dateFin")), traitement["fin"]);
    await tester.pumpAndSettle();
    Finder ordonnanceTxt = find.ancestor(of: find.text('Ordonnance'),matching: find.byType(TextFormField),);
    await tester.enterText(ordonnanceTxt, traitement["ordonnance"]);
    for (Map<String, dynamic> medicament in traitement["medicaments"]) {
      await tester.tap(find.text("Ajouter medicament"));
      await tester.pumpAndSettle();
      var MedicamentTxt = find.ancestor(of: find.text('Medicament'),matching: find.byType(TextFormField),);
      await tester.enterText(MedicamentTxt, medicament["nom"]);
      var voieTxt = find.ancestor(of: find.text('Voie'),matching: find.byType(TextFormField),);
      await tester.enterText(voieTxt, medicament["voie"]);
      var doseTxt = find.ancestor(of: find.text('Dose'),matching: find.byType(TextFormField),);
      await tester.enterText(doseTxt, medicament["dose"]);
      var rythmeTxt = find.ancestor(of: find.text('Rythme'),matching: find.byType(TextFormField),);
      await tester.enterText(rythmeTxt, medicament["rythme"]);
      await tester.tap(find.text("Ajouter"));
      await tester.pumpAndSettle();
    }
    var interTxt = find.ancestor(of: find.text('Intervenant'),matching: find.byType(TextFormField),);
    await tester.enterText(interTxt, traitement["intervenant"]);
    var motifTxt = find.ancestor(of: find.text('Motif'),matching: find.byType(TextFormField),);
    await tester.enterText(motifTxt, traitement["motif"]);
    var obsTxt = find.ancestor(of: find.text('Observations'),matching: find.byType(TextFormField),);
    await tester.enterText(obsTxt, traitement["observation"]);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.close);
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();
  });

}

Future<void> testAgnelage() async {
  testWidgets("Saisir un agnelage", (tester,) async {
    await startAppli(tester);
    await tester.tap(findWelcomeButton("Agnelage"));
    await tester.pumpAndSettle();
    await selectBete(tester, "123");
    // Passage à l'ecran Agnelage
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(
        find.byWidgetPredicate(
              (Widget widget) => widget is TextFormField && widget.controller!.text == DateFormat.yMd().format(now)),
        findsOneWidget);

    await tester.tap(find.byKey(Key("btQualite")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("3"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("btAdoption")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("2"));
    await tester.pumpAndSettle();
    // Ajout d'un agneau
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    Finder numProvisoireTxt = find.ancestor(of: find.text(S.current.provisional_number),matching: find.byType(TextField),);
    await tester.enterText(numProvisoireTxt, "123-1");
    Finder sexe = find.text(S.current.female);
    await tester.tap(sexe);
    Finder etat = find.text("Vivant");
    await tester.tap(etat);
    await tester.tap(find.text(MethodeAllaitement.ALLAITEMENT_MATERNEL.libelle));
    await tester.pump(const Duration(seconds: 1)); // finish the menu animation
    await tester.tap(find.text(MethodeAllaitement.BIBERONNE.libelle));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // finish the menu animation
    Finder btSave = find.text(S.current.bt_add);
    await tester.tap(btSave);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.tap(find.text( Intl.message("validate_lambing") ));
  });


}

Future<void> testLot() async {
  testWidgets("Saisir un lot", (tester,) async {
    await startAppli(tester);
    await tester.tap(findWelcomeButton("Lot"));
    await tester.pumpAndSettle();
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    // Saisie du lot
    Finder nomLotTxt = find.ancestor(of: find.text('Nom lot'),matching: find.byType(TextFormField),);
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
