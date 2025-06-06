import 'package:flutter/material.dart';
import 'package:flutter_gismo/infra/ui/ConfigPage.dart';
import 'package:flutter_gismo/Lot/ui/LotPage.dart';
import 'package:flutter_gismo/mouvement/ui/EntreePage.dart';
import 'package:flutter_gismo/mouvement/ui/SortiePage.dart';
import 'package:flutter_gismo/lamb/ui/SearchLambPage.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/infra/ui/SplashScreen.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/infra/ui/bluetooth.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/infra/ui/loginPage.dart';
import 'package:flutter_gismo/memo/ui/MemoListPage.dart';
import 'package:flutter_gismo/parcelle/ParcellePage.dart';
import 'package:flutter_gismo/traitement/ui/selectionTraitement.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

enum RunningMode {test, run}

enum GismoPage {lamb, sanitaire, etat_corporel, individu, sortie, lot, pesee, echo, saillie, sailliePere, note  }

class GismoApp extends StatelessWidget {
  final String initialRoute;
  final RunningMode mode;
  GismoBloc _bloc;
  GismoApp(this._bloc, this.mode, {required this.initialRoute}) {

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gismo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
     //localizationsDelegates: AppLocalizations.localizationsDelegates,
      localizationsDelegates: [
        S.delegate,
        //AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      //home: openHome(),
      initialRoute: this.initialRoute,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
       // '/config':(context) => ConfigPage(this._bloc),
        '/welcome': (context) => WelcomePage(null),
        '/note' : (context) => MemoListPage(),
        '/login': (context) => LoginPage(),
        '/nec': (context) => SearchPage( GismoPage.etat_corporel),
        '/pesee': (context) => SearchPage( GismoPage.pesee),
        '/search': (context) => SearchPage( GismoPage.individu),
        '/sanitaire' : (context) => SelectionPage([]),
        '/echo' : (context) => SearchPage( GismoPage.echo),
        '/lambing' : (context) => SearchPage( GismoPage.lamb),
        '/lamb' : (context) => SearchLambPage(),
        '/sortie': (context) => SortiePage(),
        '/entree': (context) => EntreePage(),
        '/splash' : (context) => SplashScreen(this._bloc),
        '/lot' : (context) => LotPage(),
        '/parcelle' : (context) =>ParcellePage(this._bloc),
        '/config' : (context) =>ConfigPage(),
        '/bluetooth' : (context) =>BluetoothPermissionPage(this._bloc),
        '/saillie' : (context) => SearchPage(GismoPage.saillie),
      },
    );
  }
}
