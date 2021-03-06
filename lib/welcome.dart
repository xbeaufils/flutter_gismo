import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
//import 'package:flutter_gismo/main.dart';

class WelcomePage extends StatefulWidget {
  GismoBloc _bloc;
  String _message;

  WelcomePage(this._bloc, this._message, {Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => new _WelcomePageState(_bloc);
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;

  _WelcomePageState(this._bloc);

  Widget _getStatus(String message) {
    if (message == null) message = "";
    Icon iconConnexion = Icon(Icons.person);
    Text userName = new Text("utilisateur local");
    if (_bloc.user == null) {
      iconConnexion = Icon(Icons.error_outline);
      userName = new Text("Erreur utilisateur");
    } else
      if (_bloc.user.subscribe == null) {
        iconConnexion = Icon(Icons.error_outline);
        userName = new Text("Erreur utilisateur");
      } else {

        if (_bloc.user.subscribe) {
        iconConnexion = Icon(Icons.verified_user);
        userName = new Text(_bloc.user.email);
      }
    }
    return Card(
      child: Row(
        children: <Widget>[
          iconConnexion,
          userName,
          new Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          ),
          /*
          Icon(Icons.notifications),
          Text(message),
           */
        ],
      ),
    );
  }

  List<Widget> _getActionButton() {
    List<Widget> actionBtns = new List();
    actionBtns.add(
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: _choixBt,
        ));
    actionBtns.add(
        IconButton(
          icon: Icon(Icons.settings),
        onPressed: _settingPressed,
      ));

    return actionBtns;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.lightGreen,
        persistentFooterButtons: <Widget>[
          _getStatus(this.widget._message),
        ],
        appBar: new AppBar(
            title: (_bloc.user != null) ?
              new Text(  this._bloc.flavor.appName + ' ' + _bloc.user.cheptel):
              new Text('Erreur de connexion'),
            // N'affiche pas la touche back (qui revient à la SplashScreen
            automaticallyImplyLeading: false,
            actions: _getActionButton(),
            ),
        body: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Card(
                child: SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child : ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton("Parcelles", "assets/parcelles.png", _parcellePressed),
                      _buildButton("Lot",  "assets/" + this._bloc.flavor.lotAsset,_lotPressed),
                      _buildButton("Individu", "assets/" + this._bloc.flavor.individuAsset, _individuPressed),
                    ]))),
              Card(
                child:  SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton("Echographie", 'assets/ultrasound.png', _echoPressed),
                      _buildButton( this._bloc.flavor.miseBasLibelle , 'assets/' + this._bloc.flavor.miseBasAsset, _lambingPressed),
                      _buildButton( this._bloc.flavor.enfantLibelle, 'assets/' + this._bloc.flavor.enfantAsset, _lambPressed),
                    ]))),
              Card(
                child: SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton("Traitement", "assets/syringe.png",_traitementPressed),
                      _buildButton("Etat corp.", "assets/etat_corporel.png", _necPressed), //Etat corporel
                      _buildButton("Poids", 'assets/peseur.png', _peseePressed), // Pesée
                  ]))),
              Card(
                  child: SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child:
                    ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton("Entree", "assets/home.png", _entreePressed), // Entrée
                      _buildButton("Sortie", "assets/Truck.png", _sortiePressed),
                    //  _buildButton("Lecteur BT", "assets/baton_allflex.png", _choixBt)
                    ]))),
              (this._bloc.isLogged()) ?
                Container():
                Card(child:
                  AdmobBanner(
                    adUnitId: _getBannerAdUnitId(),
                    adSize: AdmobBannerSize.BANNER,),
                  ),
              (this._bloc.isLogged()) ?
                Container():
                Card(child:
                  FacebookBannerAd(
                    placementId: '212596486937356_212596826937322',
                    bannerSize: BannerSize.STANDARD,),
                ),
            ]));
  }

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/5554017347';
    }
    return null;
  }
   Widget _buildButton(String title, String imageName, Function() press) {
    return Container(
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
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(4.0),
      child: new FlatButton(
      //shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
        onPressed: press,
        child: new Column(
          children: <Widget>[
            new Image.asset(imageName),
            new Text(title)
          ],
      )));
  }

  @override
  void initState() {}

  void _parcellePressed() {
    if (_bloc.user.subscribe)
      Navigator.pushNamed(context, '/parcelle');
    else
      this.showMessage("Les parcelles ne sont pas visibles en mode autonome");
  }

  void _settingPressed() {
    var message = Navigator.pushNamed(context, '/config');
    message.then((message) {
      showMessage(message);
      setState(() {

      });
    }).catchError((message) {
      showMessage(message);
    });
  }

  void _individuPressed() {
    Navigator.pushNamed(context, '/search');
  }
/*
  void _loginPressed() {
    var navigationResult = Navigator.pushNamed(context, '/config');
    navigationResult.then((message) {
      setState(() {
        this.widget._message = message;
      });
    });
  }
*/
/*
  void _logoutPressed() {
    Navigator.pushNamed(context, '/config');

    String message = _bloc.logout();
    setState(() {
      this.widget._message = message;
    });

  }
 */

  void _sortiePressed() {
    var message = Navigator.pushNamed(context, '/sortie');
    message.then((message) {
      showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });
  }

  void _entreePressed() {
    var message = Navigator.pushNamed(context, '/entree');
    message.then((message) {
      showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });
  }

  void showMessage(String message) {
    if (message == null) return;
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _traitementPressed() {
    Navigator.pushNamed(context, '/sanitaire');
  }

  void _echoPressed() {
    Navigator.pushNamed(context, '/echo');
  }

  void _lambingPressed() {
    Navigator.pushNamed(context, '/lambing');
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

  void _choixBt() {
    Navigator.pushNamed(context, '/bluetooth');

  }
}
