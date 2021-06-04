import 'dart:async';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:sentry/sentry.dart';

GismoBloc gismoBloc= new GismoBloc();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android))
    Admob.initialize(testDeviceIds: ['CDB1827517618849EC4C60C7389786D9']);
  gismoBloc = new GismoBloc();
  Environnement.init( "https://www.neme-sys.fr/bd", "https://gismo.neme-sys.fr/api");
  //await gismoBloc.init();
  //bool isLogged = false; //gismoBloc.isLogged();
  String nextPage = '/login';
  if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android))
    nextPage='/splash';
  final GismoApp gismoApp = new GismoApp(gismoBloc,
    initialRoute: nextPage, //isLogged ? '/welcome' : '/config',
  );
  // Run app!
  await Sentry.init(
      (options) => options.dsn = 'https://61d0a2a76b164bdab7d5c8a60f43dcd6@o406124.ingest.sentry.io/5407553',
      appRunner: () => runApp(gismoApp),
  );

  /*
  runZonedGuarded<Future<void>>(() async {
    runApp(gismoApp);
  }, (error, stackTrace) {
       Sentry.captureException(error,stackTrace: stackTrace);
  });
   */
}


