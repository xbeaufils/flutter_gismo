
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'RobotTest.dart';

class RobotLotTest extends RobotTest {

  RobotLotTest(super.tester);

  void createLot() async {
    await startAppli();
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
    await selectBete("123");
    await tester.pumpAndSettle();
    // 2 eme affectation
    await tester.tap(btSearch);
    await tester.pumpAndSettle();
    await selectBete("456");
    await tester.pumpAndSettle();


  }
}