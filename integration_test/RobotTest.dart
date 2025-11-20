import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/flavor/FlavorOvin.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_test/flutter_test.dart';

class RobotTest {
  WidgetTester _tester;

  WidgetTester get tester => _tester;

  RobotTest(this._tester) ;

  @protected
  Future<void> startAppli() async {
    // Load app widget.
    Environnement.init(
        "https://www.neme-sys.fr/bd", "http://10.0.2.2:8080/gismoApp/api",
        new FlavorOvin());
    await this._tester.pumpWidget(GismoApp(RunningMode.test, initialRoute: '/splash'));
    await this._pumpUntilFound(find.byType(WelcomePage));
    final splash = find.byKey(ValueKey('splashScreen'));
    await this._tester.pumpAndSettle();
  }

  Future<void> _pumpUntilFound(
      Finder finder, {
        Duration timeout = const Duration(seconds: 10),
        Duration interval = const Duration(milliseconds: 100),
      }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await _tester.pump();
      if (finder.evaluate().isNotEmpty) return;
      await Future.delayed(interval);
    }
    throw Exception('Widget $finder non trouvé après timeout');
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