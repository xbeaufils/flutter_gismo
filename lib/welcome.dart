import 'package:flutter/material.dart';
import 'package:flutter_gismo/main.dart';


class WelcomePage extends StatefulWidget {

  WelcomePage( {Key key}) : super(key: key);
  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.lightGreen,
      appBar: new AppBar(
        title: new Text('Gismo ' + gismoBloc.user.cheptel),
        // N'affiche pas la touche back (qui revient à la SplashScreen
        automaticallyImplyLeading: false,
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
/*
                  ListTile(
                      leading: Image.asset('assets/Lot.png'),
                      title: const Text('Parcelles'),
                      onTap: iconButtonPressed
                  ),
  */
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
                crossAxisCount: 3,
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
                          new Text("Traitement")
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

          //Container( child: Image.network("https://placeimg.com/640/480/any", fit: BoxFit.cover)),
              ],
            )
          )]));
  }
  void _parcellePressed(){
    Navigator.pushNamed(context, '/parcelle');

  }

  void _settingPressed() {
    var message = Navigator.pushNamed(context, '/config');
    message.then( (message) {showMessage(message);})
        .catchError( (message) {showMessage(message);});
  }

  void _individuPressed() {
    Navigator.pushNamed(context, '/search');
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