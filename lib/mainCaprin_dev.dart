import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gismo/env/Environnement.dart';
import 'package:gismo/Gismo.dart';
import 'package:gismo/flavor/FlavorCaprin.dart';
import 'package:sentry/sentry.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (! kIsWeb) {
    // if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android))
    //Admob.initialize(testDeviceIds: ['CDB1827517618849EC4C60C7389786D9']);
    /*FacebookAudienceNetwork.init(
      /*testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",*/
    );*/
  }
  Environnement.init( "http://10.0.2.2:8080/gismoWeb/bd", "http://192.168.1.90:8080/gismoApp/api", new FlavorCaprin());
  String nextPage = '/splash';
  if (kIsWeb)
    //if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android))
    nextPage='/login';
  final GismoApp gismoApp = new GismoApp(RunningMode.run,
     initialRoute: nextPage, //isLogged ? '/welcome' : '/config',
  );
  // Run app!
  /*
  runZonedGuarded<Future<void>>(() async {
    runApp(gismoApp);
  }, (error, stackTrace) {
    gismoBloc.sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  });*/
  await Sentry.init(
        (options) => options.dsn = 'https://61d0a2a76b164bdab7d5c8a60f43dcd6@o406124.ingest.sentry.io/5407553',
    appRunner: () => runApp(gismoApp),
  );

}



