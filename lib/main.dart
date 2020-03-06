import 'package:flutter/material.dart';
import 'package:flutter_gismo/ConfigPage.dart';
import 'package:flutter_gismo/Lot/LotPage.dart';
import 'package:flutter_gismo/Mouvement/EntreePage.dart';
import 'package:flutter_gismo/ParcellePage.dart';
import 'package:flutter_gismo/SearchPage.dart';
import 'package:flutter_gismo/Mouvement/SortiePage.dart';
import 'package:flutter_gismo/SplashScreen.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

GismoBloc gismoBloc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  gismoBloc = new GismoBloc();
  //await gismoBloc.init();
  //bool isLogged = false; //gismoBloc.isLogged();
  final GismoApp gismoApp = new GismoApp(
    gismoBloc,
    initialRoute: '/splash', //isLogged ? '/welcome' : '/config',
  );
  // Run app!
  runApp(gismoApp);
}

enum Page {lamb, sanitaire, etat_corporel, individu, sortie  }

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
        '/config':(context) => ConfigPage(this._bloc),
        '/welcome': (context) => WelcomePage(),
        '/nec': (context) => SearchPage(this._bloc, Page.etat_corporel),
        '/search': (context) => SearchPage(this._bloc, Page.individu),
        '/sanitaire' : (context) => SearchPage(this._bloc, Page.sanitaire),
        //'/bete' : (context) => BetePage(this._bloc),
        '/lamb' : (context) => SearchPage(this._bloc, Page.lamb),
        '/sortie': (context) => SortiePage(),
        '/entree': (context) => EntreePage(),
        '/splash' : (context) => SplashScreen(this._bloc),
        '/lot' : (context) => LotPage(),
        '/parcelle' : (context) =>ParcellePage()
      },
    );
  }
}

