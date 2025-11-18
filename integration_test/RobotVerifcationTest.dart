import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import 'RobotTest.dart';

class RobotVerificationTest extends RobotTest {
  RobotVerificationTest(super.tester);

  Future<void> verify (List<dynamic> verifs) async {
    await startAppli();
    await tester.tap(findWelcomeButton(S.current.sheep));
    for (Map<String, dynamic> verif in verifs) {
      await tester.pumpAndSettle();
      await selectBete( verif["bete"] );
      await tester.pumpAndSettle();
      if (verif["agnelage"] != null) {
        this._agnelage(verif["agnelage"]);
      }
      if (verif["lot"] != null) {
        this._lot(verif["lot"]);
      }
      if (verif["pesee"] != null) {
        this._pesee(verif["pesee"]);
      }
      if (verif["traitement"] != null) {
        this._traitement(verif["traitement"]);
      }
      if (verif["echo"] != null) {
        this._echo(verif["echo"]);
      }
      await tester.pumpAndSettle();
      await tester.tap(find.backButton());
      await tester.pumpAndSettle(Duration(seconds: 5));
    }
  }

  Future<void> _agnelage(Map<String, dynamic> agnelage) async {
    this._verify("assets/lamb.png", agnelage["nombre"], agnelage["date"]);
  }

  Future<void> _lot(Map<String, dynamic> lot) async {
    this._verify("assets/Lot_entree.png", lot["debut"], lot["nom"]);
  }

  Future<void> _pesee(Map<String, dynamic> pesee) async {
    this._verify("assets/peseur.png", pesee["poids"], pesee["date"]);
  }

  Future<void> _traitement(Map<String, dynamic> traitement) async {
    this._verify("assets/syringe.png", traitement["medicament"],traitement["date"]);
  }

  Future<void> _echo(Map<String, dynamic> echo) async {
    this._verify("assets/ultrasound.png", echo["nombre"],echo["date"]);
  }

  Future<void> _verify(String image, String searchText, String searchDate) async {
    Finder tile = find.ancestor(
        of: find.image(AssetImage(image)), matching: find.byType(ListTile));
    expect(find.descendant(of: tile, matching: find.text(searchText)),
        findsOneWidget);
    expect(find.descendant(of: tile, matching: find.text(searchDate)),
        findsOneWidget);
  }
}