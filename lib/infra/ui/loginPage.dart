import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/infra/presenter/LoginPresenter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

abstract class LoginContract extends GismoContract {

}

class _LoginPageState extends GismoStatePage<LoginPage> implements LoginContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late LoginPresenter _presenter;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  _LoginPageState() {
    _presenter = LoginPresenter(this);
  }

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
                      new Text(S.of(context).email,),
                      new TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: S.of(context).email,
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      new Text(
                        S.of(context).password,
                      ),
                      new TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: S.of(context).password,
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                       ),
                      new FilledButton(key:null, onPressed: this._presenter.loginWeb(_emailCtrl.text, _passwordCtrl.text),
                          //color: const Color(0xFFe0e0e0),
                          child:
                          new Text(S.of(context).connection,),
                      )
                    ]

                ),

              )
            ]

        ),

      );
  }
}