import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

class RobotTest {
  WidgetTester _tester;

  WidgetTester get tester => _tester;

  RobotTest(this._tester) ;

  @protected
  Future<void> startAppli() async {
    // Load app widget.
    await this._tester.pumpWidget(GismoApp(RunningMode.test, initialRoute: '/splash'));
    final splash = find.byKey(ValueKey('splashScreen'));
    await this._tester.pumpAndSettle();
  }


  @protected
  Future<void> selectBete(String numboucle) async {
    final btSearch = find.byKey(ValueKey("searchBar"));
    await this._tester.tap(btSearch);
    final rowBete = find.text(numboucle);
    await this._tester.tap(rowBete);
  }

  Future<void> selectLamb(String numBoucle) async {
    await tester.tap(this.findWelcomeButton(S.current.lambs));
    await tester.pumpAndSettle();
    await tester.tap(this.findByChevron(numBoucle));
    await tester.pumpAndSettle();

  }

  @protected
  Finder findWelcomeButton(String text) {
    final Finder entreeGrid = find.ancestor(
        of: find.text(text), matching: find.byType(GridTile));
    final Finder entree = find.descendant(
        of: entreeGrid, matching: find.byType(FilledButton));
    return entree;
  }

  Finder findByChevron(String text) {
    Finder tile = find.ancestor(
        of: find.text(text), matching: find.byType(ListTile));
    Finder btView = find.descendant(of: tile, matching: find.byIcon(Icons.chevron_right));
    return btView;
  }

  Finder findByCalendar(String text) {
    Finder tile = find.ancestor(
        of: find.text(text), matching: find.byType(ListTile));
    Finder btView = find.descendant(of: tile, matching: find.byIcon(Icons.calendar_month));
    return btView;
  }

  Finder findByHint(String text) {
    Finder textField = find.ancestor(
      of: find.text(text),
      matching: find.byType(TextField),);
    return textField;
  }
}