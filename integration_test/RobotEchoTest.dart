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
      case 0:await tester.tap(find.text(S.current.empty));
        break;
      case 1:await tester.tap(find.text(S.current.simple));
        break;
      case 2:await tester.tap(find.text(S.current.double));
        break;
      case 3:await tester.tap(find.text(S.current.triplet));
        break;
    }
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("dateEcho")), echoData["dateEcho"]);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("dateSaillie")), echoData["dateSaillie"]);
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.bt_save));
    await tester.pumpAndSettle();
  }
}