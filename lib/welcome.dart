import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
//import 'package:flutter_gismo/main.dart';


class WelcomePage extends StatefulWidget {
  GismoBloc _bloc;
  String _message;
  WelcomePage( this._bloc, this._message, {Key key}) : super(key: key);
  @override
  _WelcomePageState createState() => new _WelcomePageState(_bloc);
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;

  _WelcomePageState(this._bloc);

  Widget _getStatus(String message) {
    if (message == null)
      message = "";
    Icon iconConnexion = Icon(Icons.person);
    Text userName = new Text("utilisateur local");
    if (_bloc.user == null) {
      iconConnexion = Icon(Icons.error_outline);
      userName = new Text("Erreur utilisateur");
    }
    else {
      if (_bloc.user.subscribe) {
        iconConnexion = Icon(Icons.verified_user);
        userName = new Text(_bloc.user.email);
      }
    }
    return Card(child:
        Row(children: <Widget>[
          iconConnexion,
          userName,
          new Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          ),
          Icon(Icons.notifications ),
          Text(message),
        ],)
      ,
    );
  }

  Widget _getActionButton() {
    if (_bloc.user.subscribe) {
      return IconButton(
        icon: Icon(Icons.cloud_off),
        onPressed: _logoutPressed ,
      );
    }
    return IconButton(
      icon: Icon(Icons.account_box),
      onPressed: _loginPressed ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.lightGreen,
        persistentFooterButtons: <Widget>[
          _getStatus(this.widget._message ) ,
        ],
      appBar: new AppBar(
        title: new Text('Gismo ' + _bloc.user.cheptel),
        // N'affiche pas la touche back (qui revient à la SplashScreen
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // action button
          _getActionButton(),
        ]
    ),
      body:
          Column(
              children: <Widget>[
            Card(child:
              GridView.count(
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                shrinkWrap: true,
                children: <Widget>[
                  Container( child:
                    new FlatButton(
                      onPressed: _parcellePressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/parcelles.png'),
                          new Text("Parcelles")
                        ],
                      )
                  )),

                  Container( child:
                    new FlatButton(
                      onPressed: _lotPressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/Lot.png'),
                          new Text("Lot")
                        ],
                      )
                  )),
                   Container( child:
                    new FlatButton(
                      onPressed: _individuPressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/brebis.png'),
                          new Text("Individu")
                        ],
                      ))),
               ])
          ),
            Card(
                child:
              GridView.count(
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 4,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                shrinkWrap: true,
                children: <Widget>[
                  Container( child:
                    new FlatButton(
                      onPressed: _lambPressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/lamb.png'),
                          new Text("Agnelage")
                        ],
                      ))),
                  Container( child:
                    FlatButton(
                      onPressed: _necPressed,
                      //color: Theme.of(context).accentColor,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/etat_corporel.png'),
                          new Text("Etat corporel")
                        ],
                      ))),
                  Container( child:
                    new FlatButton(
                      onPressed: _traitementPressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/syringe.png'),
                          new Text("Carnet sanitaire")
                        ],
                      ))),
                  Container( child:
                  new FlatButton(
                      onPressed: _traitementPressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/peseur.png'),
                          new Text("Poids")
                        ],
                      ))),
                ])),
            Card(child:
              GridView.count(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
              children: <Widget>[
                Container( child:
                  new FlatButton(
                      onPressed: _entreePressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/home.png'),
                          new Text("Entree")
                        ],
                      ))),
                Container( child:
                  new FlatButton(
                      onPressed: _sortiePressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/Truck.png'),
                          new Text("Sortie")
                        ],
                      ))),
              ])),
            /*
            Card(child:
              GridView.count(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
              children: <Widget>[
                Container( child:
                  new FlatButton(
                      onPressed: _settingPressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/Control-Panel-icon.png'),
                          new Text("Parametres")
                        ],
                      ))),
                Container( child:
                  new FlatButton(
                    onPressed: _settingPressed,
                    child: new Column(
                      children: <Widget>[
                        new Image.asset('assets/gismo-64.png', height: 50, width: 50,fit: BoxFit.fitWidth,),
                        new Text("Connexion")
                    ])
                  )
                )
              ],
            )
          ),*/
              ]));
  }

  @override
  void initState() {
   }

  void _parcellePressed(){
    if (_bloc.user.subscribe)
      Navigator.pushNamed(context, '/parcelle');
    else
      this.showMessage("Les parcelles ne sont pas visibles en mode autonome");
  }

  void _settingPressed() {
    var message = Navigator.pushNamed(context, '/config');
    message.then( (message) {showMessage(message);})
        .catchError( (message) {showMessage(message);});
  }

  void _individuPressed() {
    Navigator.pushNamed(context, '/search');
  }

  void _loginPressed() {
    var navigationResult = Navigator.pushNamed(context, '/login');
    navigationResult.then((message) {
      setState(() {
        this.widget._message = message;
      });
    });
  }

  void _logoutPressed() {
    String message = _bloc.logout();
    setState(() {
      this.widget._message = message;
    });
  }

  void _sortiePressed() {
    var message  = Navigator.pushNamed(context, '/sortie');
    message.then( (message) {showMessage(message);})
        .catchError( (message) {showMessage(message);});
  }

  void _entreePressed() {
    var message  = Navigator.pushNamed(context, '/entree');
    message.then( (message) {showMessage(message);})
        .catchError( (message) {showMessage(message);});
  }

  void showMessage(String message) {
    if (message == null)
      return;
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _traitementPressed() {
    Navigator.pushNamed(context, '/sanitaire');
  }

  void _lambPressed() {
    Navigator.pushNamed(context, '/lamb');
  }

  void _necPressed() {
    Navigator.pushNamed(context, '/nec');
  }

  void _lotPressed() {
    Navigator.pushNamed(context, '/lot');
  }


}