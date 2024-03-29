//import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/flavor/FlavorOvin.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry/sentry.dart';

GismoBloc gismoBloc = new GismoBloc();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (! kIsWeb) {
    MobileAds.instance.initialize();
    RequestConfiguration configuration = RequestConfiguration(testDeviceIds: ["395AA0EC16134E88603112A34BE6BF57"]);
    await MobileAds.instance.updateRequestConfiguration(configuration);
    //Admob.initialize(testDeviceIds: ['CDB1827517618849EC4C60C7389786D9']);
    /*FacebookAudienceNetwork.init(
      /*testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",*/
    );*/
  }
  gismoBloc = new GismoBloc();
  Environnement.init( "http://10.0.2.2:8080/gismoWeb/bd", /*"http://localhost:8080/gismoApp/api" */ "http://10.0.2.2:8080/gismoApp/api", new FlavorOvin());
  String nextPage = '/splash';
  if (kIsWeb)
    nextPage='/login';
  final GismoApp gismoApp = new GismoApp(gismoBloc,
     initialRoute: nextPage,
  );
  // Run app!
  await Sentry.init(
        (options) => options.dsn = 'https://61d0a2a76b164bdab7d5c8a60f43dcd6@o406124.ingest.sentry.io/5407553',
    appRunner: () => runApp(gismoApp),
  );

}



