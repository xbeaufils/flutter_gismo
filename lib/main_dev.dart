import 'package:flutter/material.dart';
import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';

GismoBloc gismoBloc;

//String urlTarget = "http://192.168.1.31:8080/gismoApp/api";
//String urlTarget = "http://10.0.2.2:8080/gismoApp/api";
//String urlTarget = "https://gismo.neme-sys.fr/api";

//String urlWebTarget = "http://10.0.2.2:8080/gismoWeb/bd";
//String urlWebTarget = "https://www.neme-sys.fr/bd";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  gismoBloc = new GismoBloc();
  Environnement.init( "http://10.0.2.2:8080/gismoWeb/bd", "http://192.168.0.13:8080/gismoApp/api");
  //await gismoBloc.init();
  //bool isLogged = false; //gismoBloc.isLogged();
  final GismoApp gismoApp = new GismoApp(gismoBloc,
     initialRoute: '/splash', //isLogged ? '/welcome' : '/config',
  );
  // Run app!
  runApp(gismoApp);
}



