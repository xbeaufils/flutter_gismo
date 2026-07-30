import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/flavor/FlavorOvin.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

class RobotTest {

  DateFormat frenchForm = DateFormat("dd/MM/yyyy");

  WidgetTester _tester;

  WidgetTester get tester => _tester;

  RobotTest(this._tester) ;

  @protected
  Future<void> startAppli() async {
    // Propose par chatGPT
    await _tester.pumpWidget(const SizedBox.shrink());
    await _tester.pumpAndSettle();

    // Load app widget.
    Environnement.init(
        "https://www.neme-sys.fr/bd", "http://10.0.2.2:8080/gismoApp/api",
        new FlavorOvin());
    await this._tester.pumpWidget(GismoApp( initialRoute: '/splash'));
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

  Future<void> pumpUntilGone(
      Finder finder, {
        Duration timeout = const Duration(seconds: 5),
        Duration step = const Duration(milliseconds: 100),
      }) async {
    final end = DateTime.now().add(timeout);

    while (finder.evaluate().isNotEmpty) {
      if (DateTime.now().isAfter(end)) {
        throw TimeoutException(
          'Le widget est toujours présent après $timeout.',
        );
      }
      await this._tester.pump(step);
    }
  }
  @protected
  Future<void> selectBete(String numboucle, Type type) async {
   // final btSearch = find.byKey(ValueKey("searchBar"));
   // await this._tester.tap(btSearch);
    //final rowBete = find.text(numboucle);
    await this._tester.pumpAndSettle();
    final tile = find.ancestor(
      of: find.text(numboucle),
      matching: find.byType(ListTile),
    );
    await tester.ensureVisible(tile);
    await tester.tap(tile);
//    await this._tester.tap(rowBete);
    await this._tester.pumpAndSettle();
    await this._pumpUntilFound(find.byType(type));
  }

  Future<void> selectLamb(String numBoucle, Type type) async {
    Finder btLambs = await this.findWelcomeButton(Key("btTroupeau"), S.current.lambs);
    await tester.tap(btLambs);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 2));
    await tester.tap(this.findByChevron(numBoucle));
    await tester.pumpAndSettle();
    await this._pumpUntilFound(find.byType(type));
  }

  @protected
  Future<Finder> findWelcomeButton(Key key, String text) async {
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
    final Finder button = find.text(text);
    return button;
  }

  Finder findByChevron(String text) {
    Finder tile = find.ancestor(
        of: find.text(text), matching: find.byType(ListTile));
    Finder btView = find.descendant(of: tile, matching: find.byIcon(Icons.chevron_right));
    return btView;
  }

  Finder findByDelete(String text) {
    Finder tile = find.ancestor(
        of: find.text(text), matching: find.byType(ListTile));
    Finder btView = find.descendant(of: tile, matching: find.byIcon(Icons.delete));
    return btView;
  }
  Finder findByClear(String text) {
    Finder tile = find.ancestor(
        of: find.text(text), matching: find.byType(ListTile));
    Finder btView = find.descendant(of: tile, matching: find.byIcon(Icons.clear));
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