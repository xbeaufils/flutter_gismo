import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
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

  @protected
  Finder findWelcomeButton(String text) {
    final Finder entreeGrid = find.ancestor(
        of: find.text(text), matching: find.byType(GridTile));
    final Finder entree = find.descendant(
        of: entreeGrid, matching: find.byType(FilledButton));
    return entree;
  }

}