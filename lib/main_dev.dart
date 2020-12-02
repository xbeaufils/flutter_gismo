import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';

GismoBloc gismoBloc;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(testDeviceIds: ['CDB1827517618849EC4C60C7389786D9']);
  gismoBloc = new GismoBloc();
  Environnement.init( "http://10.0.2.2:8080/gismoWeb/bd", "http://192.168.0.212:8080/gismoApp/api");
  //await gismoBloc.init();
  //bool isLogged = false; //gismoBloc.isLogged();
  final GismoApp gismoApp = new GismoApp(gismoBloc,
     initialRoute: '/splash', //isLogged ? '/welcome' : '/config',
  );
  // Run app!
  runZonedGuarded<Future<void>>(() async {
    runApp(gismoApp);
  }, (error, stackTrace) {
    gismoBloc.sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  });

}



