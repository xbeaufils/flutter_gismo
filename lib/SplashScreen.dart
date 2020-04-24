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
    _bloc.init().then( (message) => route(message))
        .catchError( (e)  {_initError(e);});
    //route(null);
  }

  void _initError(e) {
    final snackBar = SnackBar(content: Text(e),);
    debug.log("Error is " + e , name: "SplashScreenState::_initError");
    FocusScope.of(context).unfocus();
    _scaffoldKey.currentState.showSnackBar(snackBar);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  WelcomePage(e),
        ));

  }

  void route(String message) {
    bool _isLogged = _bloc.isLogged();
    debug.log("Is logged " + _isLogged.toString(), name: "SplashScreenState::route");
    Widget homePage = _isLogged ? WelcomePage(message):  ConfigPage(_bloc);
    homePage = WelcomePage(message);
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
        new Image(image: AssetImage('assets/gismo.png')),
        ),

      );
  }
}


