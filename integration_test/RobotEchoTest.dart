import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotEchoTest extends RobotTest {
  RobotEchoTest(super.tester);

  Future<void> create(Map<String, dynamic> echoData) async {
    await startAppli();
    final echo = findWelcomeButton(S.current.ultrasound);
    print(echo);
    await tester.tap(echo);
    await tester.pumpAndSettle();
    await selectBete( echoData["numero"] );
    // Passage à l'ecran Echo Graphie
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    switch (echoData["nombre"]) {
      case 0:await tester.tap(find.byKey( Key("rdEmpty")));
        break;
      case 1:await tester.tap(find.byKey( Key("rdSimple")));
        break;
      case 2:await tester.tap(find.byKey( Key("rdDouble")));
        break;
      case 3:await tester.tap(find.byKey( Key("rdTriple")));
        break;
    }
    await tester.pumpAndSettle();
    DateTime echoDate = frenchForm.parse(echoData["dateEcho"] + now.year.toString());
    await tester.enterText(find.byKey(Key("dateEcho")), DateFormat.yMd().format(echoDate));
    await tester.pumpAndSettle();
    DateTime saillieDate = frenchForm.parse(echoData["dateSaillie"] + now.year.toString());
    await tester.enterText(find.byKey(Key("dateSaillie")),  DateFormat.yMd().format(saillieDate) );
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();
  }
}