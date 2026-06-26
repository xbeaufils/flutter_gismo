import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotCoproTest extends RobotTest {

  RobotCoproTest(super.tester);

  Future<void> create(Map<String, dynamic> copro) async {
    await startAppli();
    final Finder copro = await findWelcomeButton(Key("btSante"), S.current.result_copro);
    await tester.tap(copro);
    await tester.pumpAndSettle();
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);

  }

}