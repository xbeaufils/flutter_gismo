
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotTestTraitement extends RobotTest {
  RobotTestTraitement(super.tester);
  final DateTime _now = DateTime.now();

  Future<void> create(Map<String, dynamic> traitement) async {
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
      for (Map<String, dynamic> medicament in traitement["medicaments"]) {
        await tester.tap(find.text(S.current.add_medication));
        await tester.pumpAndSettle();
        await this._tapeMedic(medicament);
        await tester.tap(find.text(S.current.bt_add));
        await tester.pumpAndSettle();
      }
      await this._tapeFiche(traitement);
      await tester.tap(find.text(S.current.bt_save));
      await tester.pumpAndSettle();
  }

  Future<void> _tapeFiche(Map<String, dynamic> traitement) async {
    DateTime debut = frenchForm.parse(traitement["debut"] + _now.year.toString());
    await tester.enterText(find.byKey(Key("dateDebut")), DateFormat.yMd().format(debut));
    DateTime fin = frenchForm.parse(traitement["fin"] + _now.year.toString());
    await tester.enterText(find.byKey(Key("dateFin")), DateFormat.yMd().format(fin));
    Finder ordonnanceTxt = find.ancestor(
      of: find.text(S.current.prescription), matching: find.byType(TextFormField),);
    await tester.enterText(ordonnanceTxt, traitement["ordonnance"]);
    await tester.pumpAndSettle();
    var interTxt = find.ancestor(
      of: find.text(S.current.contributor), matching: find.byType(TextFormField),);
    await tester.enterText(interTxt, traitement["intervenant"]);
    var motifTxt = find.ancestor(
      of: find.text(S.current.reason), matching: find.byType(TextFormField),);
    await tester.enterText(motifTxt, traitement["motif"]);
    var obsTxt = find.ancestor(
      of: find.text(S.current.observations), matching: find.byType(TextFormField),);
    await tester.enterText(obsTxt, traitement["observation"]);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.close);

  }

  Future<void> modify(Map<String, dynamic> traitement) async {
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
      DateTime ancien = frenchForm.parse(traitement["debut"]["ancien"] + _now.year.toString());
      DateTime nouveau = frenchForm.parse(traitement["debut"]["nouveau"] + _now.year.toString());
      await tester.enterText(find.text(DateFormat.yMd().format(ancien)), DateFormat.yMd().format(nouveau));
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.current.bt_save));
      await tester.pumpAndSettle();
  }

  Future<void> createForLamb(Map<String, dynamic> traitement) async {
    await startAppli();
    await super.selectLamb(traitement["numero"]);
    await tester.tap(find.byKey(Key("traitementBt")));
    await tester.pumpAndSettle();
    await this._tapeFiche(traitement);
    await tester.pumpAndSettle();
    await this._tapeMedic(traitement);
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();

  }

  Future<void> _tapeMedic(Map<String, dynamic> medicament) async  {
    var MedicamentTxt = find.ancestor(
      of: find.text(S.current.medication), matching: find.byType(TextFormField),);
    await tester.enterText(MedicamentTxt, medicament["nom"]);
    var voieTxt = find.ancestor(
      of: find.text(S.current.route), matching: find.byType(TextFormField),);
    await tester.enterText(voieTxt, medicament["voie"]);
    var doseTxt = find.ancestor(
      of: find.text(S.current.dose), matching: find.byType(TextFormField),);
    await tester.enterText(doseTxt, medicament["dose"]);
    var rythmeTxt = find.ancestor(
      of: find.text(S.current.rythme), matching: find.byType(TextFormField),);
    await tester.enterText(rythmeTxt, medicament["rythme"]);

  }
}