import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotTestMouvement extends RobotTest {

  RobotTestMouvement(WidgetTester tester) : super(tester);


  Future<void> create(Map<String, dynamic> entree) async {
    await super.startAppli();
    final Finder btEntree = super.findWelcomeButton(S.current.input);
    await tester.tap(btEntree);
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    await tester.enterText(
        find.text(DateFormat.yMd().format(now)), entree["date"]);
    final dropDown = find.byKey(Key("Motif_Key"));
    await tester.tap(dropDown);
    await tester.pump();
    final btCreation = find.text(S.current.entree_creation);
    await tester.tap(btCreation);
    await tester.pump();
    for (Map<String, dynamic> bete in entree["betes"])
      await _createBete(
          bete["numBoucle"], bete["numMarquage"], bete["nom"], bete["sex"],
          bete["observation"]);
    final btSave = find.text(S.current.bt_save);
    await tester.tap(btSave);
  }

  Future<void> _createBete(String numboucle, String numMarquage, String nom, String sex,String ? obs) async {
    final btPlus = find.byIcon(Icons.add);
    await tester.tap(btPlus);
    await tester.pumpAndSettle();
    var numboucleTxt = find.ancestor(
      of: find.text(S.current.identity_number), matching: find.byType(TextField),);
    await tester.enterText(numboucleTxt, numboucle);
    var numMarquageTxt = find.ancestor(
      of: find.text(S.current.flock_number), matching: find.byType(TextField),);
    await tester.enterText(numMarquageTxt, numMarquage);
    var nomTxt = find.ancestor(
      of: find.text(S.current.name), matching: find.byType(TextFormField),);
    await tester.enterText(nomTxt, nom);
    var sexeRd = find.text(Intl.message(sex));
    await tester.tap(sexeRd);
    var obsTxt = find.ancestor(
      of: find.text(S.current.observations), matching: find.byType(TextFormField),);
    await tester.enterText(obsTxt, obs!);
    var addBt = find.text(S.current.bt_add);
    await tester.tap(addBt);
    await tester.pumpAndSettle();
  }

  Future<void> sortie(Map<String, dynamic> sortie) async {
    await super.startAppli();
    final Finder btSortie = super.findWelcomeButton(S.current.output);
    await tester.tap(btSortie);
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    await tester.enterText(
        find.text(DateFormat.yMd().format(now)), sortie["dateSortie"]);
    final dropDown = find.byKey(Key("motifSortie"));
    await tester.tap(dropDown);
    await tester.pump();
    final btCreation = find.text(S.current.output_boucherie);
    await tester.tap(btCreation);
    await tester.pump();
    for (Map<String, dynamic> bete in sortie["betes"]) {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await selectBete(bete["numero"]);
      await tester.pumpAndSettle();
    }
    final btSave = find.text(S.current.bt_save);
    await tester.tap(btSave);
  }
}