import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotPeseeTest extends RobotTest {

  RobotPeseeTest(super.tester);

  Future<void> create(Map<String, dynamic> pesee) async {
    await startAppli();
    final weight = findWelcomeButton(S.current.weighing);
    await tester.tap(weight);
    await tester.pumpAndSettle();
    await selectBete( pesee["numero"]);
    // Passage à l'ecran Echo Graphie
    await tester.pumpAndSettle();
    await this._inputPesee(pesee);
  }

  Future<void> createPesee(Map<String, dynamic> pesee) async {
    await startAppli();
    await selectLamb(pesee["numero"]);
    await tester.tap(find.byKey( Key("peseeBt")));
    await tester.pumpAndSettle();
    await this._inputPesee(pesee);
  }

  Future<void> _inputPesee(Map<String, dynamic> pesee) async {
    DateTime now = DateTime.now();
    Finder datePeseeFinder = find.byWidgetPredicate(
            (Widget widget) => widget is TextFormField && widget.controller!.text == DateFormat.yMd().format(now));
    expect(datePeseeFinder,findsOneWidget);
    DateTime datePesee = frenchForm.parse(pesee["date"] + now.year.toString());
    await tester.enterText(datePeseeFinder, DateFormat.yMd().format(datePesee));
    await tester.pumpAndSettle();
    Finder poidsTxt = find.ancestor(of: find.text(S.current.weight),matching: find.byType(TextFormField),);
    await tester.enterText(poidsTxt, pesee["poids"]);
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();

  }
}