import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/ConfigPage.dart';
import 'dart:developer' as debug;

import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/welcome.dart';

class SplashScreen extends StatefulWidget {
  GismoBloc _bloc;
  SplashScreen(this._bloc, {Key key}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState(_bloc);
}

class SplashScreenState extends State<SplashScreen> {

  GismoBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SplashScreenState(this._bloc);

  @override
  void initState()  {
    debug.log("initState" , name: "SplashScreenState:initState");
    super.initState();
    this._bloc.init().then( (message) => route(message))
        .catchError( (e)  {_initError(e);});
    //route(null);
  }

  void _initError(e) {
    debug.log("Error is " + e.toString() , name: "SplashScreenState::_initError");
    this._bloc.setUser(null);
    SnackBar snackBar;
    if (e is String)
      snackBar = SnackBar(content: Text(e),);
    if (e is Exception)
      snackBar = SnackBar(content: Text(e.toString()),);
    FocusScope.of(context).unfocus();
    _scaffoldKey.currentState.showSnackBar(snackBar);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  WelcomePage(_bloc, e.toString()),
        ));

  }

  void route(String message) {
    bool _isLogged = this._bloc.isLogged();
    debug.log("Is logged " + _isLogged.toString(), name: "SplashScreenState::route");
    Widget homePage = _isLogged ? WelcomePage(_bloc, message):  ConfigPage(_bloc);
    homePage = WelcomePage(_bloc, message);
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
      new Center(
        child:
        new Image(image: AssetImage('assets/amalthe.png' /*+ this._bloc.flavor.splashAsset*/)),
        ),

      );
  }
}


