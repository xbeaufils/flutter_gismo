import 'package:flutter/material.dart';
import 'package:flutter_gismo/ConfigPage.dart';
import 'package:flutter_gismo/Lot/LotPage.dart';
import 'package:flutter_gismo/Mouvement/EntreePage.dart';
import 'package:flutter_gismo/Mouvement/SortiePage.dart';
import 'package:flutter_gismo/SearchLambPage.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/SplashScreen.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/bluetooth.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/loginPage.dart';
import 'package:flutter_gismo/memo/MemoListPage.dart';
import 'package:flutter_gismo/parcelle/ParcellePage.dart';
import 'package:flutter_gismo/traitement/selectionTraitement.dart';
import 'package:flutter_gismo/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


enum GismoPage {lamb, sanitaire, etat_corporel, individu, sortie, lot, pesee, echo, saillie, sailliePere, note  }

class GismoApp extends StatelessWidget {
  final String initialRoute;
  GismoBloc _bloc;
  GismoApp(this._bloc,{required this.initialRoute}) ;

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
        '/welcome': (context) => WelcomePage(this._bloc, null),
        '/note' : (context) => MemoListPage(this._bloc),
        '/login': (context) => LoginPage(this._bloc),
        '/nec': (context) => SearchPage(this._bloc, GismoPage.etat_corporel),
        '/pesee': (context) => SearchPage(this._bloc, GismoPage.pesee),
        '/search': (context) => SearchPage(this._bloc, GismoPage.individu),
        '/sanitaire' : (context) => SelectionPage(this._bloc),
        '/echo' : (context) => SearchPage(this._bloc, GismoPage.echo),
        '/lambing' : (context) => SearchPage(this._bloc, GismoPage.lamb),
        '/lamb' : (context) => SearchLambPage(this._bloc),
        '/sortie': (context) => SortiePage(this._bloc),
        '/entree': (context) => EntreePage(this._bloc),
        '/splash' : (context) => SplashScreen(this._bloc),
        '/lot' : (context) => LotPage(this._bloc),
        '/parcelle' : (context) =>ParcellePage(this._bloc),
        '/config' : (context) =>ConfigPage(this._bloc),
        '/bluetooth' : (context) =>BluetoothPermissionPage(this._bloc),
        '/saillie' : (context) => SearchPage(this._bloc,GismoPage.saillie),
      },
    );
  }
}
