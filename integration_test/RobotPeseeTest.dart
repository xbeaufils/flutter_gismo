import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotPeseeTest extends RobotTest {

  RobotPeseeTest(super.tester);

  void create() async {
    await startAppli();
    final echo = findWelcomeButton("Pesée");
    print(echo);
    await tester.tap(echo);
    await tester.pumpAndSettle();
    await selectBete( "123");
    // Passage à l'ecran Echo Graphie
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    Finder datePeseeFinder = find.byWidgetPredicate(
            (Widget widget) => widget is TextFormField && widget.controller!.text == DateFormat.yMd().format(now));
    expect(datePeseeFinder,findsOneWidget);
    await tester.tap(datePeseeFinder);
    await tester.pumpAndSettle();
    String datePesee =  (now.day > 7) ? (now.day - 7).toString(): (now.day + 1).toString();
    await tester.tap(find.text(datePesee));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
    Finder poidsTxt = find.ancestor(of: find.text('Poids'),matching: find.byType(TextFormField),);
    await tester.enterText(poidsTxt, "25.2");
    await tester.pumpAndSettle();
    await tester.tap(find.text("Enregistrer"));
    await tester.pumpAndSettle();

  }
}