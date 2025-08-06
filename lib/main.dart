
//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/flavor/FlavorOvin.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:sentry/sentry.dart';



void main() async {
  await Sentry.init(
    (options) =>
        options.dsn =
        'https://61d0a2a76b164bdab7d5c8a60f43dcd6@o406124.ingest.sentry.io/5407553'
        /*options.release = ''*/
      ,
      appRunner: () => {
      startApp()
    });
}

void startApp()
  {
    if (!kIsWeb) {
      // if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android))
      WidgetsFlutterBinding.ensureInitialized();
/*
      MobileAds.instance.initialize();
      RequestConfiguration configuration = RequestConfiguration(
          testDeviceIds: ["395AA0EC16134E88603112A34BE6BF57"]);
      MobileAds.instance.updateRequestConfiguration(configuration);*/
    }
    // Pass your access token to MapboxOptions so you can load a map
    String ACCESS_TOKEN = const String.fromEnvironment("map_box_token");
    // MapboxOptions.setAccessToken("pk.eyJ1IjoieGJlYXUiLCJhIjoiY2s4anVjamdwMGVsdDNucDlwZ2I0bGJwNSJ9.lc21my1ozaQZ2-EriDSY5w");

    Environnement.init(
        //"https://www.neme-sys.fr/bd", "http://10.0.2.2:8080/gismoApp/api",
        "https://www.neme-sys.fr/bd", "https://gismo.neme-sys.fr/api",
        new FlavorOvin());
    String nextPage = '/splash';
    if (kIsWeb)
      //if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android))
      nextPage = '/login';

    initializeDateFormatting();
    final GismoApp gismoApp = new GismoApp( RunningMode.run,
      initialRoute: nextPage, //isLogged ? '/welcome' : '/config',
    );
    runApp(gismoApp);
}
  /*
  runZonedGuarded<Future<void>>(() async {
    runApp(gismoApp);
  }, (error, stackTrace) {
       Sentry.captureException(error,stackTrace: stackTrace);
  });
   */



/// This is LetsEncrypt's self-signed trusted root certificate authority
/// certificate, issued under common name: ISRG Root X1 (Internet Security
/// Research Group).  Used in handshakes to negotiate a Transport Layer Security
/// connection between endpoints.  This certificate is missing from older devices
/// that don't get OS updates such as Android 7 and older.  But, we can supply
/// this certificate manually to our HttpClient via SecurityContext so it can be
/// used when connecting to URLs protected by LetsEncrypt SSL certificates.
/// PEM format LE self-signed cert from here: https://letsencrypt.org/certificates/
const String ISRG_X1 = """-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----""";