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
      SingleChildScrollView(
        child:
          Column(
            children: <Widget>[
              Card(
                child:
                 ButtonBar(
                     alignment: MainAxisAlignment.center,
                     children: <Widget>[
                  //Container( child:
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),],
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(20.0),),
                    padding: const EdgeInsets.all(8.0),
                    child:FlatButton(
                      //  padding: EdgeInsets.all(10.0),
                      //shape:  StadiumBorder(side: BorderSide(color: Colors.blue)),
                      onPressed: _parcellePressed,
                      child: new Column(
                        children: <Widget>[
                          new Image.asset('assets/parcelles.png'),
                          new Text("Parcelles")
                        ],
                      )
                    ),
                 ),
                  Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(10),
                      child:
                      FlatButton(
                        onPressed: _lotPressed,
                        child:
                         Column(
                          children: <Widget>[
                            Image.asset('assets/Lot.png'),
                            Text("Lot")
                          ],
                        )
                      ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                        borderRadius: new BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child:
                      new FlatButton(
                        //shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
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
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  alignment: MainAxisAlignment.center,
                  buttonMinWidth: 120.0,
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), )],
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(20.0),),
                      padding: const EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(10),
                      child:
                        FlatButton(
                          onPressed: _lambPressed,
                          child: Column(children: <Widget>[
                             Image.asset('assets/lamb.png'),
                             Text("Agnelage"),],),
                        ),
                    ),// Agnelage
                    Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child:
                      new FlatButton(
                          onPressed: _traitementPressed,
                          child: Column(children: <Widget>[
                            Image.asset('assets/syringe.png'),
                            Text("Carnet sanitaire"),
                          ])),
                    ),// Carnet sanitaire
                  ]),
              ),
            Card(
              child:
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  alignment: MainAxisAlignment.center,
                  buttonMinWidth: 120.0,
                  children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10),
                    child:
                      FlatButton(
                          onPressed: _necPressed,
                          child:
                          Column(children: <Widget>[
                            Image.asset('assets/etat_corporel.png'),
                            Text("Etat corporel"),])
                      ),
                    ), //Etat corporel
                    Container(
                      decoration: new BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), ),
                        ],
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(10),
                      child:
                      FlatButton(
                          onPressed: _peseePressed,
                          child: Column(children: <Widget>[
                            Image.asset('assets/peseur.png'),
                            Text("Poids"),
                          ])
                      ),
                    ), // Pesée
                  ]),
            ),
    /*
              GridView.count(
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                shrinkWrap: true,
                children: <Widget>[
                           /*
                          child: new Row(
                            children: <Widget>[
                              new Image.asset('assets/peseur.png'),
                              new Text("Poids")
                            ],
                          ))*/
                      )
                ])),
                */

            Card(child:
            ButtonBar(
                alignment:MainAxisAlignment.center,
                buttonMinWidth: 120.0,
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10),
                    child:
                    FlatButton(
                        onPressed: _entreePressed,
                        child: new Column(
                          children: <Widget>[
                            new Image.asset('assets/home.png'),
                            new Text("Entree")
                          ],
                        )),
                  ), // Entrée
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10),
                    child:
                    FlatButton(
                        onPressed: _sortiePressed,
                        child: new Column(
                          children: <Widget>[
                            new Image.asset('assets/Truck.png'),
                            new Text("Sortie")
                          ],
                        )),
                  )])),
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
              ])));
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

  void _peseePressed() {
    Navigator.pushNamed(context, '/pesee');
  }

  void _lotPressed() {
    Navigator.pushNamed(context, '/lot');
  }


}