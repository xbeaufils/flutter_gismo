import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import 'RobotTest.dart';

class RobotTestTraitement extends RobotTest {

  RobotTestTraitement(super.tester);

  Future<void> createTraitement(Map<String, dynamic> traitement) async {
      await startAppli();
      final trt = findWelcomeButton(S.current.treatment);
      await tester.tap(trt);
      await tester.pumpAndSettle();
      final btSearch = find.byIcon(Icons.settings_remote);
      for (Map<String, dynamic> bete in traitement["betes"]) {
        await tester.tap(btSearch);
        await tester.pumpAndSettle();
        await selectBete(bete["numero"]);
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(S.current.bt_continue));
      await tester.pumpAndSettle(Duration(seconds: 2));
      //await tester.tap(find.byKey(Key("dateDebut")));
      await tester.enterText(find.byKey(Key("dateDebut")), traitement["debut"]);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("dateFin")), traitement["fin"]);
      await tester.pumpAndSettle();
      Finder ordonnanceTxt = find.ancestor(
        of: find.text('Ordonnance'), matching: find.byType(TextFormField),);
      await tester.enterText(ordonnanceTxt, traitement["ordonnance"]);
      for (Map<String, dynamic> medicament in traitement["medicaments"]) {
        await tester.tap(find.text(S.current.add_medication));
        await tester.pumpAndSettle();
        var MedicamentTxt = find.ancestor(
          of: find.text('Medicament'), matching: find.byType(TextFormField),);
        await tester.enterText(MedicamentTxt, medicament["nom"]);
        var voieTxt = find.ancestor(
          of: find.text('Voie'), matching: find.byType(TextFormField),);
        await tester.enterText(voieTxt, medicament["voie"]);
        var doseTxt = find.ancestor(
          of: find.text('Dose'), matching: find.byType(TextFormField),);
        await tester.enterText(doseTxt, medicament["dose"]);
        var rythmeTxt = find.ancestor(
          of: find.text('Rythme'), matching: find.byType(TextFormField),);
        await tester.enterText(rythmeTxt, medicament["rythme"]);
        await tester.tap(find.text(S.current.bt_add));
        await tester.pumpAndSettle();
      }
      var interTxt = find.ancestor(
        of: find.text('Intervenant'), matching: find.byType(TextFormField),);
      await tester.enterText(interTxt, traitement["intervenant"]);
      var motifTxt = find.ancestor(
        of: find.text('Motif'), matching: find.byType(TextFormField),);
      await tester.enterText(motifTxt, traitement["motif"]);
      var obsTxt = find.ancestor(
        of: find.text('Observations'), matching: find.byType(TextFormField),);
      await tester.enterText(obsTxt, traitement["observation"]);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.close);
      await tester.tap(find.text(S.current.bt_save));
      await tester.pumpAndSettle();
  }

  Future<void> modifyTraitement(Map<String, dynamic> traitement) async {
      await startAppli();
      await tester.tap(findWelcomeButton(S.current.sheep));
      await tester.pumpAndSettle();
      await selectBete(traitement["bete"]);
      await tester.pumpAndSettle();
      Finder tile = find.ancestor(
          of: find.text(traitement["medicament"]["ancien"]), matching: find.byType(ListTile));
      Finder btView = find.descendant(of: tile, matching: find.byType(IconButton));
      await tester.tap(btView);
      await tester.pumpAndSettle();
      await tester.enterText(find.text(traitement["medicament"]["ancien"]), traitement["medicament"]["nouveau"]);
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.current.bt_save));
      await tester.pumpAndSettle();
  }
}