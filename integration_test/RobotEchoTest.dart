import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotEchoTest extends RobotTest {
  RobotEchoTest(super.tester);

  void create() async {
    await startAppli();
    final echo = findWelcomeButton("Echographie");
    print(echo);
    await tester.tap(echo);
    await tester.pumpAndSettle();
    await selectBete( "123");
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

  }
}