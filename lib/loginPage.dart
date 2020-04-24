import 'package:flutter/material.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/welcome.dart';

class LoginPage extends StatefulWidget {
  LoginPage( {Key key}) : super(key: key);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Connexion avec abonnement'),
      ),
      body:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                width: 100.0,
                height: 100.0,
                child:
                new Image.asset('assets/gismo.png',
                  fit:BoxFit.fill,
                ),

              ),

              new Card(key: null,
                child:
                new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "email",
                      ),

                      new TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),

                      new Text(
                        "Mot de passe",
                      ),

                      new TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Mot de passe",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                       ),

                      new RaisedButton(key:null, onPressed:_saveConfig,
                          color: const Color(0xFFe0e0e0),
                          child:
                          new Text(
                            "Connexion",
                            style: new TextStyle(
                                color: const Color(0xFF000000),),
                          )
                      )
                    ]

                ),

              )
            ]

        ),

      );
  }
  _saveConfig() async {
    try {
      String message  = await gismoBloc.saveLogin(_emailCtrl.text, _passwordCtrl.text);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => new WelcomePage(message),
      ));
    }
    catch(e) {
      this.showMessage(e);
    }
  }

  void showMessage(String message) {
    if (message == null)
      return;
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}