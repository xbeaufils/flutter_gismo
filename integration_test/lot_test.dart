
import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotLotTest extends RobotTest {

  final DateTime now = DateTime.now();

  RobotLotTest(super.tester);

  Future<void> create(Map<String, dynamic> lot) async {
    await startAppli();
    await tester.tap(findWelcomeButton(S.current.batch));
    await tester.pumpAndSettle();
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    // Saisie du lot
    Finder nomLotTxt = find.ancestor(of: find.text( S.current.batch_name),matching: find.byType(TextFormField),);
    await tester.enterText(nomLotTxt, lot["nom"]);
    await tester.pumpAndSettle();
    DateTime debut = frenchForm.parse(lot["debut"] + now.year.toString());
    await tester.enterText(find.byKey(Key("dateDebut")), DateFormat.yMd().format(debut));
    await tester.pumpAndSettle();
    DateTime fin = frenchForm.parse(lot["fin"] + now.year.toString());
    await tester.enterText(find.byKey(Key("dateFin")), DateFormat.yMd().format(fin));
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('ewe')));
    await tester.pumpAndSettle();
    final btSearch = find.byIcon(Icons.settings_remote);
    for (Map<String, dynamic> bete in lot["brebis"]) {
      await tester.tap(btSearch);
      await tester.pumpAndSettle();
      await selectBete(bete["numero"]);
      await tester.pumpAndSettle();
    }
  }

  Future<void> modifyEnd(Map<String, dynamic> lot) async {
    await startAppli();
    await tester.tap(findWelcomeButton(S.current.batch));
    await tester.pumpAndSettle();
    Finder btView = super.findByChevron(lot["nom"]);
    await tester.tap(btView);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("ewe")));
    await tester.pumpAndSettle();
    btView  = super.findByCalendar(lot["bete"]);
    await tester.tap(btView);
    await tester.pumpAndSettle();
    Finder finTxt = find.ancestor(of: find.text(S.current.dateDeparture),matching: find.byType(TextFormField),);
    DateTime fin = frenchForm.parse(lot["fin"] + now.year.toString());
    await tester.enterText(finTxt, DateFormat.yMd().format(fin));
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();
  }

  Future<void> modifyBegin(Map<String, dynamic> lot) async {
    await startAppli();
    await tester.tap(findWelcomeButton("Lot"));
    await tester.pumpAndSettle();
    Finder btView = super.findByChevron(lot["nom"]);
    await tester.tap(btView);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("ewe")));
    await tester.pumpAndSettle();
    btView  = super.findByCalendar(lot["bete"]);
    await tester.tap(btView);
    await tester.pumpAndSettle();
    Finder finTxt = find.ancestor(of: find.text(S.current.dateDeparture),matching: find.byType(TextFormField),);
    DateTime fin = frenchForm.parse(lot["fin"] + now.year.toString());
    await tester.enterText(finTxt,DateFormat.yMd().format(fin));
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();
  }

}