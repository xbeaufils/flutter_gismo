import 'package:flutter/material.dart';
import 'package:flutter_gismo/ConfigPage.dart';
import 'package:flutter_gismo/Lot/LotPage.dart';
import 'package:flutter_gismo/Mouvement/EntreePage.dart';
import 'package:flutter_gismo/Mouvement/SortiePage.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/SplashScreen.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/loginPage.dart';
import 'package:flutter_gismo/parcelle/ParcellePage.dart';
import 'package:flutter_gismo/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

enum GismoPage {lamb, sanitaire, etat_corporel, individu, sortie, lot, pesee, echo  }

class GismoApp extends StatelessWidget {
  final String initialRoute;
  GismoBloc _bloc;
  GismoApp(GismoBloc bloc,{this.initialRoute}) {
    this._bloc = bloc;
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
      localizationsDelegates: [
        //const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
      //home: openHome(),
      initialRoute: this.initialRoute,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
       // '/config':(context) => ConfigPage(this._bloc),
        '/welcome': (context) => WelcomePage(this._bloc, null),
        '/login': (context) => LoginPage(this._bloc),
        '/nec': (context) => SearchPage(this._bloc, GismoPage.etat_corporel),
        '/pesee': (context) => SearchPage(this._bloc, GismoPage.pesee),
        '/search': (context) => SearchPage(this._bloc, GismoPage.individu),
        '/sanitaire' : (context) => SearchPage(this._bloc, GismoPage.sanitaire),
        '/echo' : (context) => SearchPage(this._bloc, GismoPage.echo),
        '/lamb' : (context) => SearchPage(this._bloc, GismoPage.lamb),
        '/sortie': (context) => SortiePage(this._bloc),
        '/entree': (context) => EntreePage(this._bloc),
        '/splash' : (context) => SplashScreen(this._bloc),
        '/lot' : (context) => LotPage(this._bloc),
        '/parcelle' : (context) =>ParcellePage(this._bloc),
        '/config' : (context) =>ConfigPage(this._bloc)
      },
    );
  }
}
