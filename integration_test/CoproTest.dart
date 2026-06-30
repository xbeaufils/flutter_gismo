import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotCoproTest extends RobotTest {

  RobotCoproTest(super.tester);

  Future<void> create(Map<String, dynamic> copro) async {
    await startAppli();
    final Finder btCopro = await findWelcomeButton(Key("btSante"), S.current.result_copro);
    await tester.tap(btCopro);
    await tester.pumpAndSettle();
    final btAdd = find.byIcon(Icons.add);
    await tester.tap(btAdd);
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
    Finder dateCoproFinder = find.byWidgetPredicate(
            (Widget widget) => widget is TextField && widget.controller!.text == DateFormat.yMd().format(now));
    expect(dateCoproFinder,findsOneWidget);
    DateTime dateCopro = frenchForm.parse(copro["datePrelevement"] + now.year.toString());
    await tester.enterText(dateCoproFinder, DateFormat.yMd().format(dateCopro));
    Finder txtSGI = find.ancestor(of: find.text(S.current.strongles_gastro_intestinaux),matching: find.byType(TextField),);
    await tester.enterText(txtSGI, copro["SGI"]);
    await tester.pumpAndSettle();
    Finder txtCoc = find.ancestor(of: find.text(S.current.coccidie),matching: find.byType(TextField),);
    await tester.enterText(txtCoc, copro["Coc"]);
    await tester.pumpAndSettle();
    Finder tabEffectif = find.text(S.current.copro_effectif);
    await tester.tap(tabEffectif);
    await tester.pumpAndSettle();
    final btSearch = find.byIcon(Icons.settings_remote);
    for (Map<String, dynamic> bete in copro["betes"]) {
      await tester.tap(btSearch);
      await tester.pumpAndSettle();
      await selectBete(bete["numero"]);
      await tester.pumpAndSettle();
    }
    Finder btSave = find.byKey(Key("bt_save"));
    await tester.tap(btSave);
    await tester.pumpAndSettle();/*
    await Future.delayed(Duration(seconds: 10));
    tester.tap(find.backButton());
    await tester.pumpAndSettle();*/
  }

  Future<void> modify(Map<String, dynamic> copro) async {
    await startAppli();
    final Finder btCopro = await findWelcomeButton(
        Key("btSante"), S.current.result_copro);
    await tester.tap(btCopro);
    await tester.pumpAndSettle();
    // Tap sur 1er chevron
    Finder btView = find.byIcon(Icons.chevron_right);
    await tester.tap(btView);
    await tester.pumpAndSettle();
    Finder txtSp = find.ancestor(of: find.text(S.current.strongle_pulm),matching: find.byType(TextField),);
    await tester.enterText(txtSp, copro["SP"]);
    await tester.pumpAndSettle();
    Finder tabEffectif = find.text(S.current.copro_effectif);
    await tester.tap(tabEffectif);
    await tester.pumpAndSettle();
    final btSearch = find.byIcon(Icons.settings_remote);
    for (Map<String, dynamic> bete in copro["bete_ajout"]) {
      await tester.tap(btSearch);
      await tester.pumpAndSettle();
      await selectBete(bete["numero"]);
      await tester.pumpAndSettle();
    }
    for (Map<String, dynamic> bete in copro["bete_supp"]) {
      Finder deleteBete = super.findByClear(bete["numero"]);
      await tester.tap(deleteBete);
      await tester.pumpAndSettle();
      Finder btContinue = find.text(S.current.bt_continue);
      await tester.tap(btContinue);
      await tester.pumpAndSettle();
    }
    Finder btSave = find.byKey(Key("bt_save"));
    await tester.tap(btSave);
    await tester.pumpAndSettle();
  }

}