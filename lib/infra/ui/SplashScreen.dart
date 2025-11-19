import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/infra/ui/ConfigPage.dart';
import 'dart:developer' as debug;

import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/infra/ui/welcome.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen( {Key ? key}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SplashScreenState();

  @override
  void initState()  {
    super.initState();
    debug.log("initState" , name: "SplashScreenState:initState");
    if (! kIsWeb)
      AuthService.init()
        .then( (message) => route(message));
  }


  void route(String message) {
    debug.log("Is logged $AuthService.subscribe ", name: "SplashScreenState::route");
    Widget homePage = WelcomePage();
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => homePage,
          ));

  }
  
  @override
  Widget build(BuildContext context) {
    debug.log("build" , name: "SplashScreenState::build");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.lightGreen[100],
      body:
      new Center(key: Key("splashScreen"),
        child:
        new Image(image: AssetImage('assets/gismo.png')),
        ),

      );
  }
}


