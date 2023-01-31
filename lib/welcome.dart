import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/menu/MenuPage.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';



class WelcomePage extends StatefulWidget {
  GismoBloc _bloc;
  String ? _message;

  WelcomePage(this._bloc, this._message, {Key ? key}) : super(key: key);

  @override
  _WelcomePageState createState() => new _WelcomePageState(_bloc);
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;

  _WelcomePageState(this._bloc);
  BannerAd ? _adBanner;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.lightGreen,
        appBar: new AppBar(
            title: (_bloc.user != null) ?
              new Text('Gismo ' + _bloc.user!.cheptel!):
              new Text('Erreur de connexion'),
            // N'affiche pas la touche back (qui revient à la SplashScreen
            automaticallyImplyLeading: true,
             ),
//        bottomNavigationBar: this._navigationBar(),
        body:
          ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Card(
                child: Center(
                  child : SingleChildScrollView (
                    scrollDirection: Axis.horizontal,
                    child : ButtonBar(
                      mainAxisSize: MainAxisSize.max,
                      //alignment: MainAxisAlignment.spaceBetween,
                        alignment: MainAxisAlignment.center,
                      buttonMinWidth: 90.0,
                      children: <Widget>[
                        _buildButton("Lot", "assets/Lot.png",_lotPressed),
                        _buildButton("Individu", "assets/brebis.png", _individuPressed),
                        _buildButton("Agneaux", 'assets/jumping_lambs.png', _lambPressed),
                      ])))),
              Card(
                child: Center(
                child:  SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton("Saillie", "assets/saillie.png", _sailliePressed),
                      _buildButton("Echographie", 'assets/ultrasound.png', _echoPressed),
                      _buildButton("Agnelage", 'assets/lamb.png', _lambingPressed),
                    ])))),
              Card(
                child: Center(
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
                  ])))),
              Card(
                child: Center(
                  child: SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child:
                    ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton("Entree", "assets/home.png", _entreePressed), // Entrée
                      _buildButton("Sortie", "assets/Truck.png", _sortiePressed),
                      _buildButton("Parcelles", "assets/parcelles.png", _parcellePressed),
                    //  _buildButton("Lecteur BT", "assets/baton_allflex.png", _choixBt)
                    ])))),

              this._getAdmobAdvice(),
              this._getFacebookAdvice(),
            ]),
        drawer: GismoDrawer(_bloc),);
  }

  Widget _getAdmobAdvice() {
    if (this._bloc.isLogged() ! ) {
      return Container();
    }
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
       return Card(
         child: Container(
            height:  this._adBanner!.size.height.toDouble(),
            width:  this._adBanner!.size.width.toDouble(),
            child: AdWidget(ad:  this._adBanner!)));
    }
/*adWidget;
         AdmobBanner(
           adUnitId: _getBannerAdUnitId(),
           adSize: AdmobBannerSize.BANNER,),
       );
     }*/
    return Container();
  }

  Widget _getFacebookAdvice() {
    if ( this._bloc.isLogged()!  ) {
      return SizedBox(height: 0,width: 0,);
    }
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return
        //Card(child:
          FacebookBannerAd(
            placementId: '212596486937356_212596826937322',
            bannerSize: BannerSize.STANDARD,
            keepAlive: true,
            listener: (result, value) {}
        //  ),
        );
    }
    return Container();
  }

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749~5245883820';
      //return 'ca-app-pub-9699928438497749/5554017347';
    }
    return "";
  }

  Widget _buildButton(String title, String imageName, Function() press) {
    return new TextButton(
        style: textButtonStyle,
        onPressed: press,
        child: new Column(
          children: <Widget>[
            new Image.asset(imageName),
            new Text(title)
          ],
      ));
  }

  final ButtonStyle textButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.white,
    minimumSize: Size(100, 88),
    padding: const EdgeInsets.all(4.0),
    //padding: EdgeInsets.symmetric(horizontal: 16),
    shadowColor:  Colors.grey.withOpacity(0.5),
    elevation: 5,
    shape: const RoundedRectangleBorder(
      //side: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  @override
  void initState() {

    this._adBanner = BannerAd(
      adUnitId: _getBannerAdUnitId(), //'<ad unit ID>',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    this._adBanner!.load();
   FacebookAudienceNetwork.init(
      testingId: "a77955ee-3304-4635-be65-81029b0f5201",
      iOSAdvertiserTrackingEnabled: true,
    );

  }

  @override
  void dispose() {
    super.dispose();
    //this._adBanner!.dispose();
  }

  void _parcellePressed() {
    if (_bloc.user!.subscribe!)
      Navigator.pushNamed(context, '/parcelle');
    else
      this.showMessage("Les parcelles ne sont pas visibles en mode autonome");
  }

  void _settingPressed() {
    Future<dynamic> message = Navigator.pushNamed(context, '/config') ;
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

  void _sortiePressed() {
    Future<dynamic>  message = Navigator.pushNamed(context, '/sortie')  ;
    message.then((message) {
      showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });
  }

  void _entreePressed() {
    Future<dynamic>  message = Navigator.pushNamed(context, '/entree') ;
    message.then((message) {
      showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });
  }

  void showMessage(String ? message) {
    if (message == null) return;
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  void _sailliePressed() {
    Navigator.pushNamed(context, '/saillie');
  }

  void _choixBt() {
    Navigator.pushNamed(context, '/bluetooth');

  }
}
