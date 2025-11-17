import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'RobotTest.dart';

class RobotTestAgnelage extends RobotTest {

  RobotTestAgnelage(super.tester);

  Future<void> create( List<dynamic> agnelages) async {
      await super.startAppli();
      await tester.tap(super.findWelcomeButton(S.current.lambing));
      await tester.pumpAndSettle();
      for (Map<String, dynamic> lambing in agnelages) {
        await super.selectBete(lambing["numero mere"]);
        // Passage à l'ecran Agnelage
        await tester.pumpAndSettle();
        DateTime now = DateTime.now();
        expect(
            find.byWidgetPredicate(
                    (Widget widget) =>
                widget is TextFormField &&
                    widget.controller!.text == DateFormat.yMd().format(now)),
            findsOneWidget);
        expect(find.text(DateFormat.yMd().format(now)), findsOneWidget);
        await tester.enterText(
            find.text(DateFormat.yMd().format(now)), lambing["date"]);

        await tester.tap(find.byKey(Key("btQualite")));
        await tester.pumpAndSettle();
        await tester.tap(find.text(lambing["qualite"]));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key("btAdoption")));
        await tester.pumpAndSettle();
        await tester.tap(find.text(lambing["adoption"]));
        await tester.pumpAndSettle();
        for( Map<String, dynamic> agneau in lambing["agneaux"]) {
          // Ajout d'un agneau
          final btAdd = find.byIcon(Icons.add);
          await tester.tap(btAdd);
          await tester.pumpAndSettle();
          Finder numProvisoireTxt = find.ancestor(
            of: find.text(S.current.provisional_number),
            matching: find.byType(TextField),);
          await tester.enterText(numProvisoireTxt, agneau["numero"]);
          if (agneau["sexe"] == "male") {
            await tester.tap(find.text(S.current.male));
          } else {
            await tester.tap(find.text(S.current.female));
          }
          switch (agneau["etat"]) {
            case "vivant":
              await tester.tap(find.text(S.current.alive));
              break;
            case "mort":
              await tester.tap(find.text(S.current.stillborn));
              break;
            case "avorte" :
              await tester.tap(find.text(S.current.aborted));
              break;
          }
          await tester.tap(find.text(MethodeAllaitement.ALLAITEMENT_MATERNEL.libelle));
          await tester.pump(
              const Duration(seconds: 1)); // finish the menu animation
          switch (agneau["allaitement"]) {
            case "maternel":
              await tester.tap(find.text(MethodeAllaitement.ALLAITEMENT_MATERNEL.libelle).last);
              break;
            case "biberonné":
              await tester.tap(find.text(MethodeAllaitement.BIBERONNE.libelle));
              break;
          }
          await tester.pumpAndSettle(
              const Duration(seconds: 1)); // finish the menu animation
          await tester.tap( find.text(S.current.bt_add));
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
        await tester.tap(find.text(S.current.validate_lambing));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
  }

  Future<void> mort(Map<String, dynamic> lamb) async {
    await startAppli();
    await selectLamb(lamb["numero"]);
    await tester.tap(find.byKey( Key("mortBt")));
    await tester.pumpAndSettle();
    DateTime now = DateTime.now();
    expect(
        find.byWidgetPredicate(
                (Widget widget) =>
            widget is TextFormField &&
                widget.controller!.text == DateFormat.yMd().format(now)),
        findsOneWidget);
    await tester.enterText(
        find.text(DateFormat.yMd().format(now)), lamb["date"]);
    final dropDown = find.byKey(Key("Motif_Key"));
    await tester.tap(dropDown);
    await tester.pump(
        const Duration(seconds: 1)); // finish the menu animation
    //await tester.scrollUntilVisible(find.text(S.current.mort_accident).last, 3);
    final btCreation = find.text(S.current.mort_chetif_maigre);
    await tester.tap(btCreation);
    await tester.pump();
    await tester.tap(find.text(S.current.bt_save));
  }

  Future<void> boucle(List<dynamic> lambs) async {
    await startAppli();
    for (Map<String, dynamic> lamb in lambs) {
      await selectLamb(lamb["numero"]);
      await tester.tap(find.byKey(Key("boucleBt")));
      await tester.pumpAndSettle();
      var numboucleTxt = find.ancestor(
        of: find.text(S.current.identity_number),
        matching: find.byType(TextField),);
      await tester.enterText(numboucleTxt, lamb["num_boucle"]);
      var numMarquageTxt = find.ancestor(
        of: find.text(S.current.flock_number),
        matching: find.byType(TextField),);
      await tester.enterText(numMarquageTxt, lamb["num_marquage"]);
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.current.place_earring));
      await tester.pumpAndSettle();
      await tester.tap(find.backButton()); // Retour à la liste des agneaux
      await tester.pumpAndSettle();
      await tester.tap(find.backButton()); // Retour à la pacge d'accueil
      await tester.pumpAndSettle();
    }
  }
}
