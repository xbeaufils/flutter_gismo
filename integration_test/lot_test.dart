
import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import 'RobotTest.dart';

class RobotLotTest extends RobotTest {

  RobotLotTest(super.tester);

  void create(Map<String, dynamic> lot) async {
    await startAppli();
    await tester.tap(findWelcomeButton("Lot"));
    await tester.pumpAndSettle();
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    // Saisie du lot
    Finder nomLotTxt = find.ancestor(of: find.text('Nom lot'),matching: find.byType(TextFormField),);
    await tester.enterText(nomLotTxt, lot["nom"]);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("dateDebut")), lot["debut"]);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("dateFin")), lot["fin"]);
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
}