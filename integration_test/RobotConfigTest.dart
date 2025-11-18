import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import 'RobotTest.dart';

class RobotConfigTest extends RobotTest {
  RobotConfigTest(super.tester);

  Future<void> login() async {
    await startAppli();
    final ScaffoldState state = await tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.enterText(findByHint( S.current.email), "xbeaufils@gmail.com");
    await tester.pumpAndSettle();
    await tester.enterText(findByHint(S.current.password), "zaza");
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.connection));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();
    print("Totorial");

  }
}