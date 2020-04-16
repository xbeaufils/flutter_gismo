import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage( {Key key}) : super(key: key);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Configuration'),
        ),
        body: Column(children: <Widget>[
    ]));
  }

}